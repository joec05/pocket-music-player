import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class DisplayPlaylistSongsWidget extends StatelessWidget {
  final PlaylistSongsModel playlistSongsData;
  const DisplayPlaylistSongsWidget({super.key, required this.playlistSongsData});

  @override
  Widget build(BuildContext context) {
    return _DisplayPlaylistSongsWidgetStateful(playlistSongsData: playlistSongsData);
  }
}

class _DisplayPlaylistSongsWidgetStateful extends StatefulWidget {
  final PlaylistSongsModel playlistSongsData;
  const _DisplayPlaylistSongsWidgetStateful({required this.playlistSongsData});

  @override
  State<_DisplayPlaylistSongsWidgetStateful> createState() => _DisplayPlaylistSongsWidgetState();
}

class _DisplayPlaylistSongsWidgetState extends State<_DisplayPlaylistSongsWidgetStateful> with AutomaticKeepAliveClientMixin{
  late PlaylistSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = PlaylistSongsController(context, widget.playlistSongsData.obs);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: Text(controller.playlistSongsData.value.playlistName), 
        titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Obx(() {
        PlaylistSongsModel playlistData = controller.playlistSongsData.value;
        return Center(
          child: playlistData.songsList.isEmpty ? noItemsWidget(FontAwesomeIcons.music, 'songs') :
          ListView.builder(
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: playlistData.songsList.length,
            itemBuilder: (context, index){
              if(appStateRepo.allAudiosList[playlistData.songsList[index]] == null){
                return Container();
              }

              return Obx(() {
                final audioNotifier = appStateRepo.allAudiosList[playlistData.songsList[index]]!.notifier;
                
                return CustomAudioPlayerWidget(
                  audioCompleteData: audioNotifier.value,
                  key: UniqueKey(),
                  directorySongsList: playlistData.songsList,
                  playlistSongsData: playlistData
                );
              });
            }
          )
        );
      }),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}