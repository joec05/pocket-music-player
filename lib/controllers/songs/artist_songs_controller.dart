import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class ArtistSongsController {
  final BuildContext context;
  final ArtistSongsClass artistSongsData;

  ArtistSongsController(
    this.context,
    this.artistSongsData
  );

  bool get mounted => context.mounted;

  void initializeController(){}

  void dispose(){}
}