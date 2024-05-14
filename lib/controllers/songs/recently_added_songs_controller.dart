import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class RecentlyAddedSongsController {
  BuildContext context;
  List<AudioRecentlyAddedClass> recentlyAddedSongsData = List<AudioRecentlyAddedClass>.from([]).obs;
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
        int index = recentlyAddedSongsData.indexWhere((e) => e.audioUrl == updatedAudioUrl);
        if(index > -1){
          recentlyAddedSongsData.removeAt(index);
        }else{
          recentlyAddedSongsData.removeLast();
        }
        recentlyAddedSongsData.assignAll([
          AudioRecentlyAddedClass(
            updatedAudioUrl, 
            DateTime.now().toIso8601String()
          ),
          ...recentlyAddedSongsData
        ]);
      }
    });
  }

  void dispose(){
    editAudioMetadataStreamClassSubscription.cancel();
  }

  Future<void> fetchRecentlyAddedSongs() async{
    List<String> allAudioUrl = appStateRepo.allAudiosList.values.map((e) => e.audioID).toList();
    var statResults = await Future.wait([
      for(var path in allAudioUrl) FileStat.stat(path)
    ]);
    for(int i = 0; i < allAudioUrl.length; i++){
      recentlyAddedSongsData.add(
        AudioRecentlyAddedClass(allAudioUrl[i], statResults[i].changed.toIso8601String())
      );
    }
    recentlyAddedSongsData.sort((a, b) => b.modifiedDate.compareTo(a.modifiedDate));
    recentlyAddedSongsData.assignAll([...recentlyAddedSongsData.sublist(
      0, min(recentlyAddedSongsData.length, 15)
    )]);; 
  }
}