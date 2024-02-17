import 'package:music_player_app/global_files.dart';

class PlaylistSongsClass{
  final String playlistID;
  String playlistName;
  ImageDataClass playlistProfilePic;
  final String creationDate;
  List<String> songsList;

  PlaylistSongsClass(
    this.playlistID, 
    this.playlistName, 
    this.playlistProfilePic, 
    this.creationDate, 
    this.songsList
  );

  PlaylistSongsClass copy() {
    return PlaylistSongsClass(
      playlistID, 
      playlistName, 
      playlistProfilePic, 
      creationDate, 
      [...songsList]
    );
  }
}