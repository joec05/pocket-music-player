import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_music_player/global_files.dart';
import 'package:flutter/material.dart';

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
  late TagEditorController controller;

  @override void initState(){
    super.initState();
    controller = TagEditorController(context, widget.audioCompleteData);
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
        title: const Text('Tag Editor'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding),
          child: Stack(
            children: [
              ListView(
                children: [
                  Obx(() {
                    Uint8List? imageBytes = controller.imageBytes;
                    return Column(
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
                    );       
                  }),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    decoration: generateFormTextFieldDecoration(context, 'title', FontAwesomeIcons.music),
                    controller: controller.titleController,
                    maxLength: defaultTextFieldLimit,
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    decoration: generateFormTextFieldDecoration(context, 'artist', FontAwesomeIcons.user),
                    controller: controller.artistController,
                    maxLength: defaultTextFieldLimit,
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    controller: controller.albumController,
                    decoration: generateFormTextFieldDecoration(context, 'album name', FontAwesomeIcons.recordVinyl),
                    maxLength: defaultTextFieldLimit,
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  ///TextField(
                  ///  controller: controller.albumArtistController,
                  ///  decoration: generateFormTextFieldDecoration('album artist name', FontAwesomeIcons.user),
                  ///  maxLength: defaultTextFieldLimit,
                  ///  style: const TextStyle(fontSize: 13.5),
                  ///),
                  ///SizedBox(height: defaultTextFieldVerticalMargin),
                  Obx(() {
                    bool isModifyingTags = controller.isModifyingTags.value;
                    return CustomButton(
                      width: double.infinity,
                      height: getScreenHeight() * 0.07,
                      color: !isModifyingTags ? Colors.orange.withOpacity(0.75) : Colors.grey.withOpacity(0.5),
                      onTapped: !isModifyingTags ? () => controller.modifyTags() : (){},
                      text: 'Update metadata',
                      setBorderRadius: true,
                      prefix: null,
                      loading: isModifyingTags
                    );
                  })
                ],
              ),
            ],
          )
        )
      )
    );
  }

}