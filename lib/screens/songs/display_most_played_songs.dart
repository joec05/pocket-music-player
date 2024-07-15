import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class DisplayMostPlayedClassWidget extends StatelessWidget {
  const DisplayMostPlayedClassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DisplayMostPlayedClassWidgetStateful();
  }
}

class _DisplayMostPlayedClassWidgetStateful extends StatefulWidget {
  const _DisplayMostPlayedClassWidgetStateful();

  @override
  State<_DisplayMostPlayedClassWidgetStateful> createState() => _DisplayMostPlayedClassWidgetState();
}

class _DisplayMostPlayedClassWidgetState extends State<_DisplayMostPlayedClassWidgetStateful> {
  late MostPlayedSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = MostPlayedSongsController(context);
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
        title: const Text('Most played'), titleSpacing: defaultAppBarTitleSpacingWithBackBtn,
      ),
      body: Center(
        child: Obx(() {
          List<AudioListenCountModel> songsList = controller.mostPlayedSongsData;
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
            });
          }
        )
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
}


