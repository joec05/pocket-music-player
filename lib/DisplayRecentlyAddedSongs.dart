import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalFunctions.dart';
import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/AudioRecentlyAddedClass.dart';
import 'package:music_player_app/custom/CustomAudioPlayer.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/streams/EditAudioMetadataStreamClass.dart';
import 'package:music_player_app/styles/AppStyles.dart';

class DisplayRecentlyAddedClassWidget extends StatelessWidget {
  const DisplayRecentlyAddedClassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DisplayRecentlyAddedClassWidgetStateful();
  }
}

class _DisplayRecentlyAddedClassWidgetStateful extends StatefulWidget {
  const _DisplayRecentlyAddedClassWidgetStateful();

  @override
  State<_DisplayRecentlyAddedClassWidgetStateful> createState() => _DisplayRecentlyAddedClassWidgetState();
}

class _DisplayRecentlyAddedClassWidgetState extends State<_DisplayRecentlyAddedClassWidgetStateful> {
  List<AudioRecentlyAddedClass> recentlyAddedSongsData = [];
  late StreamSubscription editAudioMetadataStreamClassSubscription;

  @override
  void initState(){
    super.initState();
    fetchRecentlyAddedSongs();
    editAudioMetadataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        String updatedAudioUrl = data.newAudioData.audioUrl;
        int index = recentlyAddedSongsData.indexWhere((e) => e.audioUrl == updatedAudioUrl);
        if(index > -1){
          recentlyAddedSongsData.removeAt(index);
        }else{
          recentlyAddedSongsData.removeLast();
        }
        recentlyAddedSongsData.insert(0, AudioRecentlyAddedClass(updatedAudioUrl, DateTime.now().toIso8601String()));
        setState((){});
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    editAudioMetadataStreamClassSubscription.cancel();
  }

  Future<void> fetchRecentlyAddedSongs() async{
    List<String> allAudioUrl = fetchReduxDatabase().allAudiosList.values.map((e) => e.audioID).toList();
    var statResults = await Future.wait([
      for(var path in allAudioUrl) FileStat.stat(path)
    ]);
    for(int i = 0; i < allAudioUrl.length; i++){
      recentlyAddedSongsData.add(
        AudioRecentlyAddedClass(allAudioUrl[i], statResults[i].changed.toIso8601String())
      );
    }
    recentlyAddedSongsData.sort((a, b) => b.modifiedDate.compareTo(a.modifiedDate));
    recentlyAddedSongsData = recentlyAddedSongsData.sublist(0, min(recentlyAddedSongsData.length, 15)); 
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('Recently added'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: StoreConnector<AppState, Map<String, AudioCompleteDataNotifier>>(
        converter: (store) => store.state.allAudiosList,
        builder: (context, Map<String, AudioCompleteDataNotifier> audiosListNotifiers){
          return Center(
            child: ListView.builder(
              shrinkWrap: false,
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              primary: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: recentlyAddedSongsData.length,
              itemBuilder: (context, index){
                if(audiosListNotifiers[recentlyAddedSongsData[index].audioUrl] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: audiosListNotifiers[recentlyAddedSongsData[index].audioUrl]!.notifier, 
                  builder: (context, audioCompleteData, child){
                    return CustomAudioPlayerWidget(
                      audioCompleteData: audioCompleteData,
                      key: UniqueKey(),
                      directorySongsList: recentlyAddedSongsData.map((e) => e.audioUrl).toList(),
                      playlistSongsData: null
                    );
                  }
                );
              }
            )
          );
        }
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


