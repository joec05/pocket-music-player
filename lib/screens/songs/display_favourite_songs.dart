import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

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
        child: Obx(() {
          List<FavouriteSongModel> songsList = controller.favouriteSongsData;
          if(songsList.isEmpty) {
            return noItemsWidget(FontAwesomeIcons.music, 'songs');
          }
          return ListView.builder(
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: songsList.length,
            itemBuilder: (context, index){
              if(audiosListNotifiers[songsList[index].songPath] == null){
                return Container();
              }

              return Obx(() {
                final audioNotifier = audiosListNotifiers[songsList[index].songPath]!.notifier;
                
                return CustomAudioPlayerWidget(
                  audioCompleteData: audioNotifier.value,
                  key: UniqueKey(),
                  directorySongsList: songsList.map((e) => e.songPath).toList(),
                  playlistSongsData: null
                );
              });
            }
          );
        })
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


