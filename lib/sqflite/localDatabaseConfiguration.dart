// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_player_app/class/AudioListenCountClass.dart';
import 'package:music_player_app/class/AudioListenCountNotifier.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class LocalDatabase{
  static final LocalDatabase _instance = LocalDatabase._internal();
  factory LocalDatabase() => _instance;
  LocalDatabase._internal();
  late Database? _database;
  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    await initDatabase();
    return _database!;
  }

  Future<void> initDatabase() async{
    final dbPath = await getDatabasesPath();
    final pathToDatabase = path.join(dbPath, 'user_database.db');
    _database = await openDatabase(
      pathToDatabase,
      version: 3,
      onCreate: (Database db, int version) async{
        /*
        await db.execute(
          """
            DROP TABLE audio_listen_count_data
          """
        );
         await db.execute(
          """
            DROP TABLE audio_favourites_data
          """
        );
        await db.execute(
          """
            DROP TABLE audio_playlists_data
          """
        );
        */
        await db.execute(
          """
          CREATE TABLE IF NOT EXISTS audio_listen_count_data(
            audio_url TEXT PRIMARY KEY NOT NULL,
            listen_count INT NOT NULL
          )
          """
        );
        await db.execute(
          """
          CREATE TABLE IF NOT EXISTS audio_favourites_data(
            audio_url TEXT PRIMARY KEY NOT NULL
          )
          """
        );
        await db.execute(
          """
          CREATE TABLE IF NOT EXISTS audio_playlists_data(
            playlist_id TEXT PRIMARY KEY NOT NULL,
            playlist_name TEXT NOT NULL,
            playlist_profile_pic_link_path TEXT NOT NULL,
            playlist_profile_pic_link_bytes TEXT NOT NULL,
            creation_date TEXT NOT NULL,
            songs_list TEXT[] NOT NULL
          )
          """
        );
        
      },
    );
  }

  Future<void> replaceAudioListenCountData(Map<String, AudioListenCountNotifier> listenCountDataMap) async{
    final db = await database;
    await db.delete('audio_listen_count_data');
    await db.transaction((txn) async{
      for(final listenCountData in listenCountDataMap.values){
        await txn.insert('audio_listen_count_data', {
          'audio_url': listenCountData.notifier.value.audioUrl,
          'listen_count': listenCountData.notifier.value.listenCount
        });
      }
    });
  }

  Future<Map<String, AudioListenCountNotifier>> fetchAudioListenCountData() async{
    final db = await database;
    Map<String, AudioListenCountNotifier> getAudioListenCountData = {};
    await db.query(
      'audio_listen_count_data'
    ).then((value) async{
      for(int i = 0; i < value.length; i++){
        Map listenCountData = value[i];
        getAudioListenCountData[listenCountData['audio_url']] = AudioListenCountNotifier(
          listenCountData['audio_url'], ValueNotifier(
            AudioListenCountClass(
              listenCountData['audio_url'], listenCountData['listen_count']
            )
          )
        );
      }
    });
    return getAudioListenCountData;
  }

  Future<void> replaceAudioFavouritesData(List<String> favouritesDataList) async{
    final db = await database;
    await db.delete('audio_favourites_data');
    await db.transaction((txn) async{
      for(final audioUrl in favouritesDataList){
        await txn.insert('audio_favourites_data', {
          'audio_url': audioUrl
        });
      }
    });
  }

  Future<List<String>> fetchAudioFavouritesData() async{
    final db = await database;
    List<Map> getAudioFavouritesData = [];
    await db.query(
      'audio_favourites_data'
    ).then((value) async{
      getAudioFavouritesData = value;
    });
    final List<String> results = getAudioFavouritesData.map((e) => e['audio_url'] as String).toList();    
    return results;
  }

  Future<void> replaceAudioPlaylistsData(List<PlaylistSongsClass> playlistsDataList) async{
    final db = await database;
    await db.delete('audio_playlists_data');
    await db.transaction((txn) async{
      for(final playlistData in playlistsDataList){
        await txn.insert('audio_playlists_data', {
          'playlist_id': playlistData.playlistID,
          'playlist_name': playlistData.playlistName,
          'playlist_profile_pic_link_path': playlistData.playlistProfilePic.path,
          'playlist_profile_pic_link_bytes': jsonEncode(playlistData.playlistProfilePic.bytes),
          'creation_date': playlistData.creationDate,
          'songs_list': jsonEncode(playlistData.songsList)
        });
      }
    });
  }

  Future<List<PlaylistSongsClass>> fetchAudioPlaylistsData() async{
    final db = await database;
    List<Map> getAudioPlaylistsData = [];
    await db.query(
      'audio_playlists_data'
    ).then((value) async{
      getAudioPlaylistsData = value;
    });
    final List<PlaylistSongsClass> results = getAudioPlaylistsData.map((e) {
      return PlaylistSongsClass(
        e['playlist_id'], e['playlist_name'], ImageDataClass(
          e['playlist_profile_pic_link_path'], Uint8List.fromList(List<int>.from(jsonDecode(e['playlist_profile_pic_link_bytes'])))
        ),
        e['creation_date'], List<String>.from(jsonDecode(e['songs_list']))
      );
    }).toList();    
    return results;
  }
}