import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

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

  @override initState(){
    super.initState();
    audioCompleteData = widget.audioCompleteData;
    controller = SongOptionController(
      context, 
      audioCompleteData, 
      widget.playlistSongsData
    );
    controller.initialize();
    appStateRepo.audioHandler?.audioPlayer.playingStream.listen((event) {
      if(appStateRepo.audioHandler?.currentAudioUrl == audioCompleteData.audioUrl) {
        if(!event) {
          appStateRepo.soundwaveAnimationController?.stop();
        } else {
          appStateRepo.soundwaveAnimationController?.repeat();
        }
      }
    });
  }

  void playAudio() async {
    List<String> directorySongsList = [...widget.directorySongsList];
    List<String> directorySongsListShuffled = [...widget.directorySongsList];
    directorySongsListShuffled.shuffle();
    appStateRepo.audioHandler!.updateListDirectory(
      directorySongsList, directorySongsListShuffled
    );
    appStateRepo.audioHandler!.setCurrentSong(audioCompleteData);
    appStateRepo.audioHandler!.play();
  }
  
  @override
  Widget build(BuildContext context){
    bool audioIsSelected = audioCompleteData.playerState == AudioPlayerState.playing || audioCompleteData.playerState == AudioPlayerState.paused;
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
        splashFactory: InkRipple.splashFactory,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
          color: audioIsSelected || appStateRepo.audioHandler!.currentAudioUrl == audioCompleteData.audioUrl ? Colors.grey.withOpacity(0.6) : Colors.transparent,
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
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: MemoryImage(
                                    audioCompleteData.audioMetadataInfo.albumArt == null ?
                                      appStateRepo.audioImageData!
                                    : 
                                      audioCompleteData.audioMetadataInfo.albumArt!
                                  ), 
                                  fit: BoxFit.fill,
                                  onError: (exception, stackTrace) => Image.memory(appStateRepo.audioImageData!),
                                )
                              )
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
                                    fontSize: 17), maxLines: 1, overflow: TextOverflow.ellipsis
                                  )
                                ),
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
}