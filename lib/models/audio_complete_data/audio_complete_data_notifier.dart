import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class AudioCompleteDataNotifier{
  final String audioID;
  final ValueNotifier<AudioCompleteDataClass> notifier;

  AudioCompleteDataNotifier(this.audioID, this.notifier);
}