import 'package:flutter/material.dart';
import 'package:music_player_app/class/audio_complete_data_class.dart';

class AudioCompleteDataNotifier{
  final String audioID;
  final ValueNotifier<AudioCompleteDataClass> notifier;

  AudioCompleteDataNotifier(this.audioID, this.notifier);
}