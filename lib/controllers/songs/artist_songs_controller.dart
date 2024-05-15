import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class ArtistSongsController {
  final BuildContext context;
  final Rx<ArtistSongsClass> artistSongsData;
  late StreamSubscription deleteAudioDataStreamClassSubscription;

  ArtistSongsController(
    this.context,
    this.artistSongsData
  );

  bool get mounted => context.mounted;

  void initializeController() {
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted) {
        AudioCompleteDataClass audioData = data.audioData;
        artistSongsData.value.songsList.remove(audioData.audioUrl);
        artistSongsData.value = artistSongsData.value.copy();
        if(artistSongsData.value.songsList.isEmpty) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  void dispose() {
    deleteAudioDataStreamClassSubscription.cancel();
  }
}