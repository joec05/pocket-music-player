import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/global_files.dart';

class CustomAudioPlayingIndicator extends StatefulWidget{
  const CustomAudioPlayingIndicator({
    super.key, 
  });

  @override
  State<CustomAudioPlayingIndicator> createState() =>_CustomAudioPlayingIndicatorState();
}

class _CustomAudioPlayingIndicatorState extends State<CustomAudioPlayingIndicator>{
  RxDouble currentValue = 0.toDouble().obs;
  RxDouble currentValue2 = 0.toDouble().obs;
  RxDouble currentValue3 = 0.toDouble().obs;
  double maxHeight = getScreenWidth() * 0.1;

  @override void initState(){
    super.initState();
    appStateRepo.audioHandler!.audioPlayer.playingStream.listen((playing){
      if(mounted){
        MyAudioHandler? handler = appStateRepo.audioHandler!;
        bool audioIsSelected = handler.audioPlayer.playerState.processingState == ProcessingState.ready;
        if(audioIsSelected && playing){
          appStateRepo.audioHandler!.audioPlayer.positionStream.listen((event) {
            if(playing){
              currentValue.value = (currentValue.value + maxHeight / 7) % maxHeight;
              currentValue2.value = (currentValue2.value + maxHeight / 5) % maxHeight;
              currentValue3.value = (currentValue3.value + maxHeight / 6) % maxHeight;
            }
          });
        }else{
          if(!appStateRepo.audioHandler!.audioPlayer.playing){}
        }
      }
    });
  }

  @override void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 125),
                  alignment: Alignment.bottomCenter,
                  width: getScreenWidth() * 0.125 / 8,
                  height: currentValue.value,
                  color: Colors.red
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 125),
                  width: getScreenWidth() * 0.125 / 8,
                  height: currentValue2.value,
                  color: Colors.green
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 125),
                  width: getScreenWidth() * 0.125 / 8,
                  height: currentValue3.value,
                  color: Colors.blue
                ),
              ],
            )
          ]
        );
      })
    );
  }
}