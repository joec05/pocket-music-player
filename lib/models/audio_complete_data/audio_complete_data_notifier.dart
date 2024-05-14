import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class AudioCompleteDataNotifier extends GetxController {  
  final String audioID;
  final Rx<AudioCompleteDataClass> notifier;

  AudioCompleteDataNotifier(this.audioID, this.notifier);
}