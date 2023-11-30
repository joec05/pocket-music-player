import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/custom/CustomPlaylistDisplay.dart';
import 'package:music_player_app/state/main.dart';
import 'package:music_player_app/streams/DeleteAudioDataStreamClass.dart';
import 'package:music_player_app/streams/UpdatePlaylistStreamClass.dart';

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
  List<PlaylistSongsClass> playlistsSongsList = [];
  late StreamSubscription deleteAudioDataStreamClassSubscription;
  late StreamSubscription updatePlaylistStreamClassSubscription;

  @override
  void initState(){
    super.initState();
    if(mounted){
      playlistsSongsList = appStateClass.playlistList;
    }
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass audioData = data.audioData;
        for(int i = playlistsSongsList.length - 1; i >= 0; i--){
          playlistsSongsList[i].songsList.remove(audioData.audioUrl);
          if(playlistsSongsList[i].songsList.isEmpty){
            playlistsSongsList.removeAt(i);
          }
        }
        setState((){});
      }
    });
    updatePlaylistStreamClassSubscription = UpdatePlaylistStreamClass().updatePlaylistStream.listen((UpdatePlaylistStreamControllerClass data) {
      playlistsSongsList = data.playlistsList;
      setState((){});
    });
  }

  @override void dispose(){
    super.dispose();
    deleteAudioDataStreamClassSubscription.cancel();
    updatePlaylistStreamClassSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: ListView.builder(
          shrinkWrap: false,
          key: UniqueKey(),
          scrollDirection: Axis.vertical,
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: playlistsSongsList.length,
          itemBuilder: (context, index){
            return CustomPlaylistDisplayWidget(playlistSongsData: playlistsSongsList[index], key: UniqueKey());
          }
        ),
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


