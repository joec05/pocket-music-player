import 'package:music_player_app/appdata/GlobalEnums.dart';
import 'package:music_player_app/class/AudioMetadataInfoClass.dart';

class AudioCompleteDataClass{
  final String audioUrl;
  final AudioMetadataInfoClass audioMetadataInfo;
  AudioPlayerState playerState;
  bool deleted;

  AudioCompleteDataClass(this.audioUrl, this.audioMetadataInfo, this.playerState, this.deleted);
}