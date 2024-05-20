class ArtistSongsClass{
  final String? artistName;
  List<String> songsList;

  ArtistSongsClass(this.artistName, this.songsList);

  ArtistSongsClass copy() {
    return ArtistSongsClass(
      artistName,
      songsList
    );
  }
}