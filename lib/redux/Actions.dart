import 'package:music_player_app/class/audio_complete_data_notifier.dart';

class AllAudiosList{
  final Map<String, AudioCompleteDataNotifier> _payload;

  Map<String, AudioCompleteDataNotifier> get payload => _payload;

  AllAudiosList(this._payload);
}