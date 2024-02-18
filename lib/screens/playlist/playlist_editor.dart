import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_player_app/global_files.dart';
import 'package:flutter/material.dart';

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
  late PlaylistEditorController controller;

  @override void initState(){
    super.initState();
    controller = PlaylistEditorController(context, widget.playlistSongsData);
    controller.initializeController();
  }

  @override void dispose(){
    super.dispose();
    controller.dispose();
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
                    valueListenable: controller.imagePickerController.imageUrl,
                    builder: (context, imageUrlValue, child){
                      return Column(
                        children: [
                          Container(
                            width: getScreenWidth() * 0.35, height: getScreenWidth() * 0.35,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
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
                                onTap: mounted ? imageUrlValue.isNotEmpty ?
                                  () => controller.imagePickerController.imageUrl.value = '' : 
                                  () => controller.pickImage(ImageSource.gallery, context: context) 
                                : null,
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
                    decoration: generateFormTextFieldDecoration('playlist name', FontAwesomeIcons.list),
                    controller: controller.playlistNameController,
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  ListenableBuilder(
                    listenable: Listenable.merge([
                      controller.verifyPlaylistName,
                      controller.isLoading
                    ]),
                    builder: (context, child) {
                      bool verifyPlaylistName = controller.verifyPlaylistName.value;
                      bool isLoading = controller.isLoading.value;
                      return CustomButton(
                        width: double.infinity,
                        height: getScreenHeight() * 0.065,
                        buttonColor: verifyPlaylistName && !isLoading ? Colors.orange : Colors.grey.withOpacity(0.5),
                        onTapped: verifyPlaylistName && !isLoading ? () => controller.modifyPlaylist() : (){},
                        buttonText: 'Update playlist data',
                        setBorderRadius: true,
                      );
                    }
                  )
                ]
              ),
              ValueListenableBuilder(
                valueListenable: controller.isLoading,
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