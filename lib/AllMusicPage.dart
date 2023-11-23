// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/DisplayFavouriteSongs.dart';
import 'package:music_player_app/DisplayMostPlayedSongs.dart';
import 'package:music_player_app/DisplayRecentlyAddedSongs.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';
import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/AudioListenCountClass.dart';
import 'package:music_player_app/class/AudioListenCountNotifier.dart';
import 'package:music_player_app/class/AudioRecentlyAddedClass.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/custom/CustomAudioPlayer.dart';
import 'package:music_player_app/custom/CustomButton.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/service/AudioHandler.dart';
import 'package:music_player_app/sqflite/localDatabaseConfiguration.dart';
import 'package:music_player_app/styles/AppStyles.dart';
import 'package:music_player_app/transition/RightToLeftTransition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:device_info_plus/device_info_plus.dart';

class AllMusicPageWidget extends StatelessWidget {
  final void Function(bool, LoadType) setLoadingState;
  const AllMusicPageWidget({super.key, required this.setLoadingState});

  @override
  Widget build(BuildContext context) {
    return _AllMusicPageWidgetStateful(setLoadingState: setLoadingState);
  }
}

class _AllMusicPageWidgetStateful extends StatefulWidget {
  final Function setLoadingState;
  const _AllMusicPageWidgetStateful({required this.setLoadingState});

  @override
  State<_AllMusicPageWidgetStateful> createState() => _AllMusicPageWidgetState();
}

class _AllMusicPageWidgetState extends State<_AllMusicPageWidgetStateful> with AutomaticKeepAliveClientMixin{
  List<String> audioUrls = [];
  List<AudioRecentlyAddedClass> recentlyAddedAudio = [];

  @override
  void initState(){
    super.initState();
    fetchLocalSongs(LoadType.initial);
  }

  @override void dispose(){
    super.dispose();
  }
  
  void fetchLocalSongs(LoadType loadType) async{
    bool permissionIsGranted = false;
    ph.Permission? permission;
    if(Platform.isAndroid){
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if(androidInfo.version.sdkInt <= 32){
        permission = ph.Permission.storage;
      }else{
        permission = ph.Permission.audio;
      }
    }
    permissionIsGranted = await permission!.isGranted;
    if(!permissionIsGranted){
      await permission.request();
      permissionIsGranted = await permission.isGranted;
    }
    if(permissionIsGranted){
      await initializeDefaultAudioImage().then((value) async{
        await initializeAudioService().then((value) async{
          Directory dir = Directory(defaultDirectory);
          List<String> songsList =  dir.listSync(recursive: true, followLinks: false).map((e) => e.path).where((e) => e.endsWith('.mp3')).toList();
          final Map<String, AudioCompleteDataNotifier> filesCompleteDataList = {};
          final Map<String, AudioListenCountNotifier> localListenCountData = await LocalDatabase().fetchAudioListenCountData();
          Map<String, AudioListenCountNotifier> getListenCountData = {};
          List<String> songUrlsList = [];

          var statResults = await Future.wait([
            for(var path in songsList) FileStat.stat(path)
          ]);
          
          for(int i = 0; i < songsList.length; i++){
            String path = songsList[i];
            var metadata = await fetchAudioMetadata(path);
            if(metadata != null){
              songUrlsList.add(path);
              recentlyAddedAudio.add(
                AudioRecentlyAddedClass(path, statResults[i].changed.toIso8601String())
              );
              filesCompleteDataList[path] = AudioCompleteDataNotifier(
                path, 
                ValueNotifier(
                  AudioCompleteDataClass(
                    path, metadata, AudioPlayerState.stopped, false
                  )
                ),
              );
              if(localListenCountData[path] != null){
                getListenCountData[path] = localListenCountData[path]!;
              }else{
                getListenCountData[path] = AudioListenCountNotifier(
                  path, ValueNotifier(AudioListenCountClass(path, 0))
                );
              }
            }
          }
          
          recentlyAddedAudio.sort((a, b) => b.modifiedDate.compareTo(a.modifiedDate));
          recentlyAddedAudio = recentlyAddedAudio.sublist(0, min(recentlyAddedAudio.length, 15)); 
          if(mounted){
            audioUrls = songUrlsList;
            StoreProvider.of<AppState>(context).dispatch(AllAudiosList(filesCompleteDataList));
            StoreProvider.of<AppState>(context).dispatch(AudioListenCount(getListenCountData));
            StoreProvider.of<AppState>(context).dispatch(FavouritesList(await LocalDatabase().fetchAudioFavouritesData()));
            StoreProvider.of<AppState>(context).dispatch(PlaylistList(await LocalDatabase().fetchAudioPlaylistsData()));
          }
          setState((){});
        });
      });   
    }
    Future.delayed(const Duration(milliseconds: 1500), (){
      widget.setLoadingState(true, loadType);
    });
  }

