import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/AudioListenCountNotifier.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/service/AudioHandler.dart';

class ViewModel {
  Map<String, AudioCompleteDataNotifier> allAudiosList = {};
  List<PlaylistSongsClass> playlistList = [];
  List<String> favouritesList =  [];
  Map<String, AudioListenCountNotifier> audioListenCount = {};
  MyAudioHandler? audioHandlerClass; 
  ImageDataClass? audioImageDataClass;
  
  ViewModel({
    required this.allAudiosList, required this.playlistList,
    required this.favouritesList, required this.audioListenCount, required this.audioHandlerClass,
    required this.audioImageDataClass
  });

  static ViewModel fromStore(Store<AppState> store) {
    return ViewModel(
      allAudiosList: store.state.allAudiosList,
      playlistList: store.state.playlistList,
      favouritesList: store.state.favouritesList,
      audioListenCount: store.state.audioListenCount,
      audioHandlerClass: store.state.audioHandlerClass,
      audioImageDataClass: store.state.audioImageDataClass
    );
  }
}
