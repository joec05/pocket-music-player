import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:music_player_app/global_files.dart';

class AlbumSongsController {
  final BuildContext context;
  final Rx<AlbumSongsClass> albumSongsData;
  late StreamSubscription editAudioDataStreamClassSubscription;
  late StreamSubscription deleteAudioDataStreamClassSubscription;

  AlbumSongsController(
    this.context,
    this.albumSongsData
  );

  bool get mounted => context.mounted;

  void initializeController() {
    editAudioDataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass oldAudioData = data.oldAudioData;
        List<String> songsListValue = [...albumSongsData.value.songsList];
        songsListValue.remove(oldAudioData.audioUrl);
        albumSongsData.value.songsList = [...songsListValue];
        albumSongsData.value = albumSongsData.value.copy();
        if(albumSongsData.value.songsList.isEmpty) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      }
    });
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted) {
        AudioCompleteDataClass audioData = data.audioData;
        albumSongsData.value.songsList.remove(audioData.audioUrl);
        albumSongsData.value = albumSongsData.value.copy();
        if(albumSongsData.value.songsList.isEmpty) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  void dispose() {
    deleteAudioDataStreamClassSubscription.cancel();
  }
}