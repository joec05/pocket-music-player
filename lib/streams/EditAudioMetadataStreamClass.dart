import 'dart:async';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';

class EditAudioMetadataStreamControllerClass{
  final AudioCompleteDataClass newAudioData;
  final AudioCompleteDataClass oldAudioData;

  EditAudioMetadataStreamControllerClass(this.newAudioData, this.oldAudioData);
}

class EditAudioMetadataStreamClass {
  static final EditAudioMetadataStreamClass _instance = EditAudioMetadataStreamClass._internal();
  late StreamController<EditAudioMetadataStreamControllerClass> _editAudioMetadataStreamController;

  factory EditAudioMetadataStreamClass(){
    return _instance;
  }

  EditAudioMetadataStreamClass._internal() {
    _editAudioMetadataStreamController = StreamController<EditAudioMetadataStreamControllerClass>.broadcast();
  }

  Stream<EditAudioMetadataStreamControllerClass> get editAudioMetadataStream => _editAudioMetadataStreamController.stream;


  void removeListener(){
    _editAudioMetadataStreamController.stream.drain();
  }

  void emitData(EditAudioMetadataStreamControllerClass data){
    if(!_editAudioMetadataStreamController.isClosed){
      _editAudioMetadataStreamController.add(data);
    }
  }

  void dispose(){
    _editAudioMetadataStreamController.close();
  }
}