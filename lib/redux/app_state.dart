import 'package:music_player_app/class/audio_complete_data_notifier.dart';

class AppState {
  final Map<String, AudioCompleteDataNotifier> allAudiosList;

  AppState(
    this.allAudiosList
  );

  AppState.initialState() :
    allAudiosList = {};
}