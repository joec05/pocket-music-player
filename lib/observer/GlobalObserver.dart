import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/sqflite/localDatabaseConfiguration.dart';
import 'package:music_player_app/state/main.dart';

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
        await LocalDatabase().replaceAudioFavouritesData(appStateClass.favouritesList);
        await LocalDatabase().replaceAudioPlaylistsData(appStateClass.playlistList);
        await LocalDatabase().replaceAudioListenCountData(appStateClass.audioListenCount);
        break;
      case AppLifecycleState.detached:
        debugPrint('appLifeCycleState detached');
        await LocalDatabase().replaceAudioFavouritesData(appStateClass.favouritesList);
        await LocalDatabase().replaceAudioPlaylistsData(appStateClass.playlistList);
        await LocalDatabase().replaceAudioListenCountData(appStateClass.audioListenCount);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
