import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class PlaylistSongsController {
  final BuildContext context;
  final PlaylistSongsClass playlistSongsData;
  late ValueNotifier<PlaylistSongsClass> playlistSongsDataValue;
  late StreamSubscription updatePlaylistStreamClassSubscription;

  PlaylistSongsController(
    this.context,
    this.playlistSongsData
  );

  bool get mounted => context.mounted;

  void initializeController(){
    playlistSongsDataValue = ValueNotifier(playlistSongsData);
    updatePlaylistStreamClassSubscription = UpdatePlaylistStreamClass().updatePlaylistStream.listen((UpdatePlaylistStreamControllerClass data) {
      if(data.playlistID == playlistSongsDataValue.value.playlistID){
        int findPlaylistIndex = data.playlistsList.indexWhere((e) => e.playlistID == data.playlistID);
        if(mounted){
          if(findPlaylistIndex > -1){
            playlistSongsDataValue.value = data.playlistsList[findPlaylistIndex].copy();
          }
        }
      }
    });
  }

  void dispose(){
    playlistSongsDataValue.dispose();
    updatePlaylistStreamClassSubscription.cancel();
  }
}