import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:music_player_app/global_files.dart';

class AlbumSongsController {
  final BuildContext context;
  final Rx<AlbumSongsClass> albumSongsData;
  late StreamSubscription deleteAudioDataStreamClassSubscription;

  AlbumSongsController(
    this.context,
    this.albumSongsData
  );

  bool get mounted => context.mounted;

  void initializeController() {
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