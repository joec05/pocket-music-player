import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class PlaylistsController {
  final BuildContext context;
  ValueNotifier<List<PlaylistSongsClass>> playlistsSongsList = ValueNotifier([]);
  late StreamSubscription deleteAudioDataStreamClassSubscription;
  late StreamSubscription updatePlaylistStreamClassSubscription;

  PlaylistsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    if(mounted){
      playlistsSongsList.value = [...appStateRepo.playlistList];
    }
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass audioData = data.audioData;
        List<PlaylistSongsClass> playlistsSongs = [...playlistsSongsList.value];
        for(int i = playlistsSongs.length - 1; i >= 0; i--){
          playlistsSongs[i].songsList.remove(audioData.audioUrl);
          if(playlistsSongs[i].songsList.isEmpty){
            playlistsSongs.removeAt(i);
            playlistsSongsList.value = [...playlistsSongs];
          }
        }
      }
    });
    updatePlaylistStreamClassSubscription = UpdatePlaylistStreamClass().updatePlaylistStream.listen((UpdatePlaylistStreamControllerClass data) {
      playlistsSongsList.value = [...data.playlistsList];
    });
  }

  void dispose(){
    playlistsSongsList.dispose();
    deleteAudioDataStreamClassSubscription.cancel();
    updatePlaylistStreamClassSubscription.cancel();
  }

}