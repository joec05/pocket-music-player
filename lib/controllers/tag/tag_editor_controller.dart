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
  ///TextEditingController albumArtistController = TextEditingController();
  RxBool isModifyingTags = false.obs;
  String currentMessage = '';

  TagEditorController(
    this.context,
    this.audioCompleteData
  );

  bool get mounted => context.mounted;
  Function get pickImage => imagePickerController.pickImage;
  Uint8List? get imageBytes => imagePickerController.imageBytes.value;

  void initializeController(){
    if(mounted){
      imagePickerController = ImagePickerController(context);
      titleController.text = audioCompleteData.audioMetadataInfo.title ?? '';
      artistController.text = audioCompleteData.audioMetadataInfo.artistName ?? '';
      albumController.text = audioCompleteData.audioMetadataInfo.albumName ?? '';
      ///albumArtistController.text = audioCompleteData.audioMetadataInfo.albumArtistName ?? '';
      imagePickerController.imageBytes.value = audioCompleteData.audioMetadataInfo.albumArt;
    }
  }

  void dispose(){
    imagePickerController.dispose();
    titleController.dispose();
    artistController.dispose();
    albumController.dispose();
    ///albumArtistController.dispose();
  }

  void modifyTags() async{
    if(mounted){
      if(!isModifyingTags.value){
        isModifyingTags.value = true;
        String? imageUrl = imageBytes != null ? await writeTemporaryImageBytes(imageBytes!) : null;
        final _ = await metadataController.modifyTags(
          context, 
          audioCompleteData, 
          titleController.text.trim(), 
          artistController.text.trim(), 
          albumController.text.trim(), 
          ///albumArtistController.text.trim(),
          imageUrl
        );
        isModifyingTags.value = false;
      }
    }
  }
}