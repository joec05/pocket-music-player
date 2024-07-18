import 'dart:io';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:device_info_plus/device_info_plus.dart';

class PermissionController {
  bool audioIsGranted = false;
  bool storageIsGranted = false;
  ph.Permission? audioPermission;
  ph.Permission storagePermission = ph.Permission.manageExternalStorage;

  Future<bool> checkAudioGranted() async {
    if(Platform.isAndroid){
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if(androidInfo.version.sdkInt <= 32) {
        audioPermission = ph.Permission.storage;
      } else {
        audioPermission = ph.Permission.audio;
      }
    } else if (Platform.isIOS) {
      audioPermission = ph.Permission.audio;
    }
    audioIsGranted = await audioPermission!.isGranted;
    return audioIsGranted;
  }

  Future<bool> requestAudio() async {
    audioIsGranted = await audioPermission!.isGranted;
    if(!audioIsGranted){
      audioIsGranted = (await audioPermission!.request()).isGranted;
    }
    return audioIsGranted;
  }

  Future<bool> requestStorage() async {
    storageIsGranted = await storagePermission.isGranted;
    if(!storageIsGranted){
      storageIsGranted = (await storagePermission.request()).isGranted;
    }
    return storageIsGranted;
  }
}

final permission = PermissionController();