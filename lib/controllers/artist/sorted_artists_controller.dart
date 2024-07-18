import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class SortedArtistsController extends LoadingController {
  List<ArtistSongsClass> artistsSongsList = List<ArtistSongsClass>.from([]).obs;
  late StreamSubscription editAudioDataStreamClassSubscription;
  late StreamSubscription deleteAudioDataStreamClassSubscription;

  void initializeController() {
    fetchLocalSongs();
    editAudioDataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      AudioCompleteDataClass newAudioData = data.newAudioData;
      AudioCompleteDataClass oldAudioData = data.oldAudioData;
      String? newArtistName = newAudioData.audioMetadataInfo.artistName;
      String? oldArtistName = oldAudioData.audioMetadataInfo.artistName;
      List<ArtistSongsClass> artistsSongsListValue = [...artistsSongsList];
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
        artistsSongsList.assignAll(artistsSongsListValue);
      }
    });
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      AudioCompleteDataClass audioData = data.audioData;
      List<ArtistSongsClass> artistsSongsListValue = [...artistsSongsList];
      for(int i = artistsSongsListValue.length - 1; i >= 0; i--){
        artistsSongsListValue[i].songsList.remove(audioData.audioUrl);
        if(artistsSongsListValue[i].songsList.isEmpty){
          artistsSongsListValue.removeAt(i);
        }
      }
      artistsSongsList.assignAll(artistsSongsListValue);
    });
  }
  
  void dispose(){
    editAudioDataStreamClassSubscription.cancel();
    deleteAudioDataStreamClassSubscription.cancel();
  }
  
  void fetchLocalSongs() async{
    changeStatus(LoadingStatus.loading);
    Map<String, AudioCompleteDataNotifier> allSongs = appStateRepo.allAudiosList;
    List<ArtistSongsClass> artistsSongsListFetched = [];
    List<String?> artistsList = [];
    for(var songData in allSongs.values){
      if(await File(songData.audioID).exists()){
        if(!songData.notifier.value.deleted) {
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
    }
    artistsSongsList.assignAll(artistsSongsListFetched);
    changeStatus(LoadingStatus.success);
  }
}

final SortedArtistsController sortedArtistsController = SortedArtistsController();