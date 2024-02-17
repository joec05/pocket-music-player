import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

/// Controller used for handling a song file
class SongFileController {

  void deleteSong(BuildContext context, AudioCompleteDataClass audioData) async{
    try{
      AudioCompleteDataClass x = AudioCompleteDataClass(
        audioData.audioUrl, audioData.audioMetadataInfo, AudioPlayerState.stopped, true
      );
      appStateRepo.allAudiosList[audioData.audioUrl]!.notifier.value = x;
      DeleteAudioDataStreamClass().emitData(
        DeleteAudioDataStreamControllerClass(x)
      );
      if(appStateRepo.audioHandler!.currentAudioUrl == audioData.audioUrl){
        appStateRepo.audioHandler!.stop();
      }
      File selectedFile = File(audioData.audioUrl);
      if(await selectedFile.exists()){
        await selectedFile.delete();
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
          tErr.unknown
        );
      }
    }
  }
}

final SongFileController songFileController = SongFileController();