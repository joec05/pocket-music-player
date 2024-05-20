import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class ArtistSongsController {
  final BuildContext context;
  final Rx<ArtistSongsClass> artistSongsData;
  late StreamSubscription editAudioDataStreamClassSubscription;
  late StreamSubscription deleteAudioDataStreamClassSubscription;

  ArtistSongsController(
    this.context,
    this.artistSongsData
  );

  bool get mounted => context.mounted;

  void initializeController() {
    editAudioDataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass oldAudioData = data.oldAudioData;
        List<String> songsListValue = [...artistSongsData.value.songsList];
        songsListValue.remove(oldAudioData.audioUrl);
        artistSongsData.value.songsList = [...songsListValue];
        artistSongsData.value = artistSongsData.value.copy();
        if(artistSongsData.value.songsList.isEmpty) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      }
    });
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
    editAudioDataStreamClassSubscription.cancel();
    deleteAudioDataStreamClassSubscription.cancel();
  }
}