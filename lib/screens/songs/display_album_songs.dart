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
    controller = AlbumSongsController(context, widget.albumSongsData);
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
          controller.albumSongsData.albumName ?? 'Unknown'
        ), 
      titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Center(
        child: controller.albumSongsData.songsList.isEmpty ? noItemsWidget(FontAwesomeIcons.music, 'songs') :
        ListView.builder(
          shrinkWrap: false,
          key: UniqueKey(),
          scrollDirection: Axis.vertical,
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.albumSongsData.songsList.length,
          itemBuilder: (context, index){
            if(appStateRepo.allAudiosList[controller.albumSongsData.songsList[index]] == null){
              return Container();
            }

            return Obx(() {
              final audioNotifier = appStateRepo.allAudiosList[controller.albumSongsData.songsList[index]]!.notifier;
              final AudioCompleteDataClass audioCompleteData = audioNotifier.value;

              if(audioCompleteData.audioMetadataInfo.albumName == controller.albumSongsData.albumName &&
                audioCompleteData.audioMetadataInfo.albumArtistName == controller.albumSongsData.artistName){
                return CustomAudioPlayerWidget(
                  audioCompleteData: audioCompleteData,
                  key: UniqueKey(),
                  directorySongsList: controller.albumSongsData.songsList,
                  playlistSongsData: null
                );
              }

              return Container();
            });
          }
        )
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


