import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class FavouriteSongsController {
  final BuildContext context;
  List<FavouriteSongModel> favouriteSongsData = List<FavouriteSongModel>.from(appStateRepo.favoritesList).obs;
  late StreamSubscription updateFavouriteStreamClassSubscription;

  FavouriteSongsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    updateFavouriteStreamClassSubscription = UpdateFavouriteStreamClass().updateFavouriteStream.listen((UpdateFavouriteStreamControllerClass data) {
      favouriteSongsData.assignAll(data.favoritesList);
    });
  }

  void dispose(){
    updateFavouriteStreamClassSubscription.cancel();
  }
}