import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_music_player/global_files.dart';
import 'package:flutter/material.dart';

class PlaylistEditorWidget extends StatelessWidget {
  final PlaylistSongsModel playlistSongsData;
  const PlaylistEditorWidget({super.key, required this.playlistSongsData});

  @override
  Widget build(BuildContext context) {
    return _PlaylistEditorWidgetStateful(playlistSongsData: playlistSongsData);
  }
}

class _PlaylistEditorWidgetStateful extends StatefulWidget {
  final PlaylistSongsModel playlistSongsData;
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
              Obx(() {
                Uint8List? imageBytes = controller.imageBytes;
                bool verifyPlaylistName = controller.verifyPlaylistName.value;
                bool isLoading = controller.isLoading.value;

                return ListView(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: getScreenWidth() * 0.35, 
                          height: getScreenWidth() * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            image: imageBytes != null ?
                              DecorationImage(
                                image: MemoryImage(
                                  imageBytes
                                ),
                                fit: BoxFit.cover
                              )
                            : null
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: mounted ? imageBytes != null ?
                                () => controller.imagePickerController.imageBytes.value = null : 
                                () => controller.pickImage(ImageSource.gallery, context: context) 
                              : null,
                              child: Icon(imageBytes != null ? Icons.delete : Icons.add, size: 30)
                            ),
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: defaultTextFieldVerticalMargin),
                    TextField(
                      decoration: generateFormTextFieldDecoration(context, 'playlist name', FontAwesomeIcons.list),
                      controller: controller.playlistNameController,
                      style: const TextStyle(fontSize: 13.5),
                      maxLength: defaultTextFieldLimit,
                    ),
                    SizedBox(height: defaultTextFieldVerticalMargin),
                    CustomButton(
                      width: double.infinity,
                      height: getScreenHeight() * 0.07,
                      color: verifyPlaylistName && !isLoading ? Colors.orange.withOpacity(0.75) : Colors.grey.withOpacity(0.5),
                      onTapped: verifyPlaylistName && !isLoading ? () => controller.modifyPlaylist() : (){},
                      text: 'Update playlist data',
                      setBorderRadius: true,
                      prefix: null,
                      loading: isLoading
                    )
                  ]
                );
              })
            ],
          )
        )
      )
    );
  }
}