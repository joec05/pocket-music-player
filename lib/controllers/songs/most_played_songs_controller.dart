import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class MostPlayedSongsController {
  final BuildContext context;
  List<AudioListenCountModel> mostPlayedSongsData = List<AudioListenCountModel>.from([]).obs;

  MostPlayedSongsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    fetchLocalSongs();
  }

  void fetchLocalSongs() async{
    if(mounted){
      Map<String, AudioListenCountModel> listenCountHistory = appStateRepo.audioListenCount;
      List<AudioListenCountModel> values = listenCountHistory.values.toList();
      values.sort((a, b) => b.listenCount.compareTo(a.listenCount));
      mostPlayedSongsData.assignAll(values);
    }
  }

  void dispose() {}
}