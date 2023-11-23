import 'dart:async';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';

class CurrentAudioStreamControllerClass{
  final AudioCompleteDataClass audioCompleteData;

  CurrentAudioStreamControllerClass(this.audioCompleteData);
}

class CurrentAudioStreamClass {
  static final CurrentAudioStreamClass _instance = CurrentAudioStreamClass._internal();
  late StreamController<CurrentAudioStreamControllerClass> _currentAudioStreamController;

  factory CurrentAudioStreamClass(){
    return _instance;
  }

  CurrentAudioStreamClass._internal() {
    _currentAudioStreamController = StreamController<CurrentAudioStreamControllerClass>.broadcast();
  }

  Stream<CurrentAudioStreamControllerClass> get currentAudioStream => _currentAudioStreamController.stream;


  void removeListener(){
    _currentAudioStreamController.stream.drain();
  }

  void emitData(CurrentAudioStreamControllerClass data){
    if(!_currentAudioStreamController.isClosed){
      _currentAudioStreamController.add(data);
    }
  }

  void dispose(){
    _currentAudioStreamController.close();
  }
}