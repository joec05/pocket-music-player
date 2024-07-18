import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class SortedAlbumsController extends LoadingController {
  List<AlbumSongsClass> albumsSongsList = List<AlbumSongsClass>.from([]).obs;
  late StreamSubscription editAudioDataStreamClassSubscription;
  late StreamSubscription deleteAudioDataStreamClassSubscription;
  
  void initializeController(){
    fetchLocalSongs();
    editAudioDataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      fetchLocalSongs();
    });
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      AudioCompleteDataClass audioData = data.audioData;
      List<AlbumSongsClass> albumsSongsListValue = [...albumsSongsList];
      for(int i = albumsSongsListValue.length - 1; i >= 0; i--){
        albumsSongsListValue[i].songsList.remove(audioData.audioUrl);
        if(albumsSongsListValue[i].songsList.isEmpty){
          albumsSongsListValue.removeAt(i);
        }
      }
      albumsSongsList.assignAll(albumsSongsListValue);
    });
  }

  void dispose(){
    editAudioDataStreamClassSubscription.cancel();
    deleteAudioDataStreamClassSubscription.cancel();
  }
  
  void fetchLocalSongs() async{
    changeStatus(LoadingStatus.loading);
    Map<String, AudioCompleteDataNotifier> allSongs = appStateRepo.allAudiosList;
    List<AlbumSongsClass> albumsSongsListFetched = [];
    for(var songData in allSongs.values){
      if(await File(songData.audioID).exists()){
        if(!songData.notifier.value.deleted) {
          AudioMetadataInfoClass metadataInfo = songData.notifier.value.audioMetadataInfo;
          int albumIndex = albumsSongsListFetched.indexWhere((element){
            /// return element.albumName == metadataInfo.albumName && element.artistName == metadataInfo.albumArtistName;
            return element.albumName == metadataInfo.albumName && element.artistName == metadataInfo.artistName;
          });
          if(albumIndex > -1){
            albumsSongsListFetched[albumIndex].songsList.add(
              songData.audioID
            );
          }else{
            albumsSongsListFetched.add(
              AlbumSongsClass(
                metadataInfo.albumName, metadataInfo.artistName, ///metadataInfo.albumArtistName,
                metadataInfo.albumArt, [songData.audioID]
              )
            );
          }
        }
      }
    }
    albumsSongsList.assignAll(albumsSongsListFetched);
    changeStatus(LoadingStatus.success);
  }
}

final SortedAlbumsController sortedAlbumsController = SortedAlbumsController();