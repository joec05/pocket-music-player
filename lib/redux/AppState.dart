import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';

class AppState {
  final Map<String, AudioCompleteDataNotifier> allAudiosList;

  AppState(
    this.allAudiosList
  );

  AppState.initialState() :
    allAudiosList = {};
}