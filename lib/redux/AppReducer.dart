import 'package:music_player_app/redux/reduxLibrary.dart';

AppState appReducer(AppState state, action) {
  if(action is AllAudiosList){
    return AppState(action.payload);
  }
  return state;
}