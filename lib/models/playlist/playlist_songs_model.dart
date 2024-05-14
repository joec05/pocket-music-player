import 'package:isar/isar.dart';
part 'playlist_songs_model.g.dart';

@Collection()
class PlaylistSongsModel{
  Id id = Isar.autoIncrement;
  final String playlistID;
  String playlistName;
  List<int> imageBytes;
  final String creationDate;
  List<String> songsList;

  PlaylistSongsModel(
    this.playlistID, 
    this.playlistName, 
    this.imageBytes, 
    this.creationDate, 
    this.songsList,
  );

  PlaylistSongsModel copy() {
    PlaylistSongsModel newModel = PlaylistSongsModel(
      playlistID, playlistName, imageBytes, creationDate, songsList
    );
    newModel.id = id;
    return newModel;
  } 
}