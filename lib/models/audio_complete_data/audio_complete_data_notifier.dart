import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class AudioCompleteDataNotifier extends GetxController {  
  final String audioID;
  final Rx<AudioCompleteDataClass> notifier;

  AudioCompleteDataNotifier(this.audioID, this.notifier);
}