  Future<void> initializeAudioService() async{
    if(fetchReduxDatabase().audioHandlerClass == null){
      MyAudioHandler audioHandler = await AudioService.init(
        builder: () => MyAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.example.music_player_app',
          androidNotificationChannelName: 'Music playback',
        ),
      );
      audioHandler.init();
      if(mounted){
        StoreProvider.of<AppState>(context).dispatch(AudioHandlerClass(audioHandler));
      }
    }
  }

  Future<void> initializeDefaultAudioImage() async{
    ByteData byteData = await rootBundle.load('assets/images/music-icon.png');
    final tempFile = File('${(await getTemporaryDirectory()).path}/music-icon.png');
    final file = await tempFile.writeAsBytes(
      byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)
    );
    final ImageDataClass audioImageDataClass = ImageDataClass(
      file.path, byteData.buffer.asUint8List()
    );
    if(mounted){
      StoreProvider.of<AppState>(context).dispatch(AudioImageDataClass(audioImageDataClass));
    }
  }

  void scan() async{
    if(mounted){
      widget.setLoadingState(false, LoadType.scan);
      runDelay(() async{
        await LocalDatabase().replaceAudioFavouritesData(fetchReduxDatabase().favouritesList).then((value) async{
          await LocalDatabase().replaceAudioPlaylistsData(fetchReduxDatabase().playlistList).then((value) async{
            await LocalDatabase().replaceAudioListenCountData(fetchReduxDatabase().audioListenCount).then((value) async{
              fetchLocalSongs(LoadType.scan);
            });
          });
        });
      }, actionDelayDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: StoreConnector<AppState, Map<String, AudioCompleteDataNotifier>>(
        converter: (store) => store.state.allAudiosList,
        builder: (context, Map<String, AudioCompleteDataNotifier> audiosListNotifiers){
          return Center(
            child: ListView(
              shrinkWrap: false,
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              primary: false,
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(height: getScreenHeight() * 0.015),
                    CustomButton(
                      width: getScreenWidth(), height: getScreenHeight() * 0.075, 
                      buttonColor: defaultCustomButtonColor, 
                      buttonText: 'Scan folder', 
                      onTapped: () => runDelay((){
                        if(mounted){
                          scan();
                        }
                      }, navigationDelayDuration), 
                      setBorderRadius: false
                    ),
                    SizedBox(height: getScreenHeight() * 0.015),
                    CustomButton(
                      width: getScreenWidth(), height: getScreenHeight() * 0.075, 
                      buttonColor: defaultCustomButtonColor, 
                      buttonText: 'Favourites', 
                      onTapped: () => runDelay((){
                        if(mounted){
                          Navigator.push(
                            context,
                            SliderRightToLeftRoute(
                              page: const DisplayFavouritesClassWidget()
                            )
                          );
                        }
                      }, navigationDelayDuration), 
                      setBorderRadius: false
                    ),
                    SizedBox(height: getScreenHeight() * 0.015),
                    CustomButton(
                      width: getScreenWidth(), height: getScreenHeight() * 0.075, 
                      buttonColor: defaultCustomButtonColor, 
                      buttonText: 'Most played', 
                      onTapped: () => runDelay((){
                        if(mounted){
                          Navigator.push(
                            context,
                            SliderRightToLeftRoute(
                              page: const DisplayMostPlayedClassWidget()
                            )
                          );
                        }
                      }, navigationDelayDuration),
                      setBorderRadius: false
                    ),
                    SizedBox(height: getScreenHeight() * 0.015),
                    CustomButton(
                      width: getScreenWidth(), height: getScreenHeight() * 0.075, 
                      buttonColor: defaultCustomButtonColor, 
                      buttonText: 'Recently added', 
                      onTapped: () => runDelay((){
                        if(mounted){
                          Navigator.push(
                            context,
                            SliderRightToLeftRoute(
                              page: DisplayRecentlyAddedClassWidget(recentlyAddedSongsData: recentlyAddedAudio,)
                            )
                          );
                        }
                      }, navigationDelayDuration),
                      setBorderRadius: false
                    ),
                    SizedBox(height: getScreenHeight() * 0.015),
                  ],
                ),
                SizedBox(height: getScreenHeight() * 0.015),
                ListView.builder(
                  shrinkWrap: true,
                  key: UniqueKey(),
                  scrollDirection: Axis.vertical,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: audioUrls.length,
                  itemBuilder: (context, index){
                    if(audiosListNotifiers[audioUrls[index]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: audiosListNotifiers[audioUrls[index]]!.notifier,
                      builder: (context, audioCompleteData, child){
                        return CustomAudioPlayerWidget(
                          audioCompleteData: audioCompleteData,
                          key: UniqueKey(),
                          directorySongsList: audioUrls,
                          playlistSongsData: null
                        );
                      }
                    );
                  }
                )
              ],
            )
          );
        }
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey())
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


