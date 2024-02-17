import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class RecentlyAddedSongsController {
  BuildContext context;
  ValueNotifier<List<AudioRecentlyAddedClass>> recentlyAddedSongsData = ValueNotifier([]);
  late StreamSubscription editAudioMetadataStreamClassSubscription;

  RecentlyAddedSongsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    fetchRecentlyAddedSongs();
    editAudioMetadataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        String updatedAudioUrl = data.newAudioData.audioUrl;
        int index = recentlyAddedSongsData.value.indexWhere((e) => e.audioUrl == updatedAudioUrl);
        if(index > -1){
          recentlyAddedSongsData.value.removeAt(index);
        }else{
          recentlyAddedSongsData.value.removeLast();
        }
        recentlyAddedSongsData.value = [
          ...recentlyAddedSongsData.value,
          AudioRecentlyAddedClass(
            updatedAudioUrl, 
            DateTime.now().toIso8601String()
          )
        ];
      }
    });
  }

  void dispose(){
    recentlyAddedSongsData.dispose();
    editAudioMetadataStreamClassSubscription.cancel();
  }

  Future<void> fetchRecentlyAddedSongs() async{
    List<String> allAudioUrl = appStateRepo.allAudiosList.values.map((e) => e.audioID).toList();
    var statResults = await Future.wait([
      for(var path in allAudioUrl) FileStat.stat(path)
    ]);
    for(int i = 0; i < allAudioUrl.length; i++){
      recentlyAddedSongsData.value.add(
        AudioRecentlyAddedClass(allAudioUrl[i], statResults[i].changed.toIso8601String())
      );
    }
    recentlyAddedSongsData.value.sort((a, b) => b.modifiedDate.compareTo(a.modifiedDate));
    recentlyAddedSongsData.value = [...recentlyAddedSongsData.value.sublist(
      0, min(recentlyAddedSongsData.value.length, 15)
    )]; 
  }
}