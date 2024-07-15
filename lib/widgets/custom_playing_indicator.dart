import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

class CustomAudioPlayingIndicator extends StatefulWidget{
  final double currentValue;
  final double currentValue2;
  final double currentValue3;

  const CustomAudioPlayingIndicator({
    super.key, 
    required this.currentValue,
    required this.currentValue2,
    required this.currentValue3
  });

  @override
  State<CustomAudioPlayingIndicator> createState() =>_CustomAudioPlayingIndicatorState();
}

class _CustomAudioPlayingIndicatorState extends State<CustomAudioPlayingIndicator>{
  double maxHeight = getScreenWidth() * 0.1;

  @override void initState(){
    super.initState();
  }

  @override void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Row(
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
                height: widget.currentValue,
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
                height: widget.currentValue2,
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
                height: widget.currentValue3,
                color: Colors.blue
              ),
            ],
          )
        ]
      )
    );
  }
}