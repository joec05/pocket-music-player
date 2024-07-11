import 'package:flutter/material.dart';
import 'package:music_player_app/controllers/songs/fetch_songs_controller.dart';
import 'package:music_player_app/global_files.dart';

class AllSongsController {

  final BuildContext context;

  AllSongsController(
    this.context,
  );

  bool get mounted => context.mounted;

  Future<void> initializeController() async {
    //fetchSongsController.fetchLocalSongs(LoadType.initial);
  }

  void dispose(){}

  void scan() async{
    await appStateRepo.audioHandler!.stop().then((value){
      mainPageController.setLoadingState(false, LoadType.scan);
      runDelay(() => fetchSongsController.fetchLocalSongs(LoadType.scan), actionDelayDuration);
    });
  }
}