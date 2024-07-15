import 'package:isar/isar.dart';
import 'package:pocket_music_player/global_files.dart';
import 'package:path_provider/path_provider.dart';

class IsarController {
  Isar? isar;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        PlaylistSongsModelSchema,
        FavouriteSongModelSchema,
        AudioListenCountModelSchema
      ],
      directory: dir.path,
    );
  }

  void putPlaylist(PlaylistSongsModel playlistData) {
    isar?.writeTxn(() => isar!.playlistSongsModels.put(playlistData));
  }

  void deletePlaylist(PlaylistSongsModel playlistData) {
    isar?.writeTxn(() => isar!.playlistSongsModels.delete(playlistData.id));
  }

  Future<List<PlaylistSongsModel>> fetchPlaylists() async {
    List<PlaylistSongsModel> playlistsModel = [];
    await isar!.txn(() async => playlistsModel = await isar!.playlistSongsModels.where().findAll());
    return playlistsModel;
  }

  void putFavourite(FavouriteSongModel songData) {
    isar?.writeTxn(() => isar!.favouriteSongModels.put(songData));
  }

  void deleteFavourite(FavouriteSongModel songData) {
    isar?.writeTxn(() => isar!.favouriteSongModels.delete(songData.id));
  }

  Future<List<FavouriteSongModel>> fetchFavourites() async {
    List<FavouriteSongModel> songsModel = [];
    await isar!.txn(() async => songsModel = await isar!.favouriteSongModels.where().findAll());
    return songsModel;
  }

  void putNewCount(AudioListenCountModel countData) {
    countData.listenCount += 1;
    isar?.writeTxn(() => isar!.audioListenCountModels.put(countData));
  }

  Future<Map<String, AudioListenCountModel>> fetchAllCounts() async {
    List<AudioListenCountModel> countsModel = [];
    await isar!.txn(() async => countsModel = await isar!.audioListenCountModels.where().findAll());
    Map<String, AudioListenCountModel> mappedCounts = {};
    for(int i = 0; i < countsModel.length; i++) {
      mappedCounts[countsModel[i].audioUrl] = countsModel[i];
    }
    return mappedCounts;
  }
}

final isarController = IsarController();