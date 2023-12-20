import 'package:music_player_app/appdata/global_enums.dart';
import 'package:music_player_app/class/audio_metadata_info_class.dart';

class AudioCompleteDataClass{
  final String audioUrl;
  final AudioMetadataInfoClass audioMetadataInfo;
  AudioPlayerState playerState;  
  bool deleted;

  AudioCompleteDataClass(this.audioUrl, this.audioMetadataInfo, this.playerState, this.deleted);
}