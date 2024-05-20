import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_player_app/global_files.dart';
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
                    Uint8List imageBytes = controller.imageBytes;
                    return Column(
                      children: [
                        Container(
                          width: getScreenWidth() * 0.35, height: getScreenWidth() * 0.35,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(100),
                            image: imageBytes.isNotEmpty ?
                              DecorationImage(
                                image: MemoryImage(
                                  imageBytes
                                ), fit: BoxFit.fill
                              )
                            : null
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: mounted ? imageBytes.isNotEmpty ? 
                                () => controller.imagePickerController.imageBytes.value = Uint8List.fromList([]) : 
                                () => controller.pickImage(ImageSource.gallery, context: context) 
                              : null,
                              child: Icon(imageBytes.isNotEmpty ? Icons.delete : Icons.add, size: 30)
                            ),
                          )
                        ),
                      ],
                    );       
                  }),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    decoration: generateFormTextFieldDecoration('title', FontAwesomeIcons.music),
                    controller: controller.titleController,
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    decoration: generateFormTextFieldDecoration('artist', FontAwesomeIcons.user),
                    controller: controller.artistController,
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    controller: controller.albumController,
                    decoration: generateFormTextFieldDecoration('album name', FontAwesomeIcons.recordVinyl),
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  TextField(
                    decoration: generateFormTextFieldDecoration('album artist', FontAwesomeIcons.user),
                    controller: controller.albumArtistController,
                    maxLength: defaultTextFieldLimit,
                  ),
                  SizedBox(height: defaultTextFieldVerticalMargin),
                  Obx(() {
                    bool isLoading = controller.isLoading.value;
                    bool verifyTitle = controller.verifyTitle.value;
                    return CustomButton(
                      width: double.infinity,
                      height: getScreenHeight() * 0.065,
                      color: verifyTitle && !isLoading ? Colors.orange : Colors.grey.withOpacity(0.5),
                      onTapped: verifyTitle && !isLoading ? () => controller.modifyTags() : (){},
                      text: 'Update metadata',
                      setBorderRadius: true,
                      prefix: null,
                      loading: isLoading
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