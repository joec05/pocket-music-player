import 'package:redux/redux.dart';
import 'AppState.dart';
import 'AppReducer.dart';

final Store<AppState> store = Store<AppState>(appReducer, initialState: AppState(
  allAudiosList: {},
  playlistList: [],
  favouritesList: [],
  audioListenCount: {},
  audioHandlerClass: null,
  audioImageDataClass: null
),);
