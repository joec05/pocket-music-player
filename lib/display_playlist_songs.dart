import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player_app/class/playlist_songs_class.dart';
import 'package:music_player_app/class/audio_complete_data_notifier.dart';
import 'package:music_player_app/custom/custom_audio_player.dart';
import 'package:music_player_app/custom/custom_currently_playing_bottom_widget.dart';
import 'package:music_player_app/redux/redux_library.dart';
import 'package:music_player_app/streams/update_playlist_stream_class.dart';
import 'package:music_player_app/styles/app_styles.dart';

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
  late PlaylistSongsClass playlistSongsData;
  late StreamSubscription updatePlaylistStreamClassSubscription;

  @override
  void initState(){
    super.initState();
    playlistSongsData = widget.playlistSongsData;
    updatePlaylistStreamClassSubscription = UpdatePlaylistStreamClass().updatePlaylistStream.listen((UpdatePlaylistStreamControllerClass data) {
      if(data.playlistID == playlistSongsData.playlistID){
        int findPlaylistIndex = data.playlistsList.indexWhere((e) => e.playlistID == data.playlistID);
        if(mounted){
          if(findPlaylistIndex > -1){
            playlistSongsData = data.playlistsList[findPlaylistIndex];
            setState((){});
          }
        }
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    updatePlaylistStreamClassSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: Text(playlistSongsData.playlistName), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: StoreConnector<AppState, Map<String, AudioCompleteDataNotifier>>(
        converter: (store) => store.state.allAudiosList,
        builder: (context, Map<String, AudioCompleteDataNotifier> audiosListNotifiers){
          return Center(
            child: ListView.builder(
              shrinkWrap: false,
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              primary: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: playlistSongsData.songsList.length,
              itemBuilder: (context, index){
                if(audiosListNotifiers[playlistSongsData.songsList[index]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: audiosListNotifiers[playlistSongsData.songsList[index]]!.notifier, 
                  builder: (context, audioCompleteData, child){
                    return CustomAudioPlayerWidget(
                      audioCompleteData: audioCompleteData,
                      key: UniqueKey(),
                      directorySongsList: playlistSongsData.songsList,
                      playlistSongsData: playlistSongsData
                    );
                  }
                );
              }
            )
          );
        }
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}