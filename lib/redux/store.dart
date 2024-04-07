import 'package:redux/redux.dart';
import 'app_state.dart';
import 'app_reducer.dart';

final Store<AppState> store = Store<AppState>(appReducer, initialState: AppState(
  {}
),);
