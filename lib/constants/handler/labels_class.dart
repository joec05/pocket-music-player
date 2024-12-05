/// Stores fixed text to display in an error snackbar, depending on the type of the error
class ErrorLabels {

  final title = "Error!!!";

  final unknown = "An unknown error occured";

  final cancelled = "Process has been cancelled";

  final dirNotFound = "Cannot find directory";

  final fileNotFound = "File not found";
  
}

class SuccessLabels {
  final title = "Success!!!";

  final modifyTags = "Successfully updated your song's information";

  final modifyPlaylist = "Successfully updated your playlist's information";

  final scan = "Successfully scanned your folders";

  final createPlaylistAddSong = "Successfully created your playlist and added your song";

  final addSongToPlaylist = "Successfully added your song to your playlist";

  final removeSongFromPlaylist = "Successfully removed your song from your playlist";

  final addSongToFavorites = "Successfully added your song to favorites";

  final removeSongFromFavorites = "Successfully removed your song from favorites";
  
  final deleteSong = "Successfully deleted your song";
}

class WarningLabels {

  final scanPermission = "Your permission is needed to scan your folders!!!";
  
  final metadataPermission = "Your permission is needed to update your song's metadata information!!!";

}

final tWarning = WarningLabels();

final tErr = ErrorLabels();

final tSuccess = SuccessLabels();