import 'package:music_player_app/redux/reduxLibrary.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    allAudiosList: allAudiosListReducer(state.allAudiosList, action),
    playlistList: playlistListReducer(state.playlistList, action),
    favouritesList: favouritesListReducer(state.favouritesList, action),
    audioListenCount: audioListenCountReducer(state.audioListenCount, action),
    audioHandlerClass: audioHandlerClassReducer(state.audioHandlerClass, action),
    audioImageDataClass: audioImageDataClassReducer(state.audioImageDataClass, action)
  );
}