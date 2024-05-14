import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:device_info_plus/device_info_plus.dart';

class AllSongsController {
  final BuildContext context;
  final Function(bool, LoadType) setLoadingState;
  List<String> audioUrls = List<String>.from([]).obs;

  AllSongsController(
    this.context,
    this.setLoadingState
  );

  bool get mounted => context.mounted;

  void initializeController() {
    print('2');
    fetchLocalSongs(LoadType.initial);
  }

  void dispose(){}

  void fetchLocalSongs(LoadType loadType) async{
    bool permissionIsGranted = false;
    ph.Permission? permission;
    if(Platform.isAndroid){
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if(androidInfo.version.sdkInt <= 32) {
        permission = ph.Permission.storage;
      } else {
        permission = ph.Permission.photos;
      }
    } else if (Platform.isIOS) {
      permission = ph.Permission.photos;
    }
    permissionIsGranted = await permission!.isGranted;
    if(!permissionIsGranted){
      await permission.request();
      permissionIsGranted = await permission.isGranted;
    }
    if(permissionIsGranted){
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
          } catch (e) {
            if(mounted) {
              handler.displaySnackbar(
                context, 
                SnackbarType.error, 
                e.toString()
              );
            }
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
          var metadata = await ffmpegController.fetchAudioMetadata(path);
          if(metadata != null){
            songUrlsList.add(path);
            filesCompleteDataList[path] = AudioCompleteDataNotifier(
              path, 
              AudioCompleteDataClass(
                path, metadata, AudioPlayerState.stopped, false
              ).obs
            );
            if(localListenCountData[path] != null){
              getListenCountData[path] = localListenCountData[path]!;
            }else{
              getListenCountData[path] = AudioListenCountModel(path, 0);
            }
          }
        }
      }
      if(mounted){
        audioUrls.assignAll(songUrlsList);
        appStateRepo.allAudiosList = filesCompleteDataList;
        appStateRepo.audioListenCount = getListenCountData;
        appStateRepo.setFavouritesList(await isarController.fetchFavourites());
        appStateRepo.setPlaylistList('', await isarController.fetchPlaylists());
      }   
    }else{
      if(mounted) {
        handler.displaySnackbar(
          context,
          SnackbarType.warning,
          tWarning.scanPermission
        );
      }
    }
    print('3');
    setLoadingState(true, loadType);
  }

  void scan() async{
    if(mounted){
      await appStateRepo.audioHandler!.stop().then((value){
        setLoadingState(false, LoadType.scan);
        runDelay(() => fetchLocalSongs(LoadType.scan), actionDelayDuration);
      });
    }
  }
}