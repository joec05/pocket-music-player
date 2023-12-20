import 'package:flutter/material.dart';
import 'package:music_player_app/class/artist_songs_class.dart';
import 'package:music_player_app/class/audio_complete_data_notifier.dart';
import 'package:music_player_app/custom/custom_audio_player.dart';
import 'package:music_player_app/custom/custom_currently_playing_bottom_widget.dart';
import 'package:music_player_app/redux/redux_library.dart';
import 'package:music_player_app/styles/app_styles.dart';

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
                    if(audioCompleteData.audioMetadataInfo.artistName == artistSongsData.artistName){
                      return CustomAudioPlayerWidget(
                        audioCompleteData: audioCompleteData,
                        key: UniqueKey(),
                        directorySongsList: artistSongsData.songsList,
                        playlistSongsData: null
                      );
                    }
                    return Container();
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


