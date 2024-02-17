import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class SortedAlbumsController {
  BuildContext context;
  ValueNotifier<List<AlbumSongsClass>> albumsSongsList = ValueNotifier([]);
  late StreamSubscription editAudioDataStreamClassSubscription;
  late StreamSubscription deleteAudioDataStreamClassSubscription;
  
  SortedAlbumsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    fetchLocalSongs();
    editAudioDataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        fetchLocalSongs();
      }
    });
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass audioData = data.audioData;
        List<AlbumSongsClass> albumsSongsListValue = [...albumsSongsList.value];
        for(int i = albumsSongsListValue.length - 1; i >= 0; i--){
          albumsSongsListValue[i].songsList.remove(audioData.audioUrl);
          if(albumsSongsListValue[i].songsList.isEmpty){
            albumsSongsListValue.removeAt(i);
            albumsSongsList.value = [...albumsSongsListValue];
          }
        }
      }
    });
  }

  void dispose(){
    albumsSongsList.dispose();
    editAudioDataStreamClassSubscription.cancel();
    deleteAudioDataStreamClassSubscription.cancel();
  }
  
  void fetchLocalSongs() async{
    Map<String, AudioCompleteDataNotifier> allSongs = appStateRepo.allAudiosList;
    List<AlbumSongsClass> albumsSongsListFetched = [];
    for(var songData in allSongs.values){
      if(await File(songData.audioID).exists()){
        AudioMetadataInfoClass metadataInfo = songData.notifier.value.audioMetadataInfo;
        int albumIndex = albumsSongsListFetched.indexWhere((element){
          return element.albumName == metadataInfo.albumName && element.artistName == metadataInfo.albumArtistName;
        });
        if(albumIndex > -1){
          albumsSongsListFetched[albumIndex].songsList.add(
            songData.audioID
          );
        }else{
          albumsSongsListFetched.add(
            AlbumSongsClass(
              metadataInfo.albumName, metadataInfo.albumArtistName,
              metadataInfo.albumArt, [songData.audioID]
            )
          );
        }
      }
    }
    albumsSongsList.value = [...albumsSongsListFetched];
  }
}