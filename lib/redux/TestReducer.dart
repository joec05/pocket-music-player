import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/AudioListenCountNotifier.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/service/AudioHandler.dart';
import 'package:redux/redux.dart';
import 'Actions.dart';

final allAudiosListReducer = TypedReducer<Map<String, AudioCompleteDataNotifier>, AllAudiosList>(_allAudiosListReducer);

Map<String, AudioCompleteDataNotifier> _allAudiosListReducer(Map<String, AudioCompleteDataNotifier> state, AllAudiosList action) {
  return action.payload;
}

final playlistListReducer = TypedReducer<List<PlaylistSongsClass>, PlaylistList>(_playlistListReducer);

List<PlaylistSongsClass> _playlistListReducer(List<PlaylistSongsClass> state, PlaylistList action) {
  return action.payload;
}

final favouritesListReducer = TypedReducer<List<String>, FavouritesList>(_favouritesListReducer);

List<String> _favouritesListReducer(List<String> state, FavouritesList action) {
  return action.payload;
}

final audioListenCountReducer = TypedReducer<Map<String, AudioListenCountNotifier>, AudioListenCount>(_audioListenCountReducer);

Map<String, AudioListenCountNotifier> _audioListenCountReducer(Map<String, AudioListenCountNotifier> state, AudioListenCount action) {
  return action.payload;
}

final audioHandlerClassReducer = TypedReducer<MyAudioHandler?, AudioHandlerClass>(_audioHandlerClassReducer);

MyAudioHandler? _audioHandlerClassReducer(MyAudioHandler? state, AudioHandlerClass action) {
  return action.payload;
}

final audioImageDataClassReducer = TypedReducer<ImageDataClass?, AudioImageDataClass>(_audioImageDataClassReducer);

ImageDataClass? _audioImageDataClassReducer(ImageDataClass? state, AudioImageDataClass action) {
  return action.payload;
}