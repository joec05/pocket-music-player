import 'package:flutter/material.dart';
import 'package:music_player_app/class/AudioListenCountClass.dart';

class AudioListenCountNotifier{
  final String audioID;
  final ValueNotifier<AudioListenCountClass> notifier;

  AudioListenCountNotifier(this.audioID, this.notifier);
}