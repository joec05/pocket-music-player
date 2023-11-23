// ignore_for_file: depend_on_referenced_packages

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';
import 'package:music_player_app/class/AudioMetadataInfoClass.dart';
import 'package:music_player_app/streams/CurrentAudioStreamClass.dart';
import 'package:rxdart/rxdart.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler {
  final audioPlayer = AudioPlayer();
  final currentSong = BehaviorSubject<AudioCompleteDataClass>();
  String currentAudioUrl = '';
  List<String> currentDirectoryAudioList = [];
  List<String> currentDirectoryAudioListShuffled = [];
  LoopStatus currentLoopStatus = LoopStatus.repeatCurrent;
  AudioPlayerState playerState = AudioPlayerState.stopped;

  void init() {
    audioPlayer.playbackEventStream.listen(_broadcastState);
    audioPlayer.playerStateStream.listen((event) {
      if(event.processingState == ProcessingState.completed){
        startNextAfterFinishAudio();
      }else if(event.processingState == ProcessingState.ready){
        if(!event.playing){
          playerState = AudioPlayerState.paused;
          updateReduxAudioPlayerState(playerState);
        }else{
          playerState = AudioPlayerState.playing;
          updateReduxAudioPlayerState(playerState);
        }
      }
    });
  }

  void updateListDirectory(List<String> directory,List<String> directoryShuffled){
    currentDirectoryAudioList = directory;
    currentDirectoryAudioListShuffled = directoryShuffled;
    List<MediaItem> mediaItemList = currentDirectoryAudioList.map((songID){
      AudioCompleteDataClass audioData = fetchReduxDatabase().allAudiosList[songID]!.notifier.value;
      AudioMetadataInfoClass metadata = audioData.audioMetadataInfo;
      return MediaItem(
        id: audioData.audioUrl,
        album: metadata.albumName,
        artist: metadata.artistName,
        title: metadata.title ?? 'Unknown',
        artUri: Uri.file(fetchReduxDatabase().audioImageDataClass!.path)
      );      
    }).toList();
    queue.add(mediaItemList);
  }
  
  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0) {
      await setCurrentSong(fetchReduxDatabase().allAudiosList[currentDirectoryAudioList[currentDirectoryAudioList.length - 1]]!.notifier.value);
    }else if(index >= queue.value.length){
      await setCurrentSong(fetchReduxDatabase().allAudiosList[currentDirectoryAudioList[0]]!.notifier.value);
    }else{
      await setCurrentSong(fetchReduxDatabase().allAudiosList[currentDirectoryAudioList[index]]!.notifier.value);
    }
  }

  Future<void> startNextAfterFinishAudio() async {
    if (currentLoopStatus == LoopStatus.repeatCurrent) {
      await setNewAudioSession(fetchReduxDatabase().allAudiosList[currentAudioUrl]!.notifier.value);
    }else if(currentLoopStatus == LoopStatus.repeatAll){
      playerState = AudioPlayerState.completed;
      updateReduxAudioPlayerState(playerState);
      await skipToNext();
    }else{
      playerState = AudioPlayerState.completed;
      updateReduxAudioPlayerState(playerState);
      await setCurrentSong(fetchReduxDatabase().allAudiosList[
        currentDirectoryAudioListShuffled[(currentDirectoryAudioListShuffled.indexOf(currentAudioUrl) + 1) % currentDirectoryAudioListShuffled.length]
      ]!.notifier.value);
    }
  }

  Future<void> setCurrentSong(AudioCompleteDataClass audioCompleteData) async{
    if(audioCompleteData.audioUrl != currentAudioUrl){
      updateReduxAudioPlayerState(AudioPlayerState.completed);
    }
    await setNewAudioSession(audioCompleteData);
    playerState = AudioPlayerState.playing;    
  }

  Future<void> setNewAudioSession(AudioCompleteDataClass audioCompleteData) async{
    AudioMetadataInfoClass metadata = audioCompleteData.audioMetadataInfo;
    currentSong.add(audioCompleteData);
    currentAudioUrl = audioCompleteData.audioUrl;
    mediaItem.add(
      MediaItem(
        id: audioCompleteData.audioUrl,
        album: metadata.albumName,
        artist: metadata.artistName,
        title: metadata.title ?? 'Unknown',
        artUri: Uri.file(fetchReduxDatabase().audioImageDataClass!.path),
        extras: <String, dynamic>{
        },
      )
    );
    addAudioListenCount(audioCompleteData);
    await audioPlayer.setAudioSource(
      ProgressiveAudioSource(Uri.parse(audioCompleteData.audioUrl)),
    );
    emitCurrentAudioStreamData();
  }

  void updateReduxAudioPlayerState(AudioPlayerState newState){
    if(currentAudioUrl.isNotEmpty && fetchReduxDatabase().allAudiosList[currentAudioUrl] != null){
      AudioCompleteDataClass x = fetchReduxDatabase().allAudiosList[currentAudioUrl]!.notifier.value;
      AudioCompleteDataClass y = AudioCompleteDataClass(
        x.audioUrl, x.audioMetadataInfo, newState, x.deleted
      );
      fetchReduxDatabase().allAudiosList[currentAudioUrl]!.notifier.value = y;
      CurrentAudioStreamClass().emitData(
        CurrentAudioStreamControllerClass(y)
      );
    }
  }

  void emitCurrentAudioStreamData(){
    if(currentAudioUrl.isNotEmpty && fetchReduxDatabase().allAudiosList[currentAudioUrl] != null){
      AudioCompleteDataClass x = fetchReduxDatabase().allAudiosList[currentAudioUrl]!.notifier.value;
      AudioCompleteDataClass y = AudioCompleteDataClass(
        x.audioUrl, x.audioMetadataInfo, AudioPlayerState.playing, x.deleted
      );
      fetchReduxDatabase().allAudiosList[currentAudioUrl]!.notifier.value = y;
      CurrentAudioStreamClass().emitData(
        CurrentAudioStreamControllerClass(
          y
        )
      );
    }
  }

  @override
  Future<void> play() async {
    await audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    await audioPlayer.pause();
  }
  
  @override
  Future<void> stop() async {
    await audioPlayer.stop().then((value){
      playerState = AudioPlayerState.stopped;
      updateReduxAudioPlayerState(playerState);
      currentAudioUrl = '';
    });
  }

  void modifyLoopStatus(LoopStatus newStatus){
    currentLoopStatus = newStatus;
  }

  void _broadcastState(PlaybackEvent event) {
    bool isPlaying = audioPlayer.playing;
    final songValue = currentSong.hasValue == false ? null : currentSong.value.audioUrl;
    if(songValue != null){
      final queueIndex = currentDirectoryAudioList.indexOf(songValue);
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          isPlaying ? MediaControl.pause : MediaControl.play ,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[audioPlayer.processingState]!,
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        playing: isPlaying,
        queueIndex: queueIndex,
      ));
    }

  }
}