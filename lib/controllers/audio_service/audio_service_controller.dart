import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' as getx;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_music_player/global_files.dart';
import 'package:rxdart/rxdart.dart';

class AudioStateController extends GetxController {
  getx.Rx<AudioPlayerState> playerState = getx.Rx(AudioPlayerState.stopped);
  getx.Rx<String?> currentAudioUrl = getx.Rx<String?>(null);

  void updatePlayerState(AudioPlayerState state) {
    playerState.value = state;
    update(['playerState']);
  }

  void updateAudioUrl(String? url) {
    currentAudioUrl.value = url;
    update(['currentAudioUrl']);
  }
}

class MyAudioHandler extends BaseAudioHandler with QueueHandler {
  final audioPlayer = AudioPlayer();
  final currentSong = BehaviorSubject<AudioCompleteDataClass>();
  final audioStateController = Get.put(AudioStateController());
  List<String> currentDirectoryAudioList = [];
  List<String> currentDirectoryAudioListShuffled = [];
  LoopStatus currentLoopStatus = LoopStatus.repeatCurrent;

  void initializeController() {
    audioPlayer.playbackEventStream.listen(_broadcastState);
    audioPlayer.playerStateStream.listen((event) {
      if(event.processingState == ProcessingState.completed){
        startNextAfterFinishAudio();
      }else if(event.processingState == ProcessingState.ready){
        if(!event.playing){
          audioStateController.updatePlayerState(AudioPlayerState.paused);
        }else{
          audioStateController.updatePlayerState(AudioPlayerState.playing);
        }
      }
    });
  }

  void dispose() {
    audioPlayer.dispose();
    currentSong.close();
    clearTempDir();
  }

  void clearTempDir() async {
    Directory dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
  }

  void updateListDirectory(List<String> directory, List<String> directoryShuffled) async {
    currentDirectoryAudioList = directory.where((songID) => appStateRepo.allAudiosList[songID] != null).toList();
    currentDirectoryAudioListShuffled = directoryShuffled;
    /*
    List<MediaItem> mediaItemList = await Future.wait(
      currentDirectoryAudioList.map((songID) async {
        AudioCompleteDataClass audioData = appStateRepo.allAudiosList[songID]!.notifier.value;
        AudioMetadataInfoClass metadata = audioData.audioMetadataInfo;
        final String artUri = await writeTemporaryAudioBytes(metadata.albumArt == null ? appStateRepo.audioImageData! : metadata.albumArt!);
        return MediaItem(
          id: audioData.audioUrl,
          album: metadata.albumName,
          artist: metadata.artistName,
          title: metadata.title ?? metadata.fileName,
          artUri: Uri.file(artUri)
        );      
      }).toList()
    );
    queue.add(mediaItemList);
    */
  }
  
  @override
  Future<void> skipToQueueItem(int index) async {
    await setCurrentSong(queue.value[index % queue.value.length].id);
  }

  Future<void> startNextAfterFinishAudio() async {
    if(audioStateController.currentAudioUrl.value == null) {
      return;
    }

    if (currentLoopStatus == LoopStatus.repeatCurrent) {
      final currentAudioUrl = audioStateController.currentAudioUrl.value;

      if(currentAudioUrl == null) {
        return;
      }

      await setNewAudioSession(currentAudioUrl);
    }else if(currentLoopStatus == LoopStatus.repeatAll){
      audioStateController.updatePlayerState(AudioPlayerState.completed);
      await skipToNext();
    }else{
      audioStateController.updatePlayerState(AudioPlayerState.completed);
      await setCurrentSong(
        currentDirectoryAudioListShuffled[(currentDirectoryAudioListShuffled.indexOf(audioStateController.currentAudioUrl.value!) + 1) % currentDirectoryAudioListShuffled.length]
      );
    }
  }

