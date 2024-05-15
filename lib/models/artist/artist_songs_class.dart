class ArtistSongsClass{
  final String? artistName;
  final List<String> songsList;

  ArtistSongsClass(this.artistName, this.songsList);

  ArtistSongsClass copy() {
    return ArtistSongsClass(
      artistName,
      songsList
    );
  }
}