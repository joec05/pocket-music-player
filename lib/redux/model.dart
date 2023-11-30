import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';

class ViewModel {
  Map<String, AudioCompleteDataNotifier> allAudiosList = {};
  
  ViewModel({
    required this.allAudiosList
  });

  static ViewModel fromStore(Store<AppState> store) {
    return ViewModel(
      allAudiosList: store.state.allAudiosList,
    );
  }
}
