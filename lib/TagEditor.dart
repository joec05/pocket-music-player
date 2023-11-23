// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/custom/CustomButton.dart';
import 'package:music_player_app/streams/EditAudioMetadataStreamClass.dart';
import 'package:music_player_app/styles/AppStyles.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_audio/log.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';
import 'package:music_player_app/class/AudioMetadataInfoClass.dart';

class TagEditorWidget extends StatelessWidget {
  final AudioCompleteDataClass audioCompleteData;
  const TagEditorWidget({super.key, required this.audioCompleteData});

  @override
  Widget build(BuildContext context) {
    return _TagEditorWidgetStateful(audioCompleteData: audioCompleteData);
  }
}


class _TagEditorWidgetStateful extends StatefulWidget {
  final AudioCompleteDataClass audioCompleteData;
  const _TagEditorWidgetStateful({required this.audioCompleteData});

  @override
  State<_TagEditorWidgetStateful> createState() => _TagEditorWidgetState();
}

class _TagEditorWidgetState extends State<_TagEditorWidgetStateful> {
  late AudioCompleteDataClass audioCompleteData;
  ValueNotifier<String> imageUrl = ValueNotifier('');
  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  TextEditingController albumArtistController = TextEditingController();
  ValueNotifier<bool> verifyTitle = ValueNotifier(false);
  String currentMessage = '';
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override void initState(){
    super.initState();
    audioCompleteData = widget.audioCompleteData;
    if(mounted){
      titleController.text = audioCompleteData.audioMetadataInfo.title ?? '';
      artistController.text = audioCompleteData.audioMetadataInfo.artistName ?? '';
      albumController.text = audioCompleteData.audioMetadataInfo.albumName ?? '';
      albumArtistController.text = audioCompleteData.audioMetadataInfo.albumArtistName ?? '';
      imageUrl.value = audioCompleteData.audioMetadataInfo.albumArt.path;
      verifyTitle.value = titleController.text.isNotEmpty;
      verifyTitle.addListener(() {
        verifyTitle.value = titleController.text.isNotEmpty;
      });
    }
  }

  @override void dispose(){
    super.dispose();
    imageUrl.dispose();
    titleController.dispose();
    artistController.dispose();
    albumController.dispose();
    albumArtistController.dispose();
    verifyTitle.dispose();
    isLoading.dispose();
  }

