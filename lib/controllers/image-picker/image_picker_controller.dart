import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController {
  final BuildContext context;
  ValueNotifier<String> imageUrl = ValueNotifier('');

  ImagePickerController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){}

  void dispose() {
    imageUrl.dispose();
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
}