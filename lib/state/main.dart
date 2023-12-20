import 'package:music_player_app/class/audio_listen_count_notifier.dart';
import 'package:music_player_app/class/image_data_class.dart';
import 'package:music_player_app/class/playlist_songs_class.dart';
import 'package:music_player_app/service/audio_handler.dart';
import 'package:music_player_app/streams/update_favourite_stream_class.dart';
import 'package:music_player_app/streams/update_playlist_stream_class.dart';

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
