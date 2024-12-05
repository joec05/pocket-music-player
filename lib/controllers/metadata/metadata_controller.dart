import 'dart:typed_data';
import 'package:audiotags/audiotags.dart';
import 'package:audiotags/audiotags.dart' as audiotags;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pocket_music_player/global_files.dart';
import 'dart:io';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';

/// Controller used for handling FFmpeg commands
class MetadataController {
  final AudioPlayer audioPlayer = AudioPlayer();
  
  Future<AudioMetadataInfoClass?> fetchAudioMetadata(String audioUrl) async{
    final tag = await readMetadata(File(audioUrl), getImage: true);
    
    return AudioMetadataInfoClass(
      audioUrl.split('/').last, 
      tag.title,
      tag.artist,
      tag.album,
      ///tag.artist,
      tag.pictures.isEmpty ? null : tag.pictures.first.bytes
    );
  }

  /*
  Future<AudioMetadataInfoClass?> fetchAudioMetadataFFmpeg(String audioUrl) async {
    FFprobeSession res = await FFprobeKit.execute('-v quiet -print_format json=compact=1 -show_format "$audioUrl"');
    String? output = await res.getOutput();
    if(output != null){
      Map<String, dynamic> decoded = Map<String, dynamic>.from(json.decode(output));
      Map<String, dynamic> format = decoded['format'];
      if(format['tags'] != null){
        Map<String, dynamic> tags = format['tags'];
        String durationStr = format['duration'];
        double durationInMs = double.parse(durationStr) * 1000;
      }
    }
  }
  
  Future<Uint8List> fetchAlbumArtData(String audioUrl) async{
    String outputImageUrl = await createOutputImageFile();
    await FFmpegKit.execute(
      '-v quiet -i "$audioUrl" -an -vcodec copy "$outputImageUrl" -y',
    );
    if(await File(outputImageUrl).exists()){
      return File(outputImageUrl).readAsBytesSync();
    }else{
      return Uint8List.fromList([]);
    }
  }
  */
  
  Future<void> modifyTags(
    BuildContext context,
    AudioCompleteDataClass audioCompleteData,
    String title,
    String artist,
    String album,
    ///String albumArtistName,
    String? imageUrl
  ) async{
    try {
      final String tempPath = await copyTemporaryAudioPath(audioCompleteData.audioUrl);
      await AudioTags.write(tempPath, Tag(
        title: title.isEmpty ? null : title,
        trackArtist: artist.isEmpty ? null : artist,
        album: album.isEmpty ? null : album,
        ///albumArtist: albumArtistName.isEmpty ? null : albumArtistName
        pictures: [
          if(imageUrl != null)
          audiotags.Picture(
            bytes: File(imageUrl).readAsBytesSync(),
            mimeType: MimeType.png,
            pictureType: audiotags.PictureType.coverFront,
          )
        ]
      )).then((_) async {
        if(!File(audioCompleteData.audioUrl).existsSync()) {
          if(context.mounted) {
            handler.displaySnackbar(
              context, 
              SnackbarType.error, 
              tErr.fileNotFound
            );
          }
          return;
        }

        final uri = await mediaStorePlugin.getUriFromFilePath(path: audioCompleteData.audioUrl);

        if(uri == null) {
          if(context.mounted) {
            handler.displaySnackbar(
              context, 
              SnackbarType.error, 
              tErr.unknown
            );
          }
          return;
        }

        final bool edited = await mediaStorePlugin.editFile(uriString: uri.toString(), tempFilePath: tempPath);
        
        if(!edited) {
          if(context.mounted) {
            handler.displaySnackbar(
              context, 
              SnackbarType.warning, 
              tWarning.metadataPermission
            );
          }
          return;
        }

        Uint8List? imageData = imageUrl != null ? File(imageUrl).readAsBytesSync() : null;
        AudioCompleteDataClass newData = audioCompleteData.copy();
        newData.audioMetadataInfo = AudioMetadataInfoClass(
          newData.audioMetadataInfo.fileName, 
          title.isEmpty ? null : title,
          artist.isEmpty ? null : artist, 
          album.isEmpty ? null : album, 
          ///albumArtistName.isEmpty ? null : albumArtistName, 
          imageData
        );
        appStateRepo.allAudiosList[audioCompleteData.audioUrl]!.notifier.value = newData.copy();
        EditAudioMetadataStreamClass().emitData(
          EditAudioMetadataStreamControllerClass(
            appStateRepo.allAudiosList[audioCompleteData.audioUrl]!.notifier.value, audioCompleteData
          )
        );
        if(context.mounted) {
          handler.displaySnackbar(
            context, 
            SnackbarType.successful, 
            tSuccess.modifyTags
          );
        }
        appStateRepo.audioHandler?.clearTempDir();
      });
    } catch(e) {
      if(context.mounted) {
        handler.displaySnackbar(
          context, 
          SnackbarType.error, 
          e.toString()
        );
      }
    }
  }

  /*
  Future<void> modifyTagsFFmpeg(
    BuildContext context,
    AudioCompleteDataClass audioCompleteData,
    String title,
    String artist,
    String album,
    String imageUrl
  ) async{
    bool mounted = context.mounted;
    int statsDuration = 0;

    if(mounted){
      String inputFilePath = await copyTemporaryAudioPath(audioCompleteData.audioUrl);
      String outputFilePath = await createOutputAudioFile();
      String ffmpegCommand = '';
      if(imageUrl.isEmpty){
        ffmpegCommand += '-map 0:0 -acodec copy ';
      }else{
        ffmpegCommand += '-i $imageUrl -map 0:0 -acodec copy ';
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
      debugPrint(ffmpegCommand);
      if(ffmpegCommand.isNotEmpty){
        ffmpegCommand = '-y -i "$inputFilePath" $ffmpegCommand -c:a libmp3lame "$outputFilePath"';
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
                  Uint8List imageData = imageUrl.isNotEmpty ? File(imageUrl).readAsBytesSync() : Uint8List.fromList([]);
                  if(await File(outputFilePath).exists()){
                    await File(outputFilePath).copy(audioCompleteData.audioUrl).then((_) {
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
  */
}

final metadataController = MetadataController();