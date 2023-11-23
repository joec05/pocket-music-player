// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffprobe_session.dart';
import 'package:http/http.dart' as http;
import 'package:music_player_app/class/AudioListenCountClass.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/streams/DeleteAudioDataStreamClass.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../redux/reduxLibrary.dart';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';
import 'package:music_player_app/class/AudioMetadataInfoClass.dart';
import 'package:flutter/foundation.dart';
import 'GlobalEnums.dart';
import 'GlobalVariables.dart';

ViewModel fetchReduxDatabase(){
  return ViewModel.fromStore(store);
}

double getScreenHeight(){
  return PlatformDispatcher.instance.views.first.physicalSize.height / PlatformDispatcher.instance.views.first.devicePixelRatio;
}

double getScreenWidth(){
  return PlatformDispatcher.instance.views.first.physicalSize.width / PlatformDispatcher.instance.views.first.devicePixelRatio;
}

String getTimeDifference(String day) {
  DateTime? dateTime = DateTime.parse(day).toLocal();
  Duration difference = DateTime.now().difference(dateTime);
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if(difference.inDays < 31){
    return '${difference.inDays} days ago';
  } else if(difference.inDays < 365){
    return '${(difference.inDays / 30).floor()} months ago';
  } else {
    return '${(difference.inDays / 365).floor()} years ago';
  }
}

void addAudioListenCount(AudioCompleteDataClass audioCompleteData){
  AudioListenCountClass listenCountData = fetchReduxDatabase().audioListenCount[audioCompleteData.audioUrl]!.notifier.value;
  AudioListenCountClass updatedListenCountData = AudioListenCountClass(listenCountData.audioUrl, listenCountData.listenCount + 1);
  fetchReduxDatabase().audioListenCount[audioCompleteData.audioUrl]!.notifier.value = updatedListenCountData;
}

Future<AudioMetadataInfoClass?> fetchAudioMetadata(String audioUrl) async{
  FFprobeSession res = await FFprobeKit.execute('-v quiet -print_format json=compact=1 -show_format "$audioUrl"');
  String? output = await res.getOutput();
  if(output != null){
    Map<String, dynamic> decoded = Map<String, dynamic>.from(json.decode(output));
    Map<String, dynamic> format = decoded['format'];
    if(format['tags'] != null){
      Map<String, dynamic> tags = format['tags'];
      String durationStr = format['duration'];
      double durationInMs = double.parse(durationStr) * 1000;
      await fetchAlbumArtData(audioUrl);
      return AudioMetadataInfoClass(
        format['filename'], 
        durationInMs.round(), 
        tags['title'], 
        tags['artist'],
        tags['album'], 
        tags['album_artist'], 
        await fetchAlbumArtData(audioUrl)
      );
    }
  }else{
    return null;
  }
}

Future<ImageDataClass> fetchAlbumArtData(String audioUrl) async{
  String outputImageUrl = await createOutputImageFile();
  await FFmpegKit.execute(
    '-v quiet -i "$audioUrl" -an -vcodec copy "$outputImageUrl" -y',
  );
  if(await File(outputImageUrl).exists()){
    return ImageDataClass(outputImageUrl, File(outputImageUrl).readAsBytesSync());
  }else{
    return ImageDataClass('', Uint8List.fromList([]));
  }
}

void deleteAudioFile(AudioCompleteDataClass audioData) async{
  try{
    AudioCompleteDataClass x = AudioCompleteDataClass(
      audioData.audioUrl, audioData.audioMetadataInfo, AudioPlayerState.stopped, true
    );
    fetchReduxDatabase().allAudiosList[audioData.audioUrl]!.notifier.value = x;
    DeleteAudioDataStreamClass().emitData(
      DeleteAudioDataStreamControllerClass(x)
    );
    if(fetchReduxDatabase().audioHandlerClass!.currentAudioUrl == audioData.audioUrl){
      fetchReduxDatabase().audioHandlerClass!.stop();
    }
    File selectedFile = File(audioData.audioUrl);
    if(await selectedFile.exists()){
      await selectedFile.delete();
    }
  }catch(e){
    debugPrint(e.toString());
  }
}

void runDelay(Function func, int duration) async{
  Future.delayed(Duration(milliseconds: duration), (){}).then((value){
    func();
  });
}

Future<String> copyTemporaryPath(String url) async{
  Directory temporaryDirectory = await getTemporaryDirectory();
  Directory directory = await Directory('${temporaryDirectory.path}/audio').create(recursive: true);
  File originalFile = File(url);
  String filePath = '${directory.path}/${const Uuid().v4()}.mp3';
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
  String filePath = '${directory.path}/$uniqueID.mp3';
  File newFile = await File(filePath).writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return newFile.path;
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
  Directory directory = await Directory('${temporaryDirectory.path}/audio/output').create(recursive: true);
  String filePath = '${directory.path}/${const Uuid().v4()}.jpg';
  return filePath;
}

String getNameFromAudioUrl(String url){
  return url.split('/').last.trim();
}