// ignore_for_file: prefer_null_aware_operators

import 'dart:async';
import 'dart:math';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class PlayingBottomController extends GetxController {
  Rx<AudioCompleteDataClass?> audioCompleteData = Rx<AudioCompleteDataClass?>(null);
  RxDouble currentSlidingWidth = 0.toDouble().obs;

  void updateAudioCompleteData(AudioCompleteDataClass? newAudioData) {
    if(audioCompleteData.value?.audioUrl != newAudioData?.audioUrl) {
      audioCompleteData.value = newAudioData;
      audioCompleteData.refresh();
      update(['audioCompleteData']);
    }
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
  final PlayingBottomController controller = Get.put(PlayingBottomController(), permanent: true);
  late StreamSubscription currentAudioStreamClassSubscription;
  late StreamSubscription editAudioMetadataStreamClassSubscription;

  @override initState(){
    super.initState();
    initializeCurrentAudio();
    appStateRepo.audioHandler?.audioPlayer.positionStream.listen((newPosition) {
      if(mounted){
        if(controller.audioCompleteData.value != null && appStateRepo.audioHandler!.audioPlayer.duration != null){
          controller.updateNewPosition(newPosition);
        }
      }
    });
    currentAudioStreamClassSubscription = CurrentAudioStreamClass().currentAudioStream.listen((CurrentAudioStreamControllerClass data) {
      if(mounted){
        controller.updateAudioCompleteData(data.audioCompleteData);
      }
    });
    editAudioMetadataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        if(controller.audioCompleteData.value != null){
          if(appStateRepo.audioHandler!.currentAudioUrl == data.newAudioData.audioUrl){
            controller.updateAudioCompleteData(data.newAudioData);
          }
        }
      }
    });
  }

  void initializeCurrentAudio(){
    if(appStateRepo.audioHandler != null && mounted){
      String? currentAudioUrl = appStateRepo.audioHandler!.currentAudioUrl;

      if(currentAudioUrl == null) {
        return;
      }

      controller.updateAudioCompleteData(appStateRepo.allAudiosList[currentAudioUrl] == null ? null : appStateRepo.allAudiosList[currentAudioUrl]!.notifier.value);
    }
  }

  @override void dispose(){
    super.dispose();
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
        GetBuilder<PlayingBottomController>( 
          id: 'audioCompleteData',
          builder: (controller) {
            AudioCompleteDataClass? audioCompleteDataValue = controller.audioCompleteData.value;

            if(audioCompleteDataValue == null){
              return Container();
            }

            if(audioCompleteDataValue.playerState == AudioPlayerState.stopped || audioCompleteDataValue.deleted){
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: CachedMemoryImage(
                                    width: getScreenWidth() * 0.125, 
                                    height: getScreenWidth() * 0.125,
                                    bytes: audioCompleteDataValue.audioMetadataInfo.albumArt == null ?
                                      appStateRepo.audioImageData!
                                    : 
                                      audioCompleteDataValue.audioMetadataInfo.albumArt!,
                                    uniqueKey: audioCompleteDataValue.audioUrl,
                                    errorBuilder: (context, exception, stackTrace) => Image.memory(appStateRepo.audioImageData!),
                                    errorWidget: Image.memory(appStateRepo.audioImageData!),
                                    fit: BoxFit.cover
                                  )
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
                                              style: const TextStyle(fontSize: 17), 
                                              maxLines: 1, 
                                              overflow: TextOverflow.ellipsis
                                            )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: getScreenHeight() * 0.005),
                                      Text(audioCompleteDataValue.audioMetadataInfo.artistName ?? 'Unknown', style: const TextStyle(fontSize: 14),),
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