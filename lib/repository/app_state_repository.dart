import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class AppStateRepository {
  Map<String, AudioCompleteDataNotifier> allAudiosList = {};
  Map<String, AudioListenCountModel> audioListenCount = {};
  List<FavouriteSongModel> favouritesList = [];
  List<PlaylistSongsModel> playlistList = [];
  MyAudioHandler? audioHandler;
  ImageDataClass? audioImageData;
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
