import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/custom/CustomButton.dart';
import 'package:music_player_app/styles/AppStyles.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';

class PlaylistEditorWidget extends StatelessWidget {
  final PlaylistSongsClass playlistSongsData;
  const PlaylistEditorWidget({super.key, required this.playlistSongsData});

  @override
  Widget build(BuildContext context) {
    return _PlaylistEditorWidgetStateful(playlistSongsData: playlistSongsData);
  }
}


class _PlaylistEditorWidgetStateful extends StatefulWidget {
  final PlaylistSongsClass playlistSongsData;
  const _PlaylistEditorWidgetStateful({required this.playlistSongsData});

  @override
  State<_PlaylistEditorWidgetStateful> createState() => _PlaylistEditorWidgetState();
}

class _PlaylistEditorWidgetState extends State<_PlaylistEditorWidgetStateful> {
  late PlaylistSongsClass playlistSongsData;
  ValueNotifier<String> imageUrl = ValueNotifier('');
  TextEditingController playlistNameController = TextEditingController();
  String currentMessage = '';
  ValueNotifier<bool> verifyPlaylistName = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override void initState(){
    super.initState();
    playlistSongsData = widget.playlistSongsData;
    if(mounted){
      playlistNameController.text = playlistSongsData.playlistName;
      imageUrl.value = playlistSongsData.playlistProfilePic.path;
      verifyPlaylistName.value = playlistNameController.text.isNotEmpty;
      playlistNameController.addListener(() {
        verifyPlaylistName.value = playlistNameController.text.isNotEmpty;
      });
    }
  }

  @override void dispose(){
    super.dispose();
    imageUrl.dispose();
    playlistNameController.dispose();
    verifyPlaylistName.dispose();
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

  void modifyPlaylist() async{
    if(mounted){
      if(!isLoading.value){
        isLoading.value = true;
        runDelay((){
          String playlistName = playlistNameController.text.trim();
          List<PlaylistSongsClass> playlistList = fetchReduxDatabase().playlistList;
          for(int i = 0; i < playlistList.length; i++){
            if(playlistList[i].playlistID == playlistSongsData.playlistID){
              ImageDataClass imageData = imageUrl.value.isNotEmpty ? ImageDataClass(imageUrl.value, File(imageUrl.value).readAsBytesSync()) : ImageDataClass('', Uint8List.fromList([]));
              playlistList[i].playlistName = playlistName;
              playlistList[i].playlistProfilePic = imageData;
              break;
            }
          }
          runDelay(() => Navigator.pop(context, playlistList), navigationDelayDuration);
        }, actionDelayDuration);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('Playlist Editor'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
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
                    decoration: generateFormTextFieldDecoration('playlist name'),
                    controller: playlistNameController,
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  ValueListenableBuilder(
                    valueListenable: verifyPlaylistName,
                    builder: (context, verifyPlaylistName, child){
                      return ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (context, isLoading, child){
                          return CustomButton(
                            width: double.infinity,
                            height: getScreenHeight() * 0.065,
                            buttonColor: verifyPlaylistName && !isLoading ? Colors.orange : Colors.grey.withOpacity(0.5),
                            onTapped: verifyPlaylistName && !isLoading ? () => modifyPlaylist() : (){},
                            buttonText: 'Update playlist data',
                            setBorderRadius: true,
                          );
                        }
                      );
                    }
                  )
                ]
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