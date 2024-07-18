import 'dart:async';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class PlaylistsController {
  List<PlaylistSongsModel> playlistsSongsList = List<PlaylistSongsModel>.from([]).obs;
  late StreamSubscription deleteAudioDataStreamClassSubscription;
  late StreamSubscription updatePlaylistStreamClassSubscription;

  void initializeController(){
    playlistsSongsList.assignAll(appStateRepo.playlistList);
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      AudioCompleteDataClass audioData = data.audioData;
      List<PlaylistSongsModel> playlistsSongs = [...playlistsSongsList];
      for(int i = playlistsSongs.length - 1; i >= 0; i--){
        List<String> songsList = playlistsSongs[i].songsList;
        songsList.remove(audioData.audioUrl);
        playlistsSongs[i].songsList = songsList;
        isarController.putPlaylist(playlistsSongs[i]);

        if(playlistsSongs[i].songsList.isEmpty){
          isarController.deletePlaylist(playlistsSongs[i]);
          playlistsSongs.removeAt(i);
        }
      }
      playlistsSongsList.assignAll([...playlistsSongs]);
    });
    updatePlaylistStreamClassSubscription = UpdatePlaylistStreamClass().updatePlaylistStream.listen((UpdatePlaylistStreamControllerClass data) {
      playlistsSongsList.assignAll(data.playlistsList);
    });
  }

  void dispose(){
    deleteAudioDataStreamClassSubscription.cancel();
    updatePlaylistStreamClassSubscription.cancel();
  }

}

final PlaylistsController playlistsController = PlaylistsController();