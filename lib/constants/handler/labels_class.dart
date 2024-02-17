/// Stores fixed text to display in an error snackbar, depending on the type of the error
class ErrorLabels {
  final title = "Error!!!";

  final unknown = "An unknown error occured";

  final cancelled = "Process has been cancelled";
}

class SuccessLabels {
  final title = "Success!!!";

  final modifyTags = "Successfully updated your song's information";

  final scan = "Successfully scanned your folders";

  final createPlaylistAddSong = "Successfully created your playlist and added your song";

  final addSongToPlaylist = "Successfully added your song to your playlist";

  final removeSongFromPlaylist = "Successfully removed your song from your playlist";

  final addSongToFavourites = "Successfully added your song to favourites";

  final removeSongFromFavourites = "Successfully removed your song from favourites";
  
  final deleteSong = "Successfully deleted your song";
}


final tErr = ErrorLabels();

final tSuccess = SuccessLabels();