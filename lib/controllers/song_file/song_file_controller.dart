import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

/// Controller used for handling a song file
class SongFileController {

  void deleteSong(BuildContext context, AudioCompleteDataClass audioData) async{
    try{
      appStateRepo.allAudiosList[audioData.audioUrl]!.notifier.value.deleted = true;
      DeleteAudioDataStreamClass().emitData(
        DeleteAudioDataStreamControllerClass(appStateRepo.allAudiosList[audioData.audioUrl]!.notifier.value)
      );
      if(appStateRepo.audioHandler!.audioStateController.currentAudioUrl.value == audioData.audioUrl){
        appStateRepo.audioHandler!.stop();
      }
      File selectedFile = File(audioData.audioUrl);
      if(selectedFile.existsSync()){
        selectedFile.deleteSync();
      }
      if(context.mounted) {
        handler.displaySnackbar(
          context, 
          SnackbarType.successful, 
          tSuccess.deleteSong
        );
      }
    } catch (e) {
      if(context.mounted) {
        handler.displaySnackbar(
          context,
          SnackbarType.error, 
          e.toString()
        );
      }
    }
  }
}

final SongFileController songFileController = SongFileController();