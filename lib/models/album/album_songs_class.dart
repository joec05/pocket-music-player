import 'package:music_player_app/global_files.dart';

class AlbumSongsClass{
  final String? albumName;
  final String? artistName;
  final ImageDataClass albumProfilePic;
  final List<String> songsList;

  AlbumSongsClass(this.albumName, this.artistName, this.albumProfilePic, this.songsList);

  AlbumSongsClass copy() {
    return AlbumSongsClass(
      albumName, 
      artistName, 
      albumProfilePic, 
      songsList
    );
  }
}