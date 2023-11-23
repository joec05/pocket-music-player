import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/AudioListenCountClass.dart';
import 'package:music_player_app/class/AudioListenCountNotifier.dart';
import 'package:music_player_app/custom/CustomAudioPlayer.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/styles/AppStyles.dart';

class DisplayMostPlayedClassWidget extends StatelessWidget {
  const DisplayMostPlayedClassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DisplayMostPlayedClassWidgetStateful();
  }
}

class _DisplayMostPlayedClassWidgetStateful extends StatefulWidget {
  const _DisplayMostPlayedClassWidgetStateful();

  @override
  State<_DisplayMostPlayedClassWidgetStateful> createState() => _DisplayMostPlayedClassWidgetState();
}

class _DisplayMostPlayedClassWidgetState extends State<_DisplayMostPlayedClassWidgetStateful> {
  List<AudioListenCountClass> mostPlayedSongsData = [];

  @override
  void initState(){
    super.initState();
    fetchLocalSongs();
  }

  void fetchLocalSongs() async{
    if(mounted){
      Map<String, AudioListenCountNotifier> listenCountHistory = fetchReduxDatabase().audioListenCount;
      List<AudioListenCountNotifier> values = listenCountHistory.values.toList();
      values.sort((a, b) => b.notifier.value.listenCount.compareTo(a.notifier.value.listenCount));
      mostPlayedSongsData = values.map((e) => e.notifier.value).toList();
      setState((){});
    }
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
        title: const Text('Most played'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
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
              itemCount: mostPlayedSongsData.length,
              itemBuilder: (context, index){
                if(audiosListNotifiers[mostPlayedSongsData[index].audioUrl] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: audiosListNotifiers[mostPlayedSongsData[index].audioUrl]!.notifier, 
                  builder: (context, audioCompleteData, child){
                    return CustomAudioPlayerWidget(
                      audioCompleteData: audioCompleteData,
                      key: UniqueKey(),
                      directorySongsList: mostPlayedSongsData.map((e) => e.audioUrl).toList(),
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


