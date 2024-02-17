import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

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
  late FavouriteSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = FavouriteSongsController(context);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, AudioCompleteDataNotifier> audiosListNotifiers = appStateRepo.allAudiosList;
    
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('Favourites'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: controller.favouriteSongsData,
          builder: (context, songsList, child){
            return ListView.builder(
              shrinkWrap: false,
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              primary: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: songsList.length,
              itemBuilder: (context, index){
                if(audiosListNotifiers[songsList[index]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: audiosListNotifiers[songsList[index]]!.notifier, 
                  builder: (context, audioCompleteData, child){
                    return CustomAudioPlayerWidget(
                      audioCompleteData: audioCompleteData,
                      key: UniqueKey(),
                      directorySongsList: songsList,
                      playlistSongsData: null
                    );
                  }
                );
              }
            );
          }
        )
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


