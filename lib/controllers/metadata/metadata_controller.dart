import 'dart:typed_data';
import 'package:audiotags/audiotags.dart';
import 'package:audiotags/audiotags.dart' as audiotags;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/global_files.dart';
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
      await AudioTags.write(audioCompleteData.audioUrl, Tag(
        title: title.isEmpty ? null : title,
        trackArtist: artist.isEmpty ? null : artist,
        album: album.isEmpty ? null : album,
        ///albumArtist: albumArtistName.isEmpty ? null : albumArtistName
        pictures: [
          if(imageUrl != null)
          audiotags.Picture(
            bytes: File(imageUrl).readAsBytesSync(),
            mimeType: MimeType.png,
            pictureType: audiotags.PictureType.coverFront
          )
        ]
      )).then((_) {
        Uint8List? imageData = imageUrl != null  ? File(imageUrl).readAsBytesSync() : null;
        AudioMetadataInfoClass x = audioCompleteData.audioMetadataInfo;
        AudioCompleteDataClass y = AudioCompleteDataClass(
          audioCompleteData.audioUrl, AudioMetadataInfoClass(
            x.fileName, title.isEmpty ? null : title,
            artist.isEmpty ? null : artist, 
            album.isEmpty ? null : album, 
            ///albumArtistName.isEmpty ? null : albumArtistName, 
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
    } catch(e) {
      if(context.mounted) {
        handler.displaySnackbar(
          context, 
          SnackbarType.error, 
          //tErr.unknown
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