import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class DisplayPlaylistSongsWidget extends StatelessWidget {
  final PlaylistSongsClass playlistSongsData;
  const DisplayPlaylistSongsWidget({super.key, required this.playlistSongsData});

  @override
  Widget build(BuildContext context) {
    return _DisplayPlaylistSongsWidgetStateful(playlistSongsData: playlistSongsData);
  }
}

class _DisplayPlaylistSongsWidgetStateful extends StatefulWidget {
  final PlaylistSongsClass playlistSongsData;
  const _DisplayPlaylistSongsWidgetStateful({required this.playlistSongsData});

  @override
  State<_DisplayPlaylistSongsWidgetStateful> createState() => _DisplayPlaylistSongsWidgetState();
}

class _DisplayPlaylistSongsWidgetState extends State<_DisplayPlaylistSongsWidgetStateful> with AutomaticKeepAliveClientMixin{
  late PlaylistSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = PlaylistSongsController(context, widget.playlistSongsData);
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
        title: Text(controller.playlistSongsData.playlistName), 
        titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: controller.playlistSongsDataValue,
          builder: (context, playlistData, child) {
            return ListView.builder(
              shrinkWrap: false,
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              primary: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: playlistData.songsList.length,
              itemBuilder: (context, index){
                if(appStateRepo.allAudiosList[playlistData.songsList[index]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateRepo.allAudiosList[playlistData.songsList[index]]!.notifier, 
                  builder: (context, audioCompleteData, child){
                    return CustomAudioPlayerWidget(
                      audioCompleteData: audioCompleteData,
                      key: UniqueKey(),
                      directorySongsList: playlistData.songsList,
                      playlistSongsData: playlistData
                    );
                  }
                );
              }
            );
          }
        )
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}