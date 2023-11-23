import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/sqflite/localDatabaseConfiguration.dart';

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
        await LocalDatabase().replaceAudioFavouritesData(fetchReduxDatabase().favouritesList);
        await LocalDatabase().replaceAudioPlaylistsData(fetchReduxDatabase().playlistList);
        await LocalDatabase().replaceAudioListenCountData(fetchReduxDatabase().audioListenCount);
        break;
      case AppLifecycleState.detached:
        debugPrint('appLifeCycleState detached');
        await LocalDatabase().replaceAudioFavouritesData(fetchReduxDatabase().favouritesList);
        await LocalDatabase().replaceAudioPlaylistsData(fetchReduxDatabase().playlistList);
        await LocalDatabase().replaceAudioListenCountData(fetchReduxDatabase().audioListenCount);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
