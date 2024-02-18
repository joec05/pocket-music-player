import 'package:flutter/material.dart';
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
  ValueNotifier<double> currentValue = ValueNotifier(0);
  ValueNotifier<double> currentValue2 = ValueNotifier(0);
  ValueNotifier<double> currentValue3 = ValueNotifier(0);
  double maxHeight = getScreenWidth() * 0.1;

  @override void initState(){
    super.initState();
    appStateRepo.audioHandler.value!.audioPlayer.playingStream.listen((playing){
      if(mounted){
        MyAudioHandler? handler = appStateRepo.audioHandler.value!;
        bool audioIsSelected = handler.audioPlayer.playerState.processingState == ProcessingState.ready;
        if(audioIsSelected && playing){
          appStateRepo.audioHandler.value!.audioPlayer.positionStream.listen((event) {
            if(playing){
              currentValue.value = (currentValue.value + maxHeight / 7) % maxHeight;
              currentValue2.value = (currentValue2.value + maxHeight / 5) % maxHeight;
              currentValue3.value = (currentValue3.value + maxHeight / 6) % maxHeight;
            }
          });
        }else{
          if(!appStateRepo.audioHandler.value!.audioPlayer.playing){}
        }
      }
    });
  }

  @override void dispose(){
    super.dispose();
    //currentValue.dispose();
    //currentValue2.dispose();
    //currentValue3.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: currentValue,
            builder: (context, value, child){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 125),
                    alignment: Alignment.bottomCenter,
                    width: getScreenWidth() * 0.125 / 8,
                    height: value,
                    color: Colors.red
                  ),
                ],
              );
            }
          ),
          ValueListenableBuilder(
            valueListenable: currentValue2,
            builder: (context, value, child){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 125),
                    width: getScreenWidth() * 0.125 / 8,
                    height: value,
                    color: Colors.green
                  ),
                ],
              );
            }
          ),
          ValueListenableBuilder(
            valueListenable: currentValue3,
            builder: (context, value, child){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 125),
                    width: getScreenWidth() * 0.125 / 8,
                    height: value,
                    color: Colors.blue
                  ),
                ],
              );
            }
          )
        ]
      )
    );
  }
}