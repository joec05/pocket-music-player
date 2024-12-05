import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class AllSongsPageWidget extends StatelessWidget {
  const AllSongsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AllMusicPageWidgetStateful();
  }
}

class AllMusicPageWidgetStateful extends StatefulWidget {
  const AllMusicPageWidgetStateful({super.key});

  @override
  State<AllMusicPageWidgetStateful> createState() => AllMusicPageWidgetState();
}

class AllMusicPageWidgetState extends State<AllMusicPageWidgetStateful> with AutomaticKeepAliveClientMixin {
  late AllSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = AllSongsController(context);
    controller.initializeController();
  }

  @override void dispose(){
    super.dispose();
    controller.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: false,
          scrollDirection: Axis.vertical,
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2 , vertical: defaultVerticalPadding / 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomButton(
                            width: (getScreenWidth() - defaultHorizontalPadding) / 2 - defaultHorizontalPadding / 2, 
                            height: getScreenHeight() * 0.075, 
                            color: defaultCustomButtonColor, 
                            text: 'Scan folder', 
                            onTapped: () => runDelay((){
                              if(mounted){
                                controller.scan();
                              }
                            }, navigationDelayDuration), 
                            setBorderRadius: true,
                            prefix: null,
                            loading: false
                          ),
                          SizedBox(
                            width: defaultHorizontalPadding / 2
                          ),
                          CustomButton(
                            width: (getScreenWidth() - defaultHorizontalPadding) / 2 - defaultHorizontalPadding / 2, 
                            height: getScreenHeight() * 0.075, 
                            color: defaultCustomButtonColor, 
                            text: 'Favorites', 
                            onTapped: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DisplayFavoritesClassWidget())), 
                            setBorderRadius: true,
                            prefix: null,
                            loading: false
                          ),
                        ],
                      ),
                      SizedBox(height: getScreenHeight() * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomButton(
                            width: (getScreenWidth() - defaultHorizontalPadding) / 2 - defaultHorizontalPadding / 2, 
                            height: getScreenHeight() * 0.075, 
                            color: defaultCustomButtonColor, 
                            text: 'Most played', 
                            onTapped: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DisplayMostPlayedClassWidget())),
                            setBorderRadius: true,
                            prefix: null,
                            loading: false
                          ),
                          SizedBox(
                            width: defaultHorizontalPadding / 2
                          ),
                          CustomButton(
                            width: (getScreenWidth() - defaultHorizontalPadding) / 2 - defaultHorizontalPadding / 2, 
                            height: getScreenHeight() * 0.075, 
                            color: defaultCustomButtonColor, 
                            text: 'Recently added', 
                            onTapped: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DisplayRecentlyAddedClassWidget())),
                            setBorderRadius: true,
                            prefix: null,
                            loading: false
                          ),
                        ],
                      )
                    ]
                  )
                )
              ],
            ),
            SizedBox(height: getScreenHeight() * 0.0075),
            const Divider(color: Colors.grey, height: 3.5),
            SizedBox(height: getScreenHeight() * 0.0075),
            Obx(() {
              if(mainPageController.isLoaded.isFalse && mainPageController.loadType.value == LoadType.initial) {
                return Container();
              }

              final searchedText = mainPageController.searchedText.trim().toLowerCase();
              List<String> audioUrls = appStateRepo.allAudiosList.keys.where((e) {
                if(appStateRepo.allAudiosList[e] == null) {
                  return false;
                }

                final AudioCompleteDataClass data = appStateRepo.allAudiosList[e]!.notifier.value;
                final AudioMetadataInfoClass metadata = data.audioMetadataInfo;
                final String fileName = metadata.fileName.toLowerCase();
                final String title = metadata.title?.toLowerCase() ?? '';
                final String artist = metadata.artistName?.toLowerCase() ?? '';
                if(fileName.contains(searchedText) || title.contains(searchedText) || artist.contains(searchedText)) {
                  return true;
                }
                return false;
              }).toList();
              return Center(
                child: audioUrls.isEmpty ? SizedBox(height: getScreenHeight() * 0.55, child: noItemsWidget(FontAwesomeIcons.music, 'songs'))
              :
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: audioUrls.length,
                  itemBuilder: (context, index){
                    if(appStateRepo.allAudiosList[audioUrls[index]] == null){
                      return Container();
                    }
                    
                    return Obx(() {
                      final audioNotifier = appStateRepo.allAudiosList[audioUrls[index]];

                      return CustomAudioPlayerWidget(
                        audioCompleteData: audioNotifier!.notifier.value,
                        key: UniqueKey(),
                        directorySongsList: appStateRepo.allAudiosList.keys.toList(),
                        playlistSongsData: null
                      );
                    });
                  }
                )
              );
            })
          ],
        )
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey())
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


