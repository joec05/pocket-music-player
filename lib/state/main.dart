import 'package:music_player_app/class/AudioListenCountNotifier.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/service/AudioHandler.dart';
import 'package:music_player_app/streams/UpdateFavouriteStreamClass.dart';
import 'package:music_player_app/streams/UpdatePlaylistStreamClass.dart';

class AppStateClass{
  Map<String, AudioListenCountNotifier> audioListenCount;
  List<String> favouritesList;
  List<PlaylistSongsClass> playlistList;
  MyAudioHandler? audioHandler;
  ImageDataClass? audioImageData;

  AppStateClass({
    required this.audioListenCount,
    required this.favouritesList,
    required this.playlistList,
    required this.audioHandler,
    required this.audioImageData
  });

  void setFavouritesList(List<String> arg){
    favouritesList = arg;
    UpdateFavouriteStreamClass().emitData(
      UpdateFavouriteStreamControllerClass(arg)
    );
  }

  void setPlaylistList(String playlistID, List<PlaylistSongsClass> arg){
    playlistList = arg;
    UpdatePlaylistStreamClass().emitData(
      UpdatePlaylistStreamControllerClass(playlistID, arg)
    );
  }
}

final appStateClass = AppStateClass(
  audioListenCount: {}, 
  favouritesList: [], 
  playlistList: [], 
  audioHandler: null,
  audioImageData: null
);
