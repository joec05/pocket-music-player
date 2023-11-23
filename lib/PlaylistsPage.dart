import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/custom/CustomPlaylistDisplay.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';

class PlaylistPageWidget extends StatelessWidget {
  const PlaylistPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlaylistPageWidgetStateful();
  }
}

class _PlaylistPageWidgetStateful extends StatefulWidget {
  const _PlaylistPageWidgetStateful();

  @override
  State<_PlaylistPageWidgetStateful> createState() => _PlaylistPageWidgetState();
}

class _PlaylistPageWidgetState extends State<_PlaylistPageWidgetStateful> with AutomaticKeepAliveClientMixin{
  ValueNotifier<List<PlaylistSongsClass>> playlistsSongsList = ValueNotifier([]);

  @override
  void initState(){
    super.initState();
    if(mounted){
      playlistsSongsList.value = fetchReduxDatabase().playlistList;
    }
  }

  @override void dispose(){
    super.dispose();
    playlistsSongsList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: StoreConnector<AppState, Map<String, AudioCompleteDataNotifier>>(
        converter: (store) => store.state.allAudiosList,
        builder: (context, Map<String, AudioCompleteDataNotifier> audiosListNotifiers){
          return StoreConnector<AppState, List<PlaylistSongsClass>>(
            converter: (store) => store.state.playlistList,
            builder: (context, List<PlaylistSongsClass> playlistsListValue){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if(mounted){
                  playlistsSongsList.value = [...playlistsListValue];
                }
              });
              return ValueListenableBuilder(
                valueListenable: playlistsSongsList,
                builder: (context, playlistsSongsListValue, child){
                  return Center(
                    child: ListView.builder(
                      shrinkWrap: false,
                      key: UniqueKey(),
                      scrollDirection: Axis.vertical,
                      primary: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: playlistsSongsListValue.length,
                      itemBuilder: (context, index){
                        return CustomPlaylistDisplayWidget(playlistSongsData: playlistsSongsListValue[index], key: UniqueKey());
                      }
                    ),
                  );
                }
              );
            }
          );
        }
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


