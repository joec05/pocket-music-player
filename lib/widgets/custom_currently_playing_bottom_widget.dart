import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class CustomCurrentlyPlayingBottomWidget extends StatefulWidget{
  const CustomCurrentlyPlayingBottomWidget({super.key});

  @override
  State<CustomCurrentlyPlayingBottomWidget> createState() =>_CustomCurrentlyPlayingBottomWidgetState();
}

class _CustomCurrentlyPlayingBottomWidgetState extends State<CustomCurrentlyPlayingBottomWidget>{
  ValueNotifier<AudioCompleteDataClass?> audioCompleteData = ValueNotifier(null);
  ValueNotifier<double> currentSlidingWidth = ValueNotifier(0);
  late StreamSubscription currentAudioStreamClassSubscription;
  late StreamSubscription editAudioMetadataStreamClassSubscription;

  @override initState(){
    super.initState();
    initializeCurrentAudio();
    if(appStateRepo.audioHandler != null){
      appStateRepo.audioHandler!.audioPlayer.positionStream.listen((newPosition) {
        if(mounted){
          if(audioCompleteData.value != null){
            currentSlidingWidth.value = min((newPosition.inMilliseconds / audioCompleteData.value!.audioMetadataInfo.duration), 1) * getScreenWidth();
          }
        }
      });
    }
    currentAudioStreamClassSubscription = CurrentAudioStreamClass().currentAudioStream.listen((CurrentAudioStreamControllerClass data) {
      if(mounted){
        audioCompleteData.value = data.audioCompleteData.copy();
      }
    });
    editAudioMetadataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        if(audioCompleteData.value != null){
          if(appStateRepo.audioHandler!.currentAudioUrl == data.newAudioData.audioUrl){
            audioCompleteData.value = data.newAudioData.copy();
          }
        }
      }
    });
  }

  void initializeCurrentAudio(){
    if(appStateRepo.audioHandler != null && mounted){
      String currentAudioUrl = appStateRepo.audioHandler!.currentAudioUrl;
      audioCompleteData.value = appStateRepo.allAudiosList[currentAudioUrl] == null ? null : appStateRepo.allAudiosList[currentAudioUrl]!.notifier.value.copy();
    }
  }

  @override void dispose(){
    super.dispose();
    audioCompleteData.dispose();
    currentSlidingWidth.dispose();
    currentAudioStreamClassSubscription.cancel();
    editAudioMetadataStreamClassSubscription.cancel();
  }

  void pauseAudio() async{
    await appStateRepo.audioHandler!.pause();
  }  

  void resumeAudio() async{
    await appStateRepo.audioHandler!.play();
  }

  void expandBottomSheet(){
    if(mounted){
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context){
          return const CustomCurrentlyPlayingExpandedWidget();
        }
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Wrap(
      children: [
        ValueListenableBuilder(
          valueListenable: audioCompleteData, 
          builder: (context, audioCompleteDataValue, child){
            if(audioCompleteDataValue == null){
              return Container();
            }
            if(audioCompleteDataValue.playerState == AudioPlayerState.stopped || audioCompleteDataValue.deleted){
              return Container();
            }
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  if(mounted){
                    expandBottomSheet();
                  }
                },
                splashFactory: InkRipple.splashFactory,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 77, 69, 69),
                        border: Border(top: BorderSide(width: 2, color: Colors.grey)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: getScreenWidth() * 0.125, height: getScreenWidth() * 0.125,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2),
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        audioCompleteData.value!.audioMetadataInfo.albumArt.bytes.isEmpty ?
                                          appStateRepo.audioImageData!.bytes
                                        : 
                                          audioCompleteData.value!.audioMetadataInfo.albumArt.bytes
                                      ), fit: BoxFit.fill
                                    )
                                  ),
                                ),
                                SizedBox(width: getScreenWidth() * 0.035),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              audioCompleteDataValue.audioMetadataInfo.title ?? 
                                              audioCompleteDataValue.audioUrl.split('/').last.trim(), 
                                              style: const TextStyle(fontSize: 17), 
                                              maxLines: 1, 
                                              overflow: TextOverflow.ellipsis
                                            )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: getScreenHeight() * 0.005),
                                      Text(audioCompleteDataValue.audioMetadataInfo.artistName ?? 'Unknown', style: const TextStyle(color: Colors.grey, fontSize: 14),),
                                    ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
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
                          )
                        ],
                      )
                    ),
                    ValueListenableBuilder(
                      valueListenable: currentSlidingWidth, 
                      builder: (context, currentWidth, child){
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.red,
                              height: 2.5,
                              width: currentWidth
                            ),
                          ],
                        );
                      }
                    )
                  ],
                )
              )
            );
          }
        )
      ]
    );
  }
}