import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AudioCompleteDataNotifier.dart';
import 'package:music_player_app/custom/CustomAudioPlayer.dart';
import 'package:music_player_app/custom/CustomCurrentlyPlayingBottomWidget.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/styles/AppStyles.dart';

class DisplayFavouritesClassWidget extends StatelessWidget {
  const DisplayFavouritesClassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DisplayFavouritesClassWidgetStateful();
  }
}


class _DisplayFavouritesClassWidgetStateful extends StatefulWidget {
  const _DisplayFavouritesClassWidgetStateful();

  @override
  State<_DisplayFavouritesClassWidgetStateful> createState() => _DisplayFavouritesClassWidgetState();
}

class _DisplayFavouritesClassWidgetState extends State<_DisplayFavouritesClassWidgetStateful> {
  late List<String> favouriteSongsData;

  @override
  void initState(){
    super.initState();
    favouriteSongsData = fetchReduxDatabase().favouritesList;
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
        title: const Text('Favourites'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: StoreConnector<AppState, Map<String, AudioCompleteDataNotifier>>(
        converter: (store) => store.state.allAudiosList,
        builder: (context, Map<String, AudioCompleteDataNotifier> audiosListNotifiers){
          return StoreConnector<AppState, List<String>>(
            converter: (store) => store.state.favouritesList,
            builder: (context, List<String> favouritesListValue){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                favouriteSongsData = favouritesListValue;
              });
              return Center(
                child: ListView.builder(
                  shrinkWrap: false,
                  key: UniqueKey(),
                  scrollDirection: Axis.vertical,
                  primary: false,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: favouriteSongsData.length,
                  itemBuilder: (context, index){
                    if(audiosListNotifiers[favouriteSongsData[index]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: audiosListNotifiers[favouriteSongsData[index]]!.notifier, 
                      builder: (context, audioCompleteData, child){
                        return CustomAudioPlayerWidget(
                          audioCompleteData: audioCompleteData,
                          key: UniqueKey(),
                          directorySongsList: favouriteSongsData,
                          playlistSongsData: null
                        );
                      }
                    );
                  }
                )
              );
            }
          );
        }
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


