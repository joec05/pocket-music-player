import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

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
    controller = ArtistSongsController(context, widget.artistSongsData.obs);
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
          controller.artistSongsData.value.artistName ?? 'Unknown'
        ), 
        titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Obx(() {
        ArtistSongsClass artistData = controller.artistSongsData.value;
        return Center(
          child: artistData.songsList.isEmpty ? noItemsWidget(FontAwesomeIcons.music, 'songs') : 
          ListView.builder(
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: artistData.songsList.length,
            itemBuilder: (context, index){
              if(appStateRepo.allAudiosList[artistData.songsList[index]] == null){
                return Container();
              }

              return Obx(() {
                final audioNotifier = appStateRepo.allAudiosList[artistData.songsList[index]]!.notifier;
                final AudioCompleteDataClass audioCompleteData = audioNotifier.value;
                
                if(audioCompleteData.audioMetadataInfo.artistName == controller.artistSongsData.value.artistName) {
                  return CustomAudioPlayerWidget(
                    audioCompleteData: audioCompleteData,
                    key: UniqueKey(),
                    directorySongsList: artistData.songsList,
                    playlistSongsData: null
                  );
                }
                
                return Container();
              });
            },
          )
        );
      }),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


