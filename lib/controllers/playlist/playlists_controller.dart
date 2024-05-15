import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class PlaylistsController {
  final BuildContext context;
  List<PlaylistSongsModel> playlistsSongsList = List<PlaylistSongsModel>.from([]).obs;
  late StreamSubscription deleteAudioDataStreamClassSubscription;
  late StreamSubscription updatePlaylistStreamClassSubscription;

  PlaylistsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    if(mounted){
      playlistsSongsList.assignAll(appStateRepo.playlistList);
    }
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass audioData = data.audioData;
        List<PlaylistSongsModel> playlistsSongs = [...playlistsSongsList];
        for(int i = playlistsSongs.length - 1; i >= 0; i--){
          List<String> songsList = playlistsSongs[i].songsList;
          songsList.remove(audioData.audioUrl);
          playlistsSongs[i].songsList = songsList;
          isarController.putPlaylist(playlistsSongs[i]);

          if(playlistsSongs[i].songsList.isEmpty){
            isarController.deletePlaylist(playlistsSongs[i]);
            playlistsSongs.removeAt(i);
          }
        }
        playlistsSongsList.assignAll([...playlistsSongs]);
      }
    });
    updatePlaylistStreamClassSubscription = UpdatePlaylistStreamClass().updatePlaylistStream.listen((UpdatePlaylistStreamControllerClass data) {
      playlistsSongsList.assignAll(data.playlistsList);
    });
  }

  void dispose(){
    deleteAudioDataStreamClassSubscription.cancel();
    updatePlaylistStreamClassSubscription.cancel();
  }

}