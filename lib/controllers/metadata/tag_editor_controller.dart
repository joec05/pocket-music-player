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
  ValueNotifier<bool> verifyTitle = ValueNotifier(false);
  String currentMessage = '';
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  TagEditorController(
    this.context,
    this.audioCompleteData
  );

  bool get mounted => context.mounted;
  Function get pickImage => imagePickerController.pickImage;
  String get imageUrl => imagePickerController.imageUrl.value;

  void initializeController(){
    if(mounted){
      imagePickerController = ImagePickerController(context);
      titleController.text = audioCompleteData.audioMetadataInfo.title ?? '';
      artistController.text = audioCompleteData.audioMetadataInfo.artistName ?? '';
      albumController.text = audioCompleteData.audioMetadataInfo.albumName ?? '';
      albumArtistController.text = audioCompleteData.audioMetadataInfo.albumArtistName ?? '';
      imagePickerController.imageUrl.value = audioCompleteData.audioMetadataInfo.albumArt.path;
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
    verifyTitle.dispose();
    isLoading.dispose();
  }

  void modifyTags() async{
    if(mounted){
      if(!isLoading.value){
        isLoading.value = true;
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