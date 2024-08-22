import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class AppStateRepository extends GetxController {
  RxMap<String, AudioCompleteDataNotifier> allAudiosList = <String, AudioCompleteDataNotifier>{}.obs;
  Map<String, AudioListenCountModel> audioListenCount = {};
  List<FavouriteSongModel> favouritesList = [];
  List<PlaylistSongsModel> playlistList = [];
  MyAudioHandler? audioHandler;
  Uint8List? audioImageData;
  AnimationController? soundwaveAnimationController;

  void setFavouritesList(List<FavouriteSongModel> arg){
    favouritesList = arg;
    UpdateFavouriteStreamClass().emitData(
      UpdateFavouriteStreamControllerClass(arg)
    );
  }

  void setPlaylistList(String playlistID, List<PlaylistSongsModel> arg){
    playlistList = arg;
    UpdatePlaylistStreamClass().emitData(
      UpdatePlaylistStreamControllerClass(playlistID, arg)
    );
  }
}

final appStateRepo = AppStateRepository();
