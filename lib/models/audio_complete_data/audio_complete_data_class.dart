import 'package:music_player_app/global_files.dart';

class AudioCompleteDataClass{
  final String audioUrl;
  final AudioMetadataInfoClass audioMetadataInfo;
  AudioPlayerState playerState;  
  bool deleted;

  AudioCompleteDataClass(
    this.audioUrl, 
    this.audioMetadataInfo, 
    this.playerState, 
    this.deleted
  );

  AudioCompleteDataClass copy() {
    return AudioCompleteDataClass(
      audioUrl, 
      audioMetadataInfo, 
      playerState, 
      deleted
    );
  }
}