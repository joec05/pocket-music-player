import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class PlaylistSongsController {
  final BuildContext context;
  final Rx<PlaylistSongsModel> playlistSongsData;
  late StreamSubscription updatePlaylistStreamClassSubscription;
  late StreamSubscription deleteAudioDataStreamClassSubscription;

  PlaylistSongsController(
    this.context,
    this.playlistSongsData
  );

  bool get mounted => context.mounted;

  void initializeController(){
    updatePlaylistStreamClassSubscription = UpdatePlaylistStreamClass().updatePlaylistStream.listen((UpdatePlaylistStreamControllerClass data) {
      if(data.playlistID == playlistSongsData.value.playlistID){
        int findPlaylistIndex = data.playlistsList.indexWhere((e) => e.playlistID == data.playlistID);
        if(mounted){
          if(findPlaylistIndex > -1){
            playlistSongsData.value = data.playlistsList[findPlaylistIndex].copy();
          }
        }
      }
    });
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted) {
        AudioCompleteDataClass audioData = data.audioData;
        playlistSongsData.value.songsList.remove(audioData.audioUrl);
        playlistSongsData.value = playlistSongsData.value.copy();
        if(playlistSongsData.value.songsList.isEmpty) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  void dispose(){
    updatePlaylistStreamClassSubscription.cancel();
    deleteAudioDataStreamClassSubscription.cancel();
  }
}