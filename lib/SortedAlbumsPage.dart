import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AlbumSongsClass.dart';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';
import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/class/AudioMetadataInfoClass.dart';
import 'package:music_player_app/custom/CustomAlbumDisplay.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/streams/DeleteAudioDataStreamClass.dart';
import 'package:music_player_app/streams/EditAudioMetadataStreamClass.dart';

class SortedAlbumsPageWidget extends StatelessWidget {
  const SortedAlbumsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SortedAlbumsPageWidgetStateful();
  }
}


class _SortedAlbumsPageWidgetStateful extends StatefulWidget {
  const _SortedAlbumsPageWidgetStateful();

  @override
  State<_SortedAlbumsPageWidgetStateful> createState() => _SortedAlbumsPageWidgetState();
}

class _SortedAlbumsPageWidgetState extends State<_SortedAlbumsPageWidgetStateful> with AutomaticKeepAliveClientMixin{
  List<AlbumSongsClass> albumsSongsList = [];
  late StreamSubscription editAudioDataStreamClassSubscription;
  late StreamSubscription deleteAudioDataStreamClassSubscription;
  
  @override
  void initState(){
    super.initState();
    fetchLocalSongs();
    editAudioDataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        fetchLocalSongs();
      }
    });
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass audioData = data.audioData;
        for(int i = 0; i < albumsSongsList.length; i++){
          albumsSongsList[i].songsList.remove(audioData.audioUrl);
        }
      }
    });
  }

  @override void dispose(){
    super.dispose();
    editAudioDataStreamClassSubscription.cancel();
    deleteAudioDataStreamClassSubscription.cancel();
  }
  
  void fetchLocalSongs() async{
    Map<String, AudioCompleteDataNotifier> allSongs = fetchReduxDatabase().allAudiosList;
    List<AlbumSongsClass> albumsSongsListFetched = [];
    for(var songData in allSongs.values){
      AudioMetadataInfoClass metadataInfo = songData.notifier.value.audioMetadataInfo;
      int albumIndex = albumsSongsListFetched.indexWhere((element){
        return element.albumName == metadataInfo.albumName && element.artistName == metadataInfo.albumArtistName;
      });
      if(albumIndex > -1){
        albumsSongsListFetched[albumIndex].songsList.add(
          songData.audioID
        );
      }else{
        albumsSongsListFetched.add(
          AlbumSongsClass(
            metadataInfo.albumName, metadataInfo.albumArtistName,
            metadataInfo.albumArt, [songData.audioID]
          )
        );
      }
    }
    albumsSongsList = albumsSongsListFetched;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
              itemCount: albumsSongsList.length,
              itemBuilder: (context, index){
                return CustomAlbumDisplayWidget(albumSongsData: albumsSongsList[index], key: UniqueKey());
              }
            )
          );
        }
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


