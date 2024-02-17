import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class SortedArtistsController {
  BuildContext context;
  ValueNotifier<List<ArtistSongsClass>> artistsSongsList = ValueNotifier([]);
  late StreamSubscription editAudioDataStreamClassSubscription;
  late StreamSubscription deleteAudioDataStreamClassSubscription;

  SortedArtistsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    fetchLocalSongs();
    editAudioDataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass newAudioData = data.newAudioData;
        AudioCompleteDataClass oldAudioData = data.oldAudioData;
        String? newArtistName = newAudioData.audioMetadataInfo.artistName;
        String? oldArtistName = oldAudioData.audioMetadataInfo.artistName;
        List<ArtistSongsClass> artistsSongsListValue = [...artistsSongsList.value];
        if(newArtistName != oldArtistName){
          int findOldIndex = artistsSongsListValue.indexWhere((e) => e.artistName == oldArtistName);
          if(findOldIndex > -1){
            if(artistsSongsListValue[findOldIndex].songsList.length <= 1){
              artistsSongsListValue.removeAt(findOldIndex);
            }else{
              artistsSongsListValue[findOldIndex].songsList.remove(oldAudioData.audioUrl);
            }
          }
          int findNewIndex = artistsSongsListValue.indexWhere((e) => e.artistName == newArtistName);
          if(findNewIndex > -1){
            artistsSongsListValue[findNewIndex].songsList.add(newAudioData.audioUrl);
          }else{
            artistsSongsListValue.add(ArtistSongsClass(
              newArtistName, [newAudioData.audioUrl]
            ));
          }
          artistsSongsList.value = [...artistsSongsListValue];
        }
      }
    });
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass audioData = data.audioData;
        List<ArtistSongsClass> artistsSongsListValue = [...artistsSongsList.value];
        for(int i = artistsSongsListValue.length - 1; i >= 0; i--){
          artistsSongsListValue[i].songsList.remove(audioData.audioUrl);
          if(artistsSongsListValue[i].songsList.isEmpty){
            artistsSongsListValue.removeAt(i);
          }
        }
        artistsSongsList.value = [...artistsSongsListValue];
      }
    });
  }
  
  void dispose(){
    artistsSongsList.dispose();
    editAudioDataStreamClassSubscription.cancel();
    deleteAudioDataStreamClassSubscription.cancel();
  }
  
  void fetchLocalSongs() async{
    Map<String, AudioCompleteDataNotifier> allSongs = appStateRepo.allAudiosList;
    List<ArtistSongsClass> artistsSongsListFetched = [];
    List<String?> artistsList = [];
    for(var songData in allSongs.values){
      if(await File(songData.audioID).exists()){
        AudioMetadataInfoClass metadataInfo = songData.notifier.value.audioMetadataInfo;
        if(artistsList.contains(metadataInfo.artistName)){
          artistsSongsListFetched[artistsList.indexOf(metadataInfo.artistName)].songsList.add(
            songData.audioID
          );
        }else{
          artistsList.add(metadataInfo.artistName);
          artistsSongsListFetched.add(
            ArtistSongsClass(
              metadataInfo.artistName, [songData.audioID]
            )
          );
        }
      }
    }
    artistsSongsList.value = [...artistsSongsListFetched];
  }
}