  Future<void> pickImage(ImageSource source, {BuildContext? context}) async {
    bool permissionIsGranted = false;
    ph.Permission? permission;
    if(Platform.isAndroid){
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if(androidInfo.version.sdkInt <= 32){
        permission = ph.Permission.storage;
      }else{
        permission = ph.Permission.photos;
      }
    }
    permissionIsGranted = await permission!.isGranted;
    if(!permissionIsGranted){
      await permission.request();
      permissionIsGranted = await permission.isGranted;
    }
    if(permissionIsGranted){
      try {
        final XFile? pickedFile = await ImagePicker().pickImage(
          source: source,
          imageQuality: 100,
          maxWidth: 1000,
          maxHeight: 1000,
        );
        if(pickedFile != null && mounted){
          String fetchedImageUrl = pickedFile.path;
          imageUrl.value = fetchedImageUrl;
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void copyAudioToOriginalPath(String path) async {
    File originalFile = File(path);
    String filePath = audioCompleteData.audioUrl;
    if(await File(path).exists()){
      await originalFile.copy(filePath);
    }
  }

  void modifyTags() async{
    if(mounted){
      if(!isLoading.value){
        isLoading.value = true;
        String inputFilePath = await copyTemporaryPath(audioCompleteData.audioUrl);
        String outputFilePath = await createOutputAudioFile();
        String title = titleController.text.trim();
        String artist = artistController.text.trim();
        String album = albumController.text.trim();
        String albumArtist = albumArtistController.text.trim();
        String ffmpegCommand = '';
        if(imageUrl.value.isEmpty){
          ffmpegCommand += '-map 0:0 -c copy ';
        }else{
          String imageCoverPath = await copyTemporaryPath(imageUrl.value);
          ffmpegCommand += '-i $imageCoverPath -map 0 -map 1 -c copy ';
        }
        if(title != widget.audioCompleteData.audioMetadataInfo.title){
          ffmpegCommand += '-metadata title="$title" ';
        }
        if(artist.isEmpty){
          ffmpegCommand += '-metadata artist= ';
        }else{
          ffmpegCommand += '-metadata artist="$artist" ';
        }
        if(album.isEmpty){
          ffmpegCommand += '-metadata album= ';
        }else{
          ffmpegCommand += '-metadata album="$album" ';
        }
        if(albumArtist.isEmpty){
          ffmpegCommand += '-metadata album_artist= ';
        }else{
          ffmpegCommand += '-metadata album_artist="$albumArtist" ';
        }
        debugPrint(ffmpegCommand);
        if(ffmpegCommand.isNotEmpty){
          ffmpegCommand = '-y -i "$inputFilePath" $ffmpegCommand "$outputFilePath"';
          FFmpegKit.executeAsync(
            ffmpegCommand, 
            (session) async {
              FFmpegKitConfig.enableLogCallback((log) async{
                final message = log.getMessage();
                currentMessage = message;
                debugPrint(message);
              });
              final returnCode = await session.getReturnCode();
              if(mounted){
                isLoading.value = false;
                if (ReturnCode.isSuccess(returnCode)) {
                  ImageDataClass imageData = imageUrl.value.isNotEmpty ? ImageDataClass(imageUrl.value, File(imageUrl.value).readAsBytesSync()) : ImageDataClass('', Uint8List.fromList([]));
                  Navigator.of(context).pop();
                  copyAudioToOriginalPath(outputFilePath);
                  AudioMetadataInfoClass x = audioCompleteData.audioMetadataInfo;
                  AudioCompleteDataClass y = AudioCompleteDataClass(
                    audioCompleteData.audioUrl, AudioMetadataInfoClass(
                      x.fileName, x.duration, title,
                      artist.isEmpty ? null : artist, 
                      album.isEmpty ? null : album, 
                      albumArtist.isEmpty ? null : albumArtist, 
                      imageData
                    ), audioCompleteData.playerState, audioCompleteData.deleted
                  );
                  fetchReduxDatabase().allAudiosList[audioCompleteData.audioUrl]!.notifier.value = y;
                  EditAudioMetadataStreamClass().emitData(
                    EditAudioMetadataStreamControllerClass(
                      y, widget.audioCompleteData
                    )
                  );
                } else if (ReturnCode.isCancel(returnCode)) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (_){
                      return AlertDialog(
                        title: const Text('Process has been cancelled'),
                        content: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Ok')
                        )
                      );
                    }
                  );
                } else {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (_){
                      return AlertDialog(
                        title: Text(currentMessage),
                        content: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Ok')
                        )
                      );
                    }
                  );
                }
              }
            }, (Log log) {},
          );
        }else{
          if(mounted){
            isLoading.value = false;
            Navigator.of(context).pop();
          }
        }
      }
    };
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('Tag Editor'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding),
          child: Stack(
            children: [
              ListView(
                children: [
                  ValueListenableBuilder(
                    valueListenable: imageUrl,
                    builder: (context, imageUrlValue, child){
                      return Column(
                        children: [
                          Container(
                            width: getScreenWidth() * 0.35, height: getScreenWidth() * 0.35,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(100),
                              image: imageUrlValue.isNotEmpty ?
                                DecorationImage(
                                  image: FileImage(
                                    File(imageUrlValue)
                                  ), fit: BoxFit.fill
                                )
                              : null
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: mounted ? imageUrlValue.isNotEmpty ? () => imageUrl.value = '' : () => pickImage(ImageSource.gallery, context: context) : null,
                                child: Icon(imageUrlValue.isNotEmpty ? Icons.delete : Icons.add, size: 30)
                              ),
                            )
                          ),
                        ],
                      );       
                    }
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    decoration: generateFormTextFieldDecoration('title'),
                    controller: titleController,
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    decoration: generateFormTextFieldDecoration('artist'),
                    controller: artistController,
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    controller: albumController,
                    decoration: generateFormTextFieldDecoration('album name'),
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    decoration: generateFormTextFieldDecoration('album artist'),
                    controller: albumArtistController,
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  ValueListenableBuilder(
                    valueListenable: verifyTitle,
                    builder: (context, verifyTitle, child){
                      return CustomButton(
                        width: double.infinity,
                        height: getScreenHeight() * 0.065,
                        buttonColor: verifyTitle ? Colors.orange : Colors.grey.withOpacity(0.5),
                        onTapped: verifyTitle ? () => modifyTags() : (){},
                        buttonText: 'Update metadata',
                        setBorderRadius: true,
                      );
                    }
                  ) 
                ],
              ),
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, isLoading, child){
                  if(isLoading){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  return Container();
                }
              )
            ],
          )
        )
      )
    );
  }

}