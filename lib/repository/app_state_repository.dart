import 'package:music_player_app/global_files.dart';

class AppStateRepository{
  Map<String, AudioCompleteDataNotifier> allAudiosList = {};
  Map<String, AudioListenCountNotifier> audioListenCount = {};
  List<String> favouritesList = [];
  List<PlaylistSongsClass> playlistList = [];
  MyAudioHandler? audioHandler;
  ImageDataClass? audioImageData;

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

final appStateRepo = AppStateRepository();
