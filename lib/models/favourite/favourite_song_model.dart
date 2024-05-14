import 'package:isar/isar.dart';
part 'favourite_song_model.g.dart';

@Collection()
class FavouriteSongModel {
  Id id = Isar.autoIncrement;
  String songPath;

  FavouriteSongModel(
    this.songPath
  );
}