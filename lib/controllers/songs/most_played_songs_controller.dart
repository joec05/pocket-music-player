import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class MostPlayedSongsController {
  final BuildContext context;
  ValueNotifier<List<AudioListenCountClass>> mostPlayedSongsData = ValueNotifier([]);

  MostPlayedSongsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    fetchLocalSongs();
  }

  void fetchLocalSongs() async{
    if(mounted){
      Map<String, AudioListenCountNotifier> listenCountHistory = appStateRepo.audioListenCount;
      List<AudioListenCountNotifier> values = listenCountHistory.values.toList();
      values.sort((a, b) => b.notifier.value.listenCount.compareTo(a.notifier.value.listenCount));
      mostPlayedSongsData.value = [...values.map((e) => e.notifier.value).toList()];
    }
  }

  void dispose(){
    mostPlayedSongsData.dispose();
  }
}