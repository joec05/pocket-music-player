import 'package:flutter/material.dart';
import 'package:music_player_app/class/ArtistSongsClass.dart';
import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/custom/CustomAudioPlayer.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/styles/AppStyles.dart';

class DisplayArtistSongsWidget extends StatelessWidget {
  final ArtistSongsClass artistSongsData;
  const DisplayArtistSongsWidget({super.key, required this.artistSongsData});

  @override
  Widget build(BuildContext context) {
    return _DisplayArtistSongsWidgetStateful(artistSongsData: artistSongsData);
  }
}

class _DisplayArtistSongsWidgetStateful extends StatefulWidget {
  final ArtistSongsClass artistSongsData;
  const _DisplayArtistSongsWidgetStateful({required this.artistSongsData});

  @override
  State<_DisplayArtistSongsWidgetStateful> createState() => _DisplayArtistSongsWidgetState();
}

class _DisplayArtistSongsWidgetState extends State<_DisplayArtistSongsWidgetStateful> {
  late ArtistSongsClass artistSongsData;

  @override
  void initState(){
    super.initState();
    artistSongsData = widget.artistSongsData;
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
        title: Text(artistSongsData.artistName ?? 'Unknown'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
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
              itemCount: artistSongsData.songsList.length,
              itemBuilder: (context, index){
                if(audiosListNotifiers[artistSongsData.songsList[index]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: audiosListNotifiers[artistSongsData.songsList[index]]!.notifier, 
                  builder: (context, audioCompleteData, child){
                    return CustomAudioPlayerWidget(
                      audioCompleteData: audioCompleteData,
                      key: UniqueKey(),
                      directorySongsList: artistSongsData.songsList,
                      playlistSongsData: null
                    );
                  }
                );
              },
            )
          );
        }
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


