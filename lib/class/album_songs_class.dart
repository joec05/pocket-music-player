import 'package:music_player_app/class/image_data_class.dart';

class AlbumSongsClass{
  final String? albumName;
  final String? artistName;
  final ImageDataClass albumProfilePic;
  final List<String> songsList;

  AlbumSongsClass(this.albumName, this.artistName, this.albumProfilePic, this.songsList);
}