import 'package:music_player_app/models/audio_complete_data/audio_complete_data_notifier.dart';

class AppState {
  final Map<String, AudioCompleteDataNotifier> allAudiosList;

  AppState(
    this.allAudiosList
  );

  AppState.initialState() :
    allAudiosList = {};
}