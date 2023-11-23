import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/AudioListenCountNotifier.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/service/AudioHandler.dart';

class AppState{
  Map<String, AudioCompleteDataNotifier> allAudiosList = {};
  List<PlaylistSongsClass> playlistList = [];
  List<String> favouritesList = [];
  Map<String, AudioListenCountNotifier> audioListenCount = {};
  MyAudioHandler? audioHandlerClass;
  ImageDataClass? audioImageDataClass;

  AppState({
    required this.allAudiosList, required this.playlistList,
    required this.favouritesList, required this.audioListenCount, required this.audioHandlerClass,
    this.audioImageDataClass
  });

  AppState.fromAppState(AppState another){
    allAudiosList = another.allAudiosList;
    playlistList = another.playlistList;
    favouritesList = another.favouritesList;
    audioListenCount = another.audioListenCount;
    audioHandlerClass = another.audioHandlerClass;
    audioImageDataClass = another.audioImageDataClass;
  }
  
  @override
  String toString() {
    return 'AppState: {}';
  }
}