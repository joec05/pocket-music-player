import 'dart:io';
import 'dart:typed_data';
import 'package:music_player_app/global_files.dart';
import 'package:flutter/material.dart';

class PlaylistEditorController {
  final BuildContext context;
  final PlaylistSongsClass playlistSongsData;
  late ImagePickerController imagePickerController;
  TextEditingController playlistNameController = TextEditingController();
  String currentMessage = '';
  ValueNotifier<bool> verifyPlaylistName = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  PlaylistEditorController(
    this.context,
    this.playlistSongsData
  );

  bool get mounted => context.mounted;
  Function get pickImage => imagePickerController.pickImage;
  String get imageUrl => imagePickerController.imageUrl.value;

  void initializeController(){
    if(mounted){
      imagePickerController = ImagePickerController(context);
      playlistNameController.text = playlistSongsData.playlistName;
      imagePickerController.imageUrl.value = playlistSongsData.playlistProfilePic.path;
      verifyPlaylistName.value = playlistNameController.text.isNotEmpty;
      playlistNameController.addListener(() {
        verifyPlaylistName.value = playlistNameController.text.isNotEmpty;
      });
    }
  }

  void dispose(){
    imagePickerController.dispose();
    playlistNameController.dispose();
    verifyPlaylistName.dispose();
    isLoading.dispose();
  }

  void modifyPlaylist() async{
    if(mounted){
      if(!isLoading.value){
        isLoading.value = true;
        runDelay((){
          String playlistName = playlistNameController.text.trim();
          List<PlaylistSongsClass> playlistList = appStateRepo.playlistList;
          for(int i = 0; i < playlistList.length; i++){
            if(playlistList[i].playlistID == playlistSongsData.playlistID){
              ImageDataClass imageData = imageUrl.isNotEmpty ? 
                ImageDataClass(
                  imageUrl, 
                  File(imageUrl).readAsBytesSync()
                ) 
              : 
                ImageDataClass('', Uint8List.fromList([]));

              playlistList[i].playlistName = playlistName;
              playlistList[i].playlistProfilePic = imageData;

              break;
            }
          }
          if(context.mounted) {
            handler.displaySnackbar(
              context, 
              SnackbarType.successful, 
              tSuccess.modifyPlaylist
            );
          }
          runDelay(() => Navigator.pop(context, playlistList), navigationDelayDuration);
        }, actionDelayDuration);
      }
    }
  }
}