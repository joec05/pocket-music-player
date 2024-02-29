import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player_app/global_files.dart';

class DisplayArtistSongsWidget extends StatelessWidget {
  final ArtistSongsClass artistSongsData;
  const DisplayArtistSongsWidget({super.key, required this.artistSongsData});

  @override
  Widget build(BuildContext context) {
    return _DisplayArtistSongsWidgetStateful(artistSongsData: artistSongsData);
  }
}

class _DisplayArtistSongsWidgetStateful extends StatefulWidget {
  final ArtistSongsClass artistSongsData;
  const _DisplayArtistSongsWidgetStateful({required this.artistSongsData});

  @override
  State<_DisplayArtistSongsWidgetStateful> createState() => _DisplayArtistSongsWidgetState();
}

class _DisplayArtistSongsWidgetState extends State<_DisplayArtistSongsWidgetStateful> {
  late ArtistSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = ArtistSongsController(context, widget.artistSongsData);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: Text(
          controller.artistSongsData.artistName ?? 'Unknown'
        ), 
        titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Center(
        child: controller.artistSongsData.songsList.isEmpty ? noItemsWidget(FontAwesomeIcons.music, 'songs') : 
        ListView.builder(
          shrinkWrap: false,
          key: UniqueKey(),
          scrollDirection: Axis.vertical,
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.artistSongsData.songsList.length,
          itemBuilder: (context, index){
            if(appStateRepo.allAudiosList[controller.artistSongsData.songsList[index]] == null){
              return Container();
            }
            return ValueListenableBuilder(
              valueListenable: appStateRepo.allAudiosList[controller.artistSongsData.songsList[index]]!.notifier, 
              builder: (context, audioCompleteData, child){
                if(audioCompleteData.audioMetadataInfo.artistName == controller.artistSongsData.artistName){
                  return CustomAudioPlayerWidget(
                    audioCompleteData: audioCompleteData,
                    key: UniqueKey(),
                    directorySongsList: controller.artistSongsData.songsList,
                    playlistSongsData: null
                  );
                }
                return Container();
              }
            );
          },
        )
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


