import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class DisplayRecentlyAddedClassWidget extends StatelessWidget {
  const DisplayRecentlyAddedClassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DisplayRecentlyAddedClassWidgetStateful();
  }
}

class _DisplayRecentlyAddedClassWidgetStateful extends StatefulWidget {
  const _DisplayRecentlyAddedClassWidgetStateful();

  @override
  State<_DisplayRecentlyAddedClassWidgetStateful> createState() => _DisplayRecentlyAddedClassWidgetState();
}

class _DisplayRecentlyAddedClassWidgetState extends State<_DisplayRecentlyAddedClassWidgetStateful> {
  late RecentlyAddedSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = RecentlyAddedSongsController(context);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('Recently added'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Center(
        child: Obx(() {
          List<AudioRecentlyAddedClass> songsList = controller.recentlyAddedSongsData;
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
              if(appStateRepo.allAudiosList[songsList[index].audioUrl] == null){
                return Container();
              }

              return Obx(() {
                final audioNotifier = appStateRepo.allAudiosList[songsList[index].audioUrl]!.notifier;

                return CustomAudioPlayerWidget(
                  audioCompleteData: audioNotifier.value,
                  key: UniqueKey(),
                  directorySongsList: songsList.map((e) => e.audioUrl).toList(),
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


