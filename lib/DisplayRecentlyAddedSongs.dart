import 'package:flutter/material.dart';
import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/AudioRecentlyAddedClass.dart';
import 'package:music_player_app/custom/CustomAudioPlayer.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/styles/AppStyles.dart';

class DisplayRecentlyAddedClassWidget extends StatelessWidget {
  final List<AudioRecentlyAddedClass> recentlyAddedSongsData;
  const DisplayRecentlyAddedClassWidget({super.key, required this.recentlyAddedSongsData});

  @override
  Widget build(BuildContext context) {
    return _DisplayRecentlyAddedClassWidgetStateful(recentlyAddedSongsData: recentlyAddedSongsData);
  }
}

class _DisplayRecentlyAddedClassWidgetStateful extends StatefulWidget {
  final List<AudioRecentlyAddedClass> recentlyAddedSongsData;
  const _DisplayRecentlyAddedClassWidgetStateful({required this.recentlyAddedSongsData});

  @override
  State<_DisplayRecentlyAddedClassWidgetStateful> createState() => _DisplayRecentlyAddedClassWidgetState();
}

class _DisplayRecentlyAddedClassWidgetState extends State<_DisplayRecentlyAddedClassWidgetStateful> {
  late List<AudioRecentlyAddedClass> recentlyAddedSongsData;

  @override
  void initState(){
    super.initState();
    recentlyAddedSongsData = widget.recentlyAddedSongsData;
  }

  @override
  void dispose(){
    super.dispose();
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


