import 'dart:io';
import 'package:get/get.dart';
import 'package:pocket_music_player/controllers/permission/permission_controller.dart';
import 'package:pocket_music_player/global_files.dart';

class FetchSongsController {
  Future<void> fetchLocalSongs(LoadType loadType) async {
    mainPageController.setLoadingState(false, loadType);
    if(await permission.checkAudioGranted()) {
      Directory dir = Directory(defaultDirectory);
      List<FileSystemEntity> directoryList = await dir.list().toList();
      directoryList.removeWhere((e) => e.path == restrictedDirectory);
      List<FileSystemEntity> songsList = [];
      List<String> audioFormats = [
        '.mp3', // working format
      ];
      for(var dir in directoryList){
        if(dir is Directory) {
          try {
            for(int i = 0; i < audioFormats.length; i++) {
              songsList.addAll(
                await dir.list(recursive: true).where((e) => e.path.endsWith(audioFormats[i])).toList()
              );
            }
          } catch (_) {

          }
        }  
      }
      
      final Map<String, AudioCompleteDataNotifier> filesCompleteDataList = {};
      final Map<String, AudioListenCountModel> localListenCountData = await isarController.fetchAllCounts();
      Map<String, AudioListenCountModel> getListenCountData = {};
      List<String> songUrlsList = [];
      
      for(int i = 0; i < songsList.length; i++){
        String path = songsList[i].path;
        if(await File(path).exists()){
          try {
            var metadata = await metadataController.fetchAudioMetadata(path);
            if(metadata != null){
              songUrlsList.add(path);
              filesCompleteDataList[path] = AudioCompleteDataNotifier(
                path, 
                AudioCompleteDataClass(
                  path, metadata, AudioPlayerState.stopped.obs, false
                ).obs
              );
              if(localListenCountData[path] != null){
                getListenCountData[path] = localListenCountData[path]!;
              }else{
                getListenCountData[path] = AudioListenCountModel(path, 0);
              }
            }
          } catch(e) {
            talker.debug("${path.split('/').last} $e");
          }
        }
      }
      appStateRepo.allAudiosList.value = filesCompleteDataList;
      appStateRepo.audioListenCount = getListenCountData;
      appStateRepo.setFavouritesList(await isarController.fetchFavourites());
      appStateRepo.setPlaylistList('', await isarController.fetchPlaylists());
    } else{
      if(loadType == LoadType.scan) {
        final _ = await permission.requestAudio();
        if(permission.audioIsGranted) {
          await fetchLocalSongs(loadType);
        }
      }
      /*
      if(context.mounted) {
        handler.displaySnackbar(
          context,
          SnackbarType.warning,
          tWarning.scanPermission
        );
      }
      */
    }
    mainPageController.setLoadingState(true, loadType);
    return;
  }
}

final fetchSongsController = FetchSongsController();