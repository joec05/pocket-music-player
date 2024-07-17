import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class AudioCompleteDataClass extends GetxController {
  final String audioUrl;
  AudioMetadataInfoClass audioMetadataInfo;
  bool deleted;

  AudioCompleteDataClass(
    this.audioUrl, 
    this.audioMetadataInfo, 
    this.deleted
  );

  AudioCompleteDataClass copy() {
    return AudioCompleteDataClass(
      audioUrl, 
      audioMetadataInfo, 
      deleted
    );
  }
}