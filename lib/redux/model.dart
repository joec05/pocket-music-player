import 'package:music_player_app/models/audio_complete_data/audio_complete_data_notifier.dart';
import 'package:music_player_app/redux/redux_library.dart';

class ViewModel {

  Map<String, AudioCompleteDataNotifier> allAudiosList;
  
  ViewModel({
    required this.allAudiosList
  });

  static ViewModel fromStore(Store<AppState> store) {
    return ViewModel(
      allAudiosList: store.state.allAudiosList,
    );
  }
}
