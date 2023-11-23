import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/AudioListenCountNotifier.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/service/AudioHandler.dart';

class AllAudiosList{
  final Map<String, AudioCompleteDataNotifier> payload;
  AllAudiosList(this.payload);
}

class PlaylistList{
  final List<PlaylistSongsClass> payload;
  PlaylistList(this.payload);
}

class FavouritesList{
  final List<String> payload;
  FavouritesList(this.payload);
}

class AudioListenCount{
  final Map<String, AudioListenCountNotifier> payload;
  AudioListenCount(this.payload);
}

class AudioHandlerClass{
  final MyAudioHandler payload;
  AudioHandlerClass(this.payload);
}

class AudioImageDataClass{
  final ImageDataClass payload;
  AudioImageDataClass(this.payload);
}