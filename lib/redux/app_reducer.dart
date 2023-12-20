import 'package:music_player_app/redux/redux_library.dart';

AppState appReducer(AppState state, action) {
  if(action is AllAudiosList){
    return AppState(action.payload);
  }
  return state;
}