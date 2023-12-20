import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/global_library.dart';
import 'package:music_player_app/class/artist_songs_class.dart';
import 'package:music_player_app/class/audio_complete_data_class.dart';
import 'package:music_player_app/class/audio_complete_data_notifier.dart';
import 'package:music_player_app/class/audio_metadata_info_class.dart';
import 'package:music_player_app/custom/custom_artist_display.dart';
import 'package:music_player_app/custom/custom_currently_playing_bottom_widget.dart';
import 'package:music_player_app/redux/redux_library.dart';
import 'package:music_player_app/streams/delete_audio_data_stream_class.dart';
import 'package:music_player_app/streams/edit_audio_metadata_stream_class.dart';

class SortedArtistsPageWidget extends StatelessWidget {
  const SortedArtistsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SortedArtistsPageWidgetStateful();
  }
}


class _SortedArtistsPageWidgetStateful extends StatefulWidget {
  const _SortedArtistsPageWidgetStateful();

  @override
  State<_SortedArtistsPageWidgetStateful> createState() => _SortedArtistsPageWidgetState();
}

class _SortedArtistsPageWidgetState extends State<_SortedArtistsPageWidgetStateful> with AutomaticKeepAliveClientMixin{
  List<ArtistSongsClass> artistsSongsList = [];
  late StreamSubscription editAudioDataStreamClassSubscription;
  late StreamSubscription deleteAudioDataStreamClassSubscription;

  @override
  void initState(){
    super.initState();
    fetchLocalSongs();
    editAudioDataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass newAudioData = data.newAudioData;
        AudioCompleteDataClass oldAudioData = data.oldAudioData;
        String? newArtistName = newAudioData.audioMetadataInfo.artistName;
        String? oldArtistName = oldAudioData.audioMetadataInfo.artistName;
        if(newArtistName != oldArtistName){
          int findOldIndex = artistsSongsList.indexWhere((e) => e.artistName == oldArtistName);
          if(findOldIndex > -1){
            if(artistsSongsList[findOldIndex].songsList.length <= 1){
              artistsSongsList.removeAt(findOldIndex);
            }else{
              artistsSongsList[findOldIndex].songsList.remove(oldAudioData.audioUrl);
            }
          }
          int findNewIndex = artistsSongsList.indexWhere((e) => e.artistName == newArtistName);
          if(findNewIndex > -1){
            artistsSongsList[findNewIndex].songsList.add(newAudioData.audioUrl);
          }else{
            artistsSongsList.add(ArtistSongsClass(
              newArtistName, [newAudioData.audioUrl]
            ));
          }
          setState(() {});
        }
      }
    });
    deleteAudioDataStreamClassSubscription = DeleteAudioDataStreamClass().deleteAudioDataStream.listen((DeleteAudioDataStreamControllerClass data) {
      if(mounted){
        AudioCompleteDataClass audioData = data.audioData;
        for(int i = artistsSongsList.length - 1; i >= 0; i--){
          artistsSongsList[i].songsList.remove(audioData.audioUrl);
          if(artistsSongsList[i].songsList.isEmpty){
            artistsSongsList.removeAt(i);
          }
        }
        setState((){});
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
    List<ArtistSongsClass> artistsSongsListFetched = [];
    List<String?> artistsList = [];
    for(var songData in allSongs.values){
      if(await File(songData.audioID).exists()){
        AudioMetadataInfoClass metadataInfo = songData.notifier.value.audioMetadataInfo;
        if(artistsList.contains(metadataInfo.artistName)){
          artistsSongsListFetched[artistsList.indexOf(metadataInfo.artistName)].songsList.add(
            songData.audioID
          );
        }else{
          artistsList.add(metadataInfo.artistName);
          artistsSongsListFetched.add(
            ArtistSongsClass(
              metadataInfo.artistName, [songData.audioID]
            )
          );
        }
      }
    }
    artistsSongsList = artistsSongsListFetched;
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
              itemCount: artistsSongsList.length,
              itemBuilder: (context, index){
                return CustomArtistDisplayWidget(artistSongsData: artistsSongsList[index], key: UniqueKey());
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


