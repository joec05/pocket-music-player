import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';
import 'package:flutter/material.dart';

class PlaylistEditorController {
  final BuildContext context;
  final PlaylistSongsModel playlistSongsData;
  late ImagePickerController imagePickerController;
  TextEditingController playlistNameController = TextEditingController();
  String currentMessage = '';
  RxBool verifyPlaylistName = false.obs;
  RxBool isLoading = false.obs;

  PlaylistEditorController(
    this.context,
    this.playlistSongsData
  );

  bool get mounted => context.mounted;
  Function get pickImage => imagePickerController.pickImage;
  Uint8List get imageBytes => imagePickerController.imageBytes.value;

  void initializeController(){
    if(mounted){
      imagePickerController = ImagePickerController(context);
      playlistNameController.text = playlistSongsData.playlistName;
      imagePickerController.imageBytes.value = Uint8List.fromList(playlistSongsData.imageBytes);
      verifyPlaylistName.value = playlistNameController.text.isNotEmpty;
      playlistNameController.addListener(() {
        verifyPlaylistName.value = playlistNameController.text.isNotEmpty;
      });
    }
  }

  void dispose(){
    imagePickerController.dispose();
    playlistNameController.dispose();
  }

  void modifyPlaylist() async{
    if(mounted){
      if(!isLoading.value){
        isLoading.value = true;
        runDelay((){
          String playlistName = playlistNameController.text.trim();
          List<PlaylistSongsModel> playlistList = appStateRepo.playlistList;
          for(int i = 0; i < playlistList.length; i++){
            if(playlistList[i].playlistID == playlistSongsData.playlistID){
              playlistList[i].playlistName = playlistName;
              playlistList[i].imageBytes = imageBytes.isNotEmpty ? imageBytes : Uint8List.fromList([]);
              isarController.putPlaylist(playlistList[i]);
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