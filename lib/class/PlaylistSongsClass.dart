import 'package:music_player_app/class/ImageDataClass.dart';

class PlaylistSongsClass{
  final String playlistID;
  String playlistName;
  ImageDataClass playlistProfilePic;
  final String creationDate;
  final List<String> songsList;

  PlaylistSongsClass(this.playlistID, this.playlistName, this.playlistProfilePic, this.creationDate, this.songsList);
}