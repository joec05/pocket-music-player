import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class PlaylistPageWidget extends StatelessWidget {
  const PlaylistPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlaylistPageWidgetStateful();
  }
}

class _PlaylistPageWidgetStateful extends StatefulWidget {
  const _PlaylistPageWidgetStateful();

  @override
  State<_PlaylistPageWidgetStateful> createState() => _PlaylistPageWidgetState();
}

class _PlaylistPageWidgetState extends State<_PlaylistPageWidgetStateful> with AutomaticKeepAliveClientMixin{

  @override
  void initState(){
    super.initState();
    playlistsController.initializeController();
  }

  @override void dispose(){
    super.dispose();
    playlistsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: Obx (() {
          final searchedText = mainPageController.searchedText.trim().toLowerCase();
          List<PlaylistSongsModel> playlistsSongsList = playlistsController.playlistsSongsList.where((e) {
            final String playlist = e.playlistName.toLowerCase();
            if(playlist.contains(searchedText)) {
              return true;
            }
            return false;
          }).toList();

          if(playlistsSongsList.isEmpty) {
            return noItemsWidget(FontAwesomeIcons.list, 'playlists');
          }
          return ListView.builder(
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: playlistsSongsList.length,
            itemBuilder: (context, index){
              return CustomPlaylistDisplayWidget(
                playlistSongsData: playlistsSongsList[index], 
                key: UniqueKey()
              );
            }
          );
        })
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


