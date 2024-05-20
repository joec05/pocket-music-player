import 'dart:io';
import 'package:music_player_app/global_files.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

Future<String> copyTemporaryAudioPath(String url) async{
  Directory temporaryDirectory = await getTemporaryDirectory();
  Directory directory = await Directory('${temporaryDirectory.path}/audio').create(recursive: true);
  File originalFile = File(url);
  String filePath = '${directory.path}/${const Uuid().v4()}.mp3';
  File newFile = await originalFile.copy(filePath);
  return newFile.path;
}

Future<String> copyTemporaryImagePath(String url) async{
  Directory temporaryDirectory = await getTemporaryDirectory();
  Directory directory = await Directory('${temporaryDirectory.path}/image').create(recursive: true);
  File originalFile = File(url);
  String filePath = '${directory.path}/${const Uuid().v4()}.${url.split('./').last}';
  File newFile = await originalFile.copy(filePath);
  return newFile.path;
}

Future<String> writeTemporaryImageBytes(Uint8List list) async{
  String uniqueID = const Uuid().v4();
  Directory tempDir = await getTemporaryDirectory();
  File file = await File('${tempDir.path}/image/$uniqueID.png').create(recursive: true);
  file.writeAsBytesSync(list);
  return file.path;
}

Future<String?> downloadTemporaryPath(String url, String fileName) async{
  Directory directory = await Directory('$defaultDirectory/music-player-app').create(recursive: true);
  File originalFile = File(url);
  String filePath = '${directory.path}/${const Uuid().v4()}.mp3';
  File newFile = await originalFile.copy(filePath);
  return newFile.path;
}

Future<String> createOutputAudioFile() async {
  Directory temporaryDirectory = await getTemporaryDirectory();
  Directory directory = await Directory('${temporaryDirectory.path}/audio/output').create(recursive: true);
  String filePath = '${directory.path}/${const Uuid().v4()}.mp3';
  return filePath;
}

Future<String> createOutputImageFile() async {
  Directory temporaryDirectory = await getTemporaryDirectory();
  Directory directory = await Directory('${temporaryDirectory.path}/image/output').create(recursive: true);
  String filePath = '${directory.path}/${const Uuid().v4()}.jpg';
  return filePath;
}
