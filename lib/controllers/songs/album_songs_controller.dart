import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class AlbumSongsController {
  final BuildContext context;
  final AlbumSongsClass albumSongsData;

  AlbumSongsController(
    this.context,
    this.albumSongsData
  );

  bool get mounted => context.mounted;

  void initializeController(){}

  void dispose(){}
}