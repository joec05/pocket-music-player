import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class DisplayAlbumSongsWidget extends StatelessWidget {
  final AlbumSongsClass albumSongsData;
  const DisplayAlbumSongsWidget({super.key, required this.albumSongsData});

  @override
  Widget build(BuildContext context) {
    return _DisplayAlbumSongsWidgetStateful(albumSongsData: albumSongsData);
  }
}

class _DisplayAlbumSongsWidgetStateful extends StatefulWidget {
  final AlbumSongsClass albumSongsData;
  const _DisplayAlbumSongsWidgetStateful({required this.albumSongsData});

  @override
  State<_DisplayAlbumSongsWidgetStateful> createState() => _DisplayAlbumSongsWidgetState();
}

class _DisplayAlbumSongsWidgetState extends State<_DisplayAlbumSongsWidgetStateful> {
  late AlbumSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = AlbumSongsController(context, widget.albumSongsData.obs);
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
          controller.albumSongsData.value.albumName ?? 'Unknown'
        ), 
      titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Obx(() {
        AlbumSongsClass albumData = controller.albumSongsData.value;
        return Center(
          child: albumData.songsList.isEmpty ? noItemsWidget(FontAwesomeIcons.music, 'songs') :
          ListView.builder(
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: albumData.songsList.length,
            itemBuilder: (context, index){
              if(appStateRepo.allAudiosList[albumData.songsList[index]] == null){
                return Container();
              }

              return Obx(() {
                final audioNotifier = appStateRepo.allAudiosList[albumData.songsList[index]]!.notifier;
                final AudioCompleteDataClass audioCompleteData = audioNotifier.value;

                if(audioCompleteData.audioMetadataInfo.albumName == controller.albumSongsData.value.albumName &&
                  ///audioCompleteData.audioMetadataInfo.albumArtistName == controller.albumSongsData.value.artistName){
                  audioCompleteData.audioMetadataInfo.artistName == controller.albumSongsData.value.artistName){
                  return CustomAudioPlayerWidget(
                    audioCompleteData: audioCompleteData,
                    key: UniqueKey(),
                    directorySongsList: albumData.songsList,
                    playlistSongsData: null
                  );
                }

                return Container();
              });
            }
          )
        );
      }),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


