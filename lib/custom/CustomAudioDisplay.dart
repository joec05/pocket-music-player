import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';
import 'package:music_player_app/styles/AppStyles.dart';

class CustomAudioDisplayWidget extends StatefulWidget{
  final AudioCompleteDataClass audioCompleteData;
  final Function() onTapped;

  const CustomAudioDisplayWidget({
    super.key, 
    required this.audioCompleteData,
    required this.onTapped,
  });

  @override
  State<CustomAudioDisplayWidget> createState() =>_CustomAudioDisplayWidgetState();
}

class _CustomAudioDisplayWidgetState extends State<CustomAudioDisplayWidget> with SingleTickerProviderStateMixin{
  late AudioCompleteDataClass audioCompleteData;

  @override initState(){
    super.initState();
    audioCompleteData = widget.audioCompleteData;
  }

  @override
  Widget build(BuildContext context){
    if(audioCompleteData.deleted){
      return Container();
    }
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.onTapped,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
          color:  Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: getScreenWidth() * 0.125, height: getScreenWidth() * 0.125,
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.black),
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: MemoryImage(
                                    audioCompleteData.audioMetadataInfo.albumArt.bytes.isEmpty ?
                                      fetchReduxDatabase().audioImageDataClass!.bytes
                                    : 
                                      audioCompleteData.audioMetadataInfo.albumArt.bytes
                                  ), fit: BoxFit.fill
                                )
                              )
                            ),
                          ]
                        ),
                      ),
                    ),
                    SizedBox(width: getScreenWidth() * 0.035),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(child: Text(audioCompleteData.audioMetadataInfo.title ?? getNameFromAudioUrl(audioCompleteData.audioUrl), style: const TextStyle(fontSize: 17), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          SizedBox(height: getScreenHeight() * 0.005),
                          Text(audioCompleteData.audioMetadataInfo.artistName ?? 'Unknown', style: const TextStyle(color: Colors.grey, fontSize: 14),),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        )
      )
    );
  }
}