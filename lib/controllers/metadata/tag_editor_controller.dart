// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';
import 'package:flutter/material.dart';

class TagEditorController {
  BuildContext context;
  AudioCompleteDataClass audioCompleteData;
  late ImagePickerController imagePickerController;
  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  TextEditingController albumArtistController = TextEditingController();
  RxBool verifyTitle = false.obs;
  String currentMessage = '';
  RxBool isLoading = false.obs;

  TagEditorController(
    this.context,
    this.audioCompleteData
  );

  bool get mounted => context.mounted;
  Function get pickImage => imagePickerController.pickImage;
  Uint8List get imageBytes => imagePickerController.imageBytes.value;

  void initializeController(){
    if(mounted){
      imagePickerController = ImagePickerController(context);
      titleController.text = audioCompleteData.audioMetadataInfo.title ?? '';
      artistController.text = audioCompleteData.audioMetadataInfo.artistName ?? '';
      albumController.text = audioCompleteData.audioMetadataInfo.albumName ?? '';
      albumArtistController.text = audioCompleteData.audioMetadataInfo.albumArtistName ?? '';
      imagePickerController.imageBytes.value = audioCompleteData.audioMetadataInfo.albumArt.bytes;
      verifyTitle.value = titleController.text.isNotEmpty;
      titleController.addListener(() {
        verifyTitle.value = titleController.text.isNotEmpty;
      });
    }
  }

  void dispose(){
    imagePickerController.dispose();
    titleController.dispose();
    artistController.dispose();
    albumController.dispose();
    albumArtistController.dispose();
  }

  void modifyTags() async{
    if(mounted){
      if(!isLoading.value){
        isLoading.value = true;
        String imageUrl = imageBytes.isEmpty ? '' : await writeTemporaryImageBytes(imageBytes);
        await ffmpegController.modifyTags(
          context, 
          audioCompleteData, 
          titleController.text.trim(), 
          artistController.text.trim(), 
          albumController.text.trim(), 
          albumArtistController.text.trim(), 
          imageUrl
        );
        isLoading.value = false;
      }
    }
  }
}