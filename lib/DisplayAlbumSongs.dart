import 'package:flutter/material.dart';
import 'package:music_player_app/class/AlbumSongsClass.dart';
import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/custom/CustomAudioPlayer.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/styles/AppStyles.dart';

class DisplayAlbumSongsWidget extends StatelessWidget {
  final AlbumSongsClass albumSongsData;
  const DisplayAlbumSongsWidget({super.key, required this.albumSongsData});

  @override
  Widget build(BuildContext context) {
    return _DisplayAlbumSongsWidgetStateful(albumSongsData: albumSongsData);
  }
}

class _DisplayAlbumSongsWidgetStateful extends StatefulWidget {
  final AlbumSongsClass albumSongsData;
  const _DisplayAlbumSongsWidgetStateful({required this.albumSongsData});

  @override
  State<_DisplayAlbumSongsWidgetStateful> createState() => _DisplayAlbumSongsWidgetState();
}

class _DisplayAlbumSongsWidgetState extends State<_DisplayAlbumSongsWidgetStateful> {
  late AlbumSongsClass albumSongsData;

  @override
  void initState(){
    super.initState();
    albumSongsData = widget.albumSongsData;
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
        title: Text(albumSongsData.albumName ?? 'Unknown'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
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
              itemCount: albumSongsData.songsList.length,
              itemBuilder: (context, index){
                if(audiosListNotifiers[albumSongsData.songsList[index]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: audiosListNotifiers[albumSongsData.songsList[index]]!.notifier, 
                  builder: (context, audioCompleteData, child){
                    return CustomAudioPlayerWidget(
                      audioCompleteData: audioCompleteData,
                      key: UniqueKey(),
                      directorySongsList: albumSongsData.songsList,
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