  Future<void> setCurrentSong(String audioUrl) async{
    try {
      final audioCompleteData = appStateRepo.allAudiosList[audioUrl]!.notifier.value;

      if(File(audioCompleteData.audioUrl).existsSync()) {
        if(audioStateController.playerState.value == AudioPlayerState.paused) {
          play();
        }
        final _ = await setNewAudioSession(audioCompleteData.audioUrl);
      }  
    } on PlayerException catch (e) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to play audio file'))
      );
      debugPrint("Error code: ${e.code}");
      debugPrint("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      ///rootScaffoldMessengerKey.currentState?.showSnackBar(
      ///  SnackBar(content: Text(e.message ?? 'Failed to play audio file'))
      ///);
      debugPrint("Connection aborted: ${e.message}");
    } catch (e) {
      ///rootScaffoldMessengerKey.currentState?.showSnackBar(
      ///  SnackBar(content: Text(e.toString()))
      ///);
      debugPrint(e.toString());
    }
  }

  void addAudioListenCount(AudioCompleteDataClass audioCompleteData) async{
    if(File(audioCompleteData.audioUrl).existsSync()) {
      AudioListenCountModel listenCountData = appStateRepo.audioListenCount[audioCompleteData.audioUrl]!;
      AudioListenCountModel updatedListenCountData = AudioListenCountModel(listenCountData.audioUrl, listenCountData.listenCount + 1);
      appStateRepo.audioListenCount[audioCompleteData.audioUrl] = updatedListenCountData;
      isarController.putNewCount(updatedListenCountData);
    }
  }

  Future<void> setNewAudioSession(String currentAudioUrl) async{
    final audioCompleteData = appStateRepo.allAudiosList[currentAudioUrl]!.notifier.value;
    final audioUrls = appStateRepo.allAudiosList.keys.toList();
    final index = audioUrls.indexWhere((e) => e == currentAudioUrl);
    
    if(index == -1) {
      return;
    }
    
    if(File(audioCompleteData.audioUrl).existsSync()) {
      List<MediaItem> queueList = [];
      final nextIndex = (index + 1) % audioUrls.length;
      final previousIndex = index == 0 ? audioUrls.length - 1 : index - 1;

      for(int i = 0; i < audioUrls.length; i++) {
        if(i == nextIndex || i == previousIndex) {
          final audioData = appStateRepo.allAudiosList[audioUrls[i]]!.notifier.value;
          final String artUri = await writeTemporaryAudioBytes(audioData.audioMetadataInfo.albumArt == null ? appStateRepo.audioImageData! : audioData.audioMetadataInfo.albumArt!);
          queueList.add(
            MediaItem(
              id: audioUrls[i],
              title: audioData.audioMetadataInfo.title ?? audioData.audioMetadataInfo.fileName,
              artUri: Uri.file(artUri),
            )
          );
        } else if (i == index){
          AudioMetadataInfoClass metadata = audioCompleteData.audioMetadataInfo;
          currentSong.add(audioCompleteData);
          final String artUri = await writeTemporaryAudioBytes(audioCompleteData.audioMetadataInfo.albumArt == null ? appStateRepo.audioImageData! : audioCompleteData.audioMetadataInfo.albumArt!);
          mediaItem.add(
            MediaItem(
              id: audioCompleteData.audioUrl,
              album: metadata.albumName,
              artist: metadata.artistName,
              title: metadata.title ?? metadata.fileName,
              artUri: Uri.file(artUri),
              duration: await audioPlayer.setAudioSource(
                ProgressiveAudioSource(Uri.parse(audioCompleteData.audioUrl)),
              ),
            )
          );
          queueList.add(mediaItem.value!);
        } else {
          final audioData = appStateRepo.allAudiosList[audioUrls[i]]!.notifier.value;
          queueList.add(
            MediaItem(
              id: audioUrls[i],
              title: audioData.audioMetadataInfo.title ?? audioData.audioMetadataInfo.fileName
            )
          );
        }
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        queue.add(queueList);
        addAudioListenCount(audioCompleteData);
        audioStateController.updateAudioUrl(audioCompleteData.audioUrl);
        clearTempDir();
      });
    }
  }

  @override
  Future<void> play() async {
    try {
      await audioPlayer.play();
    } catch (_) {}
  }

  @override
  Future<void> pause() async {
    try {
      await audioPlayer.pause();
    } catch (_) {}
  }

  @override
  Future<void> seek(Duration position) async => await audioPlayer.seek(position);
  
  @override
  Future<void> stop() async {
    await audioPlayer.stop().then((_) {
      audioStateController.updatePlayerState(AudioPlayerState.stopped);
      audioStateController.updateAudioUrl(null);
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
        androidCompactActionIndices: const [0, 1, 2],
        playing: isPlaying,
        queueIndex: queueIndex,
        bufferedPosition: audioPlayer.bufferedPosition,
        speed: audioPlayer.speed,
        updatePosition: audioPlayer.position
      ));
    }

  }
}