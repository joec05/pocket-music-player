import 'dart:typed_data';

class AudioMetadataInfoClass{
  String fileName;
  String? title;
  String? artistName;
  String? albumName;
  String? albumArtistName;
  Uint8List? albumArt;

  AudioMetadataInfoClass(
    this.fileName, 
    this.title, 
    this.artistName, 
    this.albumName,
    this.albumArtistName,
    this.albumArt
  );
}