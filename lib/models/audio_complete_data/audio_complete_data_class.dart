import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class AudioCompleteDataClass extends GetxController {
  final String audioUrl;
  final AudioMetadataInfoClass audioMetadataInfo;
  Rx<AudioPlayerState> playerState;  
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