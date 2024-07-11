import 'dart:typed_data';

class AlbumSongsClass{
  final String? albumName;
  final String? artistName;
  final Uint8List? albumProfilePic;
  List<String> songsList;

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