// ignore_for_file: prefer_null_aware_operators

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class CustomCurrentlyPlayingExpandedWidget extends StatefulWidget{
  const CustomCurrentlyPlayingExpandedWidget({super.key});

  @override
  State<CustomCurrentlyPlayingExpandedWidget> createState() =>_CustomCurrentlyPlayingExpandedWidgetState();
}

class _CustomCurrentlyPlayingExpandedWidgetState extends State<CustomCurrentlyPlayingExpandedWidget>{
  Rx<SongOptionController?> controller = Rx<SongOptionController?>(null);
  Rx<AudioCompleteDataClass?> audioCompleteData = Rx<AudioCompleteDataClass?>(null);
  Rx<Duration> timeRemaining = Duration.zero.obs;
  RxBool isDraggingSlider = false.obs; 
  RxDouble currentPosition = 0.toDouble().obs;
  RxString currentDurationStr = '00:00'.obs; 
  Rx<DurationEndDisplay> displayCurrentDurationType = DurationEndDisplay.totalDuration.obs;
  Rx<LoopStatus> currentLoopStatus = LoopStatus.repeatCurrent.obs;
  late StreamSubscription currentAudioStreamClassSubscription;
  late StreamSubscription editAudioMetadataStreamClassSubscription;

  @override initState(){
    super.initState();
    initializeCurrentAudio();
    currentLoopStatus.value = appStateRepo.audioHandler!.currentLoopStatus;
    updateSliderPosition();
    isDraggingSlider.listen((data) {
      if(mounted){
        if(audioCompleteData.value != null && !isDraggingSlider.value){
          updateSliderPosition();
        }
      }
    });
    appStateRepo.audioHandler!.audioPlayer.positionStream.listen((newPosition) {
      if(mounted){
        if(audioCompleteData.value != null && !isDraggingSlider.value && newPosition.inMilliseconds <= audioCompleteData.value!.audioMetadataInfo.duration){
          currentPosition.value = min((newPosition.inMilliseconds / audioCompleteData.value!.audioMetadataInfo.duration), 1);
          currentDurationStr.value = _formatDuration(newPosition);
          timeRemaining.value = Duration(milliseconds: audioCompleteData.value!.audioMetadataInfo.duration) - newPosition;
        }
      }
    });
    currentAudioStreamClassSubscription = CurrentAudioStreamClass().currentAudioStream.listen((CurrentAudioStreamControllerClass data) {
      if(mounted){
        if(data.audioCompleteData.playerState == AudioPlayerState.stopped){
          Navigator.pop(context);
        }else{
          audioCompleteData.value = data.audioCompleteData;
          controller.value = SongOptionController(
            context, 
            audioCompleteData.value!, 
            null
          );
        }
      }
    });
    editAudioMetadataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        if(audioCompleteData.value != null){
          if(appStateRepo.audioHandler!.currentAudioUrl == data.newAudioData.audioUrl){
            audioCompleteData.value = data.newAudioData;
            controller = Rx<SongOptionController>(
              SongOptionController(
                context, 
                audioCompleteData.value!, 
                null
              )
            );
          }
        }
      }
    });
  }

  void initializeCurrentAudio(){
    if(mounted){
      String currentAudioUrl = appStateRepo.audioHandler!.currentAudioUrl;
      audioCompleteData.value = appStateRepo.allAudiosList[currentAudioUrl] == null ? null : appStateRepo.allAudiosList[currentAudioUrl]!.notifier.value;
      controller.value = SongOptionController(
        context, 
        audioCompleteData.value!, 
        null
      );
    }
  }

  @override void dispose(){
    super.dispose();
    currentAudioStreamClassSubscription.cancel();
    editAudioMetadataStreamClassSubscription.cancel();
  }

  void updateSliderPosition(){
    if(mounted){
      if(appStateRepo.audioHandler != null && audioCompleteData.value != null){
        Duration? currentDuration = appStateRepo.audioHandler!.audioPlayer.duration;
        if(currentDuration != null){
          currentPosition.value = min((currentDuration.inMilliseconds / audioCompleteData.value!.audioMetadataInfo.duration), 1);
          currentDurationStr.value = _formatDuration(currentDuration);
          timeRemaining.value = Duration(milliseconds: audioCompleteData.value!.audioMetadataInfo.duration) - currentDuration;
        }
      }
    }
  }

  void pauseAudio() async{
    await appStateRepo.audioHandler!.pause();
  }  

  void resumeAudio() async{
    await appStateRepo.audioHandler!.play();
  }

  void modifyLoopStatus(LoopStatus loopStatus){
    if(mounted){
      currentLoopStatus.value = loopStatus;
    }
    appStateRepo.audioHandler!.modifyLoopStatus(loopStatus);
  }

  void playNext() async{
    await appStateRepo.audioHandler!.skipToNext();
  }

  void playPrev() async{
    await appStateRepo.audioHandler!.skipToPrevious();
  }

  void onSliderChange(value){ 
    if(mounted){
      isDraggingSlider.value = true;
      currentPosition.value = value;
      var currentSecond = (value * audioCompleteData.value!.audioMetadataInfo.duration/ 1000).floor();
      currentDurationStr.value = formatSeconds(currentSecond);
    }
  }

  void onSliderEnd(value) async{
    if(mounted){
      var duration = ((value * audioCompleteData.value!.audioMetadataInfo.duration) ~/ 10) * 10;
      currentPosition.value = value ;
      isDraggingSlider.value = false;
      await appStateRepo.audioHandler!.audioPlayer.seek(Duration(milliseconds: duration));
    } 
  }

  String _formatDuration(Duration duration) { //convert duration to string
    String hours = (duration.inHours).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (hours == '00') {
      return '$minutes:$seconds';
    } else {
      return '$hours:$minutes:$seconds';
    }
  }

  String formatSeconds(int seconds) { //convert total seconds to string
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;
    
    String formattedTime = '';
    
    if (hours > 0) {
      formattedTime += '${hours.toString().padLeft(2, '0')}:';
    }
    
    formattedTime += '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    
    return formattedTime;
  }

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          AudioCompleteDataClass? audioCompleteDataValue = audioCompleteData.value;
          LoopStatus currentLoopStatusValue = currentLoopStatus.value;
          DurationEndDisplay displayType = displayCurrentDurationType.value;
          
          if(audioCompleteDataValue == null){
            return Container(key: UniqueKey());
          }
          return Container(
            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultVerticalPadding * 2.5),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: getScreenWidth() * 0.7, height: getScreenWidth() * 0.7,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(150),
                          image: DecorationImage(
                            image: MemoryImage(
                              audioCompleteData.value!.audioMetadataInfo.albumArt.bytes.isEmpty ?
                                appStateRepo.audioImageData!.bytes
                              : 
                                audioCompleteData.value!.audioMetadataInfo.albumArt.bytes
                            ), 
                            fit: BoxFit.fill,
                            onError: (exception, stackTrace) => Image.memory(appStateRepo.audioImageData!.bytes),
                          )
                        ),
                      ),
                      SizedBox(height: getScreenHeight() * 0.02),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.02),
                          child: Text(
                            audioCompleteDataValue.audioMetadataInfo.title ??
                            audioCompleteDataValue.audioUrl.split('/').last.trim(), 
                            style: const TextStyle(fontSize: 20), maxLines: 1
                          ),
                        ),
                      ),
                      Text(audioCompleteDataValue.audioMetadataInfo.artistName ?? 'Unknown', style: const TextStyle(color: Colors.grey, fontSize: 16.5),),
                      SizedBox(height: getScreenHeight() * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: getScreenWidth() * 0.07,),
                          GestureDetector(
                            onTap: (){
                              if(currentLoopStatusValue == LoopStatus.repeatCurrent){
                                modifyLoopStatus(LoopStatus.repeatAll);
                              }else if(currentLoopStatusValue == LoopStatus.repeatAll){
                                modifyLoopStatus(LoopStatus.shuffleAll);
                              }else if(currentLoopStatusValue == LoopStatus.shuffleAll){
                                modifyLoopStatus(LoopStatus.repeatCurrent);
                              }
                            },
                            child: currentLoopStatusValue == LoopStatus.repeatCurrent ?
                              const Icon(Icons.repeat_one, size: 30)
                            : currentLoopStatusValue == LoopStatus.repeatAll ?
                              const Icon(Icons.repeat , size: 30)
                            : currentLoopStatusValue == LoopStatus.shuffleAll ?
                              const Icon(Icons.shuffle, size: 30)
                            : Container()
                          ),
                          SizedBox(width: getScreenWidth() * 0.07,),
                          GestureDetector(
                            onTap: () => playPrev(),
                            child: const Icon(Icons.skip_previous, size: 30)
                          ),
                          SizedBox(width: getScreenWidth() * 0.07,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              border: Border.all(width: 6.5, color: defaultCustomButtonColor),
                              color: defaultCustomButtonColor
                            ),
                            child: GestureDetector(
                              onTap: (){
                                if(audioCompleteDataValue.playerState == AudioPlayerState.paused){
                                  resumeAudio();
                                }else if(audioCompleteDataValue.playerState == AudioPlayerState.playing){
                                  pauseAudio();
                                }
                              },
                              child: audioCompleteDataValue.playerState == AudioPlayerState.paused ?
                                const Icon(Icons.play_arrow, size: 35)
                              : const Icon(Icons.pause, size: 35)
                            ),
                          ),
                          SizedBox(width: getScreenWidth() * 0.07,),
                          GestureDetector(
                            onTap: () => playNext(),
                            child: const Icon(Icons.skip_next, size: 30)
                          ),
                          SizedBox(width: getScreenWidth() * 0.07),
                          GestureDetector(
                            onTap: () => controller.value!.displayOptionsBottomSheet(),
                            child: const Icon(Icons.more_vert, size: 30)
                          ),
                          SizedBox(width: getScreenWidth() * 0.07,),
                        ]
                      )
                    ],
                  ),
                  SizedBox(height: getScreenHeight() * 0.04),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 4),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currentDurationStr.value, style: const TextStyle(fontSize: 15)
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(mounted){
                                    if(displayType == DurationEndDisplay.totalDuration){
                                      displayCurrentDurationType.value = DurationEndDisplay.timeRemaining;
                                    }else{
                                      displayCurrentDurationType.value = DurationEndDisplay.totalDuration;
                                    }
                                  }
                                },
                                child: displayType == DurationEndDisplay.totalDuration ?
                                  Text(
                                    _formatDuration(Duration(milliseconds: audioCompleteDataValue.audioMetadataInfo.duration)),
                                    style: const TextStyle(fontSize: 15)
                                  )
                                : 
                                  Text(
                                    _formatDuration(timeRemaining.value), style: const TextStyle(fontSize: 15)
                                  )
                              )
                            ]
                          ),
                        ),
                        SizedBox(height: getScreenHeight() * 0.01),
                        SizedBox(
                          height: 15,
                          child: SliderTheme(
                            data: const SliderThemeData(
                              trackHeight: 3.0,
                              thumbColor: Colors.cyan,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                              activeTrackColor: Colors.blueGrey,
                              inactiveTrackColor: Colors.grey
                            ),
                            child: Slider(
                              min: 0.0,
                              max: 1.0,
                              value: currentPosition.value,
                              onChanged: (newValue) {
                                onSliderChange(newValue);
                              },
                              onChangeEnd: (newValue){
                                onSliderEnd(newValue);
                              },
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          );
        }),
      ],
    );
  }
}