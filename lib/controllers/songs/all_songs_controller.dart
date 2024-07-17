import 'package:flutter/material.dart';
import 'package:pocket_music_player/controllers/songs/fetch_songs_controller.dart';
import 'package:pocket_music_player/global_files.dart';

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
      fetchSongsController.fetchLocalSongs(LoadType.scan);
    });
  }
}