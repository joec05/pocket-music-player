import 'dart:typed_data';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_audio/log.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:ffmpeg_kit_flutter_audio/statistics.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';
import 'dart:convert';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffprobe_session.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:device_info_plus/device_info_plus.dart';

/// Controller used for handling FFmpeg commands
class FFmpegController {

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
    }
    return null;
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

  Future<void> modifyTags(
    BuildContext context,
    AudioCompleteDataClass audioCompleteData,
    String title,
    String artist,
    String album,
    String albumArtist,
    String imageUrl
  ) async{
    bool mounted = context.mounted;
    int statsDuration = 0;

    if(mounted){
      String inputFilePath = await copyTemporaryAudioPath(audioCompleteData.audioUrl);
      String outputFilePath = await createOutputAudioFile();
      String ffmpegCommand = '';
      if(imageUrl.isEmpty){
        ffmpegCommand += '-map 0:0 -c copy ';
      }else{
        ffmpegCommand += '-i $imageUrl -map 0:0 -c copy ';
      }
      if(title != audioCompleteData.audioMetadataInfo.title){
        ffmpegCommand += '-metadata title="$title" ';
      }
      if(artist.isEmpty){
        ffmpegCommand += '-metadata artist= ';
      }else{
        ffmpegCommand += '-metadata artist="$artist" ';
      }
      if(album.isEmpty){
        ffmpegCommand += '-metadata album= ';
      }else{
        ffmpegCommand += '-metadata album="$album" ';
      }
      if(albumArtist.isEmpty){
        ffmpegCommand += '-metadata album_artist= ';
      }else{
        ffmpegCommand += '-metadata album_artist="$albumArtist" ';
      }
      debugPrint(ffmpegCommand);
      if(ffmpegCommand.isNotEmpty){
        ffmpegCommand = '-y -i "$inputFilePath" $ffmpegCommand "$outputFilePath"';
        ffmpegCommand = '-i "$inputFilePath" -metadata title="$title" -codec copy "$outputFilePath"';
        FFmpegKit.executeAsync(
          ffmpegCommand, 
          (session) async {
            FFmpegKitConfig.enableLogCallback((log) async{
              final message = log.getMessage();
              debugPrint(message);
            });
            final returnCode = await session.getReturnCode();
            if(mounted){
              if (ReturnCode.isSuccess(returnCode) && (statsDuration / 1000).round() == (audioCompleteData.audioMetadataInfo.duration / 1000).round()) {
                bool permissionIsGranted = false;
                ph.Permission? permission = ph.Permission.manageExternalStorage;
                final androidInfo = await DeviceInfoPlugin().androidInfo;
                if(Platform.isAndroid && androidInfo.version.sdkInt >= 30) {        
                  permissionIsGranted = await permission.isGranted;
                  if(!permissionIsGranted){
                    await permission.request();
                    permissionIsGranted = await permission.isGranted;
                  }
                } else {
                  permissionIsGranted = true;
                }
                if(permissionIsGranted){
                  ImageDataClass imageData = imageUrl.isNotEmpty ? ImageDataClass(imageUrl, File(imageUrl).readAsBytesSync()) : ImageDataClass('', Uint8List.fromList([]));
                  if(await File(outputFilePath).exists()){
                    await File(outputFilePath).copy(audioCompleteData.audioUrl).then((_) {
                      AudioMetadataInfoClass x = audioCompleteData.audioMetadataInfo;
                      AudioCompleteDataClass y = AudioCompleteDataClass(
                        audioCompleteData.audioUrl, AudioMetadataInfoClass(
                          x.fileName, x.duration, title,
                          artist.isEmpty ? null : artist, 
                          album.isEmpty ? null : album, 
                          albumArtist.isEmpty ? null : albumArtist, 
                          imageData
                        ), audioCompleteData.playerState, audioCompleteData.deleted
                      );
                      appStateRepo.allAudiosList[audioCompleteData.audioUrl]!.notifier.value = y;
                      EditAudioMetadataStreamClass().emitData(
                        EditAudioMetadataStreamControllerClass(
                          y, audioCompleteData
                        )
                      );
                      if(context.mounted) {
                        handler.displaySnackbar(
                          context, 
                          SnackbarType.successful, 
                          tSuccess.modifyTags
                        );
                      }
                    });
                  } else {
                    if(context.mounted) {
                      handler.displaySnackbar(
                        context, 
                        SnackbarType.error, 
                        tErr.dirNotFound
                      );
                    }
                  }
                } else {
                  if(context.mounted) {
                    handler.displaySnackbar(
                      context, 
                      SnackbarType.warning, 
                      tWarning.metadataPermission
                    );
                  }
                }
              } else if (ReturnCode.isCancel(returnCode)) {
                if(context.mounted) {
                  handler.displaySnackbar(
                    context, 
                    SnackbarType.error, 
                    tErr.cancelled
                  );
                }
              } else {
                if(context.mounted) {
                  handler.displaySnackbar(
                    context, 
                    SnackbarType.error, 
                    tErr.unknown
                  );
                }
              }
            }
          }, (Log log){},
          (Statistics statistics) {
            statsDuration = statistics.getTime().toInt();
          }
        );
      }
    }
  }

}

final ffmpegController = FFmpegController();