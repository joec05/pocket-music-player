import 'package:isar/isar.dart';
part 'audio_listen_count_model.g.dart';

@Collection()
class AudioListenCountModel{
  Id id = Isar.autoIncrement;
  final String audioUrl;
  int listenCount;

  AudioListenCountModel(this.audioUrl, this.listenCount);
}