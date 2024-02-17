import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class FavouriteSongsController {
  final BuildContext context;
  ValueNotifier<List<String>> favouriteSongsData = ValueNotifier(appStateRepo.favouritesList);
  late StreamSubscription updateFavouriteStreamClassSubscription;

  FavouriteSongsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    updateFavouriteStreamClassSubscription = UpdateFavouriteStreamClass().updateFavouriteStream.listen((UpdateFavouriteStreamControllerClass data) {
      favouriteSongsData.value = [...data.favouritesList];
    });
  }

  void dispose(){
    favouriteSongsData.dispose();
    updateFavouriteStreamClassSubscription.cancel();
  }
}