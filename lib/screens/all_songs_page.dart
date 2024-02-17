import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

class AllSongsPageWidget extends StatelessWidget {
  final Function(bool, LoadType) setLoadingState;
  const AllSongsPageWidget({super.key, required this.setLoadingState});

  @override
  Widget build(BuildContext context) {
    return _AllMusicPageWidgetStateful(setLoadingState: setLoadingState);
  }
}

class _AllMusicPageWidgetStateful extends StatefulWidget {
  final Function(bool, LoadType) setLoadingState;
  const _AllMusicPageWidgetStateful({required this.setLoadingState});

  @override
  State<_AllMusicPageWidgetStateful> createState() => _AllMusicPageWidgetState();
}

class _AllMusicPageWidgetState extends State<_AllMusicPageWidgetStateful> with AutomaticKeepAliveClientMixin{
  late AllSongsController controller;

  @override
  void initState(){
    super.initState();
    controller = AllSongsController(context, widget.setLoadingState);
    controller.initializeController();
    widget.setLoadingState(true, LoadType.initial);
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
          key: UniqueKey(),
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
                            buttonColor: defaultCustomButtonColor, 
                            buttonText: 'Scan folder', 
                            onTapped: () => runDelay((){
                              if(mounted){
                                controller.scan();
                              }
                            }, navigationDelayDuration), 
                            setBorderRadius: true
                          ),
                          SizedBox(
                            width: defaultHorizontalPadding / 2
                          ),
                          CustomButton(
                            width: (getScreenWidth() - defaultHorizontalPadding) / 2 - defaultHorizontalPadding / 2, 
                            height: getScreenHeight() * 0.075, 
                            buttonColor: defaultCustomButtonColor, 
                            buttonText: 'Favourites', 
                            onTapped: () => runDelay((){
                              if(mounted){
                                Navigator.push(
                                  context,
                                  SliderRightToLeftRoute(
                                    page: const DisplayFavouritesClassWidget()
                                  )
                                );
                              }
                            }, navigationDelayDuration), 
                            setBorderRadius: true
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
                            buttonColor: defaultCustomButtonColor, 
                            buttonText: 'Most played', 
                            onTapped: () => runDelay((){
                              if(mounted){
                                Navigator.push(
                                  context,
                                  SliderRightToLeftRoute(
                                    page: const DisplayMostPlayedClassWidget()
                                  )
                                );
                              }
                            }, navigationDelayDuration),
                            setBorderRadius: true
                          ),
                          SizedBox(
                            width: defaultHorizontalPadding / 2
                          ),
                          CustomButton(
                            width: (getScreenWidth() - defaultHorizontalPadding) / 2 - defaultHorizontalPadding / 2, 
                            height: getScreenHeight() * 0.075, 
                            buttonColor: defaultCustomButtonColor, 
                            buttonText: 'Recently added', 
                            onTapped: () => runDelay((){
                              if(mounted){
                                Navigator.push(
                                  context,
                                  SliderRightToLeftRoute(
                                    page: const DisplayRecentlyAddedClassWidget()
                                  )
                                );
                              }
                            }, navigationDelayDuration),
                            setBorderRadius: true
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
            ValueListenableBuilder(
              valueListenable: controller.audioUrls,
              builder: (context, audioUrls, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  key: UniqueKey(),
                  scrollDirection: Axis.vertical,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: audioUrls.length,
                  itemBuilder: (context, index){
                    if(appStateRepo.allAudiosList[audioUrls[index]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.allAudiosList[audioUrls[index]]!.notifier,
                      builder: (context, audioCompleteData, child){
                        return CustomAudioPlayerWidget(
                          audioCompleteData: audioCompleteData,
                          key: UniqueKey(),
                          directorySongsList: audioUrls,
                          playlistSongsData: null
                        );
                      }
                    );
                  }
                );
              }
            )
          ],
        )
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey())
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


