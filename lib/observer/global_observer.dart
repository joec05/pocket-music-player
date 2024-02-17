import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class GlobalObserver extends WidgetsBindingObserver{
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        debugPrint('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        debugPrint('appLifeCycleState resumed');
        await LocalDatabase().fetchAudioListenCountData();
        await LocalDatabase().fetchAudioFavouritesData();
        await LocalDatabase().fetchAudioPlaylistsData();
        break;
      case AppLifecycleState.paused:
        debugPrint('appLifeCycleState paused');
        await LocalDatabase().replaceAudioFavouritesData(appStateRepo.favouritesList);
        await LocalDatabase().replaceAudioPlaylistsData(appStateRepo.playlistList);
        await LocalDatabase().replaceAudioListenCountData(appStateRepo.audioListenCount);
        break;
      case AppLifecycleState.detached:
        debugPrint('appLifeCycleState detached');
        await LocalDatabase().replaceAudioFavouritesData(appStateRepo.favouritesList);
        await LocalDatabase().replaceAudioPlaylistsData(appStateRepo.playlistList);
        await LocalDatabase().replaceAudioListenCountData(appStateRepo.audioListenCount);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
