import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:music_player_app/global_files.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

Future<String> copyTemporaryAudioPath(String url) async{
  Directory temporaryDirectory = await getTemporaryDirectory();
  Directory directory = await Directory('${temporaryDirectory.path}/audio').create(recursive: true);
  File originalFile = File(url);
  String filePath = '${directory.path}/${const Uuid().v4()}.${getAudioFormat(url)}}';
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

Future<String> writeTemporaryBytes(String url) async{
  String uniqueID = const Uuid().v4();
  final http.Response responseData = await http.get(Uri.parse(url));
  Uint8List bytesList = responseData.bodyBytes;
  var buffer = bytesList.buffer;
  ByteData byteData = ByteData.view(buffer);
  Directory tempDir = await getTemporaryDirectory();
  Directory directory = await Directory('${tempDir.path}/audio').create(recursive: true);
  String filePath = '${directory.path}/$uniqueID.${getAudioFormat(url)}}';
  File newFile = await File(filePath).writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return newFile.path;
}

Future<String?> downloadTemporaryPath(String url, String fileName) async{
  Directory directory = await Directory('$defaultDirectory/music-player-app').create(recursive: true);
  File originalFile = File(url);
  String filePath = '${directory.path}/${const Uuid().v4()}.${getAudioFormat(url)}}';
  File newFile = await originalFile.copy(filePath);
  return newFile.path;
}

Future<String> createOutputAudioFile(String url) async {
  Directory temporaryDirectory = await getTemporaryDirectory();
  Directory directory = await Directory('${temporaryDirectory.path}/audio/output').create(recursive: true);
  String filePath = '${directory.path}/${const Uuid().v4()}.${getAudioFormat(url)}}}';
  return filePath;
}

Future<String> createOutputImageFile() async {
  Directory temporaryDirectory = await getTemporaryDirectory();
  Directory directory = await Directory('${temporaryDirectory.path}/image/output').create(recursive: true);
  String filePath = '${directory.path}/${const Uuid().v4()}.jpg';
  return filePath;
}
