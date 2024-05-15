import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class AllSongsPageWidget extends StatelessWidget {
  final Function(bool, LoadType) setLoadingState;
  const AllSongsPageWidget({super.key, required this.setLoadingState});

  @override
  Widget build(BuildContext context) {
    return AllMusicPageWidgetStateful(setLoadingState: setLoadingState);
  }
}

class AllMusicPageWidgetStateful extends StatefulWidget {
  final Function(bool, LoadType) setLoadingState;
  const AllMusicPageWidgetStateful({required this.setLoadingState});

  @override
  State<AllMusicPageWidgetStateful> createState() => AllMusicPageWidgetState();
}

class AllMusicPageWidgetState extends State<AllMusicPageWidgetStateful> with AutomaticKeepAliveClientMixin {
  late AllSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = AllSongsController(context, widget.setLoadingState);
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
                  margin: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding /2 , vertical: defaultVerticalPadding / 2),
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
                            text: 'Favourites', 
                            onTapped: () => Get.to(const DisplayFavouritesClassWidget()), 
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
                            onTapped: () => Get.to(const DisplayMostPlayedClassWidget()),
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
                            onTapped: () => Get.to(const DisplayRecentlyAddedClassWidget()),
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
              List<String> audioUrls = controller.audioUrls;
              
              if(audioUrls.isEmpty) {
                return noItemsWidget(FontAwesomeIcons.music, 'songs');
              }
              return ListView.builder(
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
                      directorySongsList: audioUrls,
                      playlistSongsData: null
                    );
                  });
                }
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


