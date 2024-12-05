import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class CustomAudioPlayerWidget extends StatefulWidget{
  final AudioCompleteDataClass audioCompleteData;
  final List<String> directorySongsList;
  final PlaylistSongsModel? playlistSongsData;

  const CustomAudioPlayerWidget({
    super.key, 
    required this.audioCompleteData, 
    required this.directorySongsList,
    required this.playlistSongsData,
  });

  @override
  State<CustomAudioPlayerWidget> createState() =>_CustomAudioPlayerWidgetState();
}

class _CustomAudioPlayerWidgetState extends State<CustomAudioPlayerWidget> with SingleTickerProviderStateMixin {
  late AudioCompleteDataClass audioCompleteData;
  late SongOptionController controller;
  final globalKey = GlobalKey();

  @override initState(){
    super.initState();
    audioCompleteData = widget.audioCompleteData;
    controller = SongOptionController(
      context, 
      audioCompleteData, 
      widget.playlistSongsData
    );
    controller.initialize();
  }

  void playAudio() async {
    List<String> directorySongsList = [...widget.directorySongsList];
    List<String> directorySongsListShuffled = [...widget.directorySongsList];
    directorySongsListShuffled.shuffle();
    appStateRepo.audioHandler!.updateListDirectory(
      directorySongsList, directorySongsListShuffled
    );
    appStateRepo.audioHandler!.setCurrentSong(audioCompleteData.audioUrl);
    appStateRepo.audioHandler!.play();
  }
  
  @override
  Widget build(BuildContext context){
    return GetBuilder<AudioStateController>( 
      id: 'currentAudioUrl',
      builder: (audioStateController) {
        bool audioIsSelected = audioStateController.currentAudioUrl.value == audioCompleteData.audioUrl;
        
        if(audioCompleteData.deleted){
          return Container();
        }
        
        return Material(
          key: UniqueKey(),
          color: Colors.transparent,
          child: InkWell(
            onTap: (){
              runDelay(() => playAudio(), playingDelayDuration);
            },
            splashFactory: InkSparkle.splashFactory,
            child: Container(
              key: globalKey,
              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
              color: audioIsSelected ? Colors.grey.withOpacity(0.6) : Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: getScreenWidth() * 0.125, 
                          height: getScreenWidth() * 0.125,
                          child: Center(
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: getScreenWidth() * 0.125, 
                                  height: getScreenWidth() * 0.125,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.memory(
                                      audioCompleteData.audioMetadataInfo.albumArt == null ?
                                        appStateRepo.audioImageData!
                                      : 
                                        audioCompleteData.audioMetadataInfo.albumArt!,
                                      errorBuilder: (context, exception, stackTrace) => Image.memory(appStateRepo.audioImageData!),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                ),
                                audioIsSelected ? const Center(child: SoundwaveWidget()) : Container(),
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
                                  Flexible(
                                    child: Text(
                                      audioCompleteData.audioMetadataInfo.title ?? audioCompleteData.audioMetadataInfo.fileName,
                                      style: const TextStyle(
                                        fontSize: 16
                                      ), 
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis
                                    )
                                  ),
                                ],
                              ),
                              SizedBox(height: getScreenHeight() * 0.005),
                              Text(audioCompleteData.audioMetadataInfo.artistName ?? 'Unknown', style: const TextStyle(fontSize: 13)),
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      controller.displayOptionsBottomSheet();
                    },
                    child: const Icon(Icons.more_vert)
                  )
                ],
              )
            )
          )
        );
      }
    );
  }
}