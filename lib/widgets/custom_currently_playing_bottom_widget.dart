// ignore_for_file: prefer_null_aware_operators

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class PlayingBottomController extends GetxController {
  Rx<AudioCompleteDataClass?> audioCompleteData = Rx<AudioCompleteDataClass?>(null);
  RxDouble currentSlidingWidth = 0.toDouble().obs;

  void updateAudioCompleteData(AudioCompleteDataClass? newAudioData) {
    audioCompleteData.value = newAudioData;
    audioCompleteData.refresh();
    update(['audioCompleteData']);
  }

  void updateNewPosition(Duration newPosition) {
    currentSlidingWidth.value = min((newPosition.inMilliseconds / appStateRepo.audioHandler!.audioPlayer.duration!.inMilliseconds), 1) * getScreenWidth();
    update(['currentSlidingWidth']);
  }
}

class CustomCurrentlyPlayingBottomWidget extends StatefulWidget{
  const CustomCurrentlyPlayingBottomWidget({super.key});

  @override
  State<CustomCurrentlyPlayingBottomWidget> createState() =>_CustomCurrentlyPlayingBottomWidgetState();
}

class _CustomCurrentlyPlayingBottomWidgetState extends State<CustomCurrentlyPlayingBottomWidget> {
  final PlayingBottomController controller = Get.put(PlayingBottomController());
  late StreamSubscription editAudioMetadataStreamClassSubscription;

  @override initState(){
    super.initState();
    appStateRepo.audioHandler?.audioPlayer.positionStream.listen((newPosition) {
      if(mounted){
        if(controller.audioCompleteData.value != null && appStateRepo.audioHandler!.audioPlayer.duration != null){
          controller.updateNewPosition(newPosition);
        }
      }
    });
    appStateRepo.audioHandler?.audioStateController.currentAudioUrl.listen((audioUrl) {
      if(audioUrl == null) {
        controller.updateAudioCompleteData(null);
      } else {
        controller.updateAudioCompleteData(appStateRepo.allAudiosList[audioUrl]?.notifier.value);
      }
    });
    editAudioMetadataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        if(controller.audioCompleteData.value != null){
          if(appStateRepo.audioHandler!.audioStateController.currentAudioUrl.value == data.newAudioData.audioUrl){
            controller.updateAudioCompleteData(data.newAudioData);
          }
        }
      }
    });
  }

  @override void dispose(){
    super.dispose();
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
        GetBuilder<PlayingBottomController>( 
          id: 'audioCompleteData',
          builder: (controller) {
            AudioCompleteDataClass? audioCompleteDataValue = controller.audioCompleteData.value;

            if(audioCompleteDataValue == null){
              return Container();
            }

            if(audioCompleteDataValue.deleted) {
              return Container();
            }
            
            return Material(
              key: UniqueKey(),
              color: Colors.transparent,
              child: GestureDetector(
                onTap: (){
                  if(mounted){
                    expandBottomSheet();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        border: Border(top: BorderSide(width: 1, color: Colors.grey)),
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
                                SizedBox(
                                  width: getScreenWidth() * 0.125, 
                                  height: getScreenWidth() * 0.125,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.memory(
                                      audioCompleteDataValue.audioMetadataInfo.albumArt == null ?
                                        appStateRepo.audioImageData!
                                      : 
                                        audioCompleteDataValue.audioMetadataInfo.albumArt!,
                                      errorBuilder: (context, exception, stackTrace) => Image.memory(appStateRepo.audioImageData!),
                                      fit: BoxFit.cover
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
                                              audioCompleteDataValue.audioMetadataInfo.title ?? audioCompleteDataValue.audioMetadataInfo.fileName, 
                                              style: const TextStyle(fontSize: 16), 
                                              maxLines: 1, 
                                              overflow: TextOverflow.ellipsis
                                            )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: getScreenHeight() * 0.005),
                                      Text(audioCompleteDataValue.audioMetadataInfo.artistName ?? 'Unknown', style: const TextStyle(fontSize: 13)),
                                    ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GetBuilder<AudioStateController>( 
                            id: 'playerState',
                            builder: (controller) {
                              final AudioPlayerState playerState = controller.playerState.value;
                              return GestureDetector(
                                onTap: (){
                                  if(playerState == AudioPlayerState.paused){
                                    resumeAudio();
                                  }else if(playerState == AudioPlayerState.playing){
                                    pauseAudio();
                                  }
                                },
                                child: playerState == AudioPlayerState.paused ?
                                  const Icon(Icons.play_arrow, size: 35)
                                : const Icon(Icons.pause, size: 35)
                              );
                            }
                          )
                        ],
                      )
                    ),
                    GetBuilder<PlayingBottomController>( 
                      id: 'currentSlidingWidth',
                      builder: (controller) {
                        double currentSlidingWidth = controller.currentSlidingWidth.value;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.red,
                              height: 2.5,
                              width: currentSlidingWidth
                            ),
                            Container(
                              color: Colors.grey.withOpacity(0.8),
                              height: 2.5,
                              width: getScreenWidth() - currentSlidingWidth
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