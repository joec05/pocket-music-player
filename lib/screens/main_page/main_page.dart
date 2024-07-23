import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';
import 'package:bottom_bar/bottom_bar.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MainPageWidgetStateful();
  }
}

class _MainPageWidgetStateful extends StatefulWidget {
  const _MainPageWidgetStateful();

  @override
  State<_MainPageWidgetStateful> createState() => __MainPageWidgetStatefulState();
}

class __MainPageWidgetStatefulState extends State<_MainPageWidgetStateful>{

  @override void initState(){
    super.initState();
    mainPageController.initializeController();
  }

  @override void dispose(){
    super.dispose();
    mainPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int selectedIndexValue = mainPageController.selectedIndexValue.value;
      List<Widget> widgetOptions = mainPageController.widgetOptions;
      bool isLoaded = mainPageController.isLoaded.value;
      bool isSearching = mainPageController.isSearching.value;
      return PopScope(
        canPop: !isSearching,
        onPopInvoked: (bool pop) {
          if(isSearching) {
            mainPageController.isSearching.value = false;
            mainPageController.searchController.text = '';
          }
        },
        child: Scaffold(
          appBar: mainPageController.setAppBar(selectedIndexValue),
          body: Stack(
            children: [
              Scaffold(
                key: mainPageController.scaffoldKey,
                body: PageView(
                  controller: mainPageController.pageController,
                  onPageChanged: mainPageController.onPageChanged,
                  children: widgetOptions,
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    boxShadow: [                                                               
                      BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0, blurRadius: 10),
                    ],
                  ),
                  child: SizedBox(
                    child: BottomBar(
                      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                      key: UniqueKey(),
                      items: [
                        BottomBarItem(
                          icon: const Icon(FontAwesomeIcons.music, size: 25),
                          title: const Text('All Music'),
                          activeColor: Colors.teal.withOpacity(0.7)
                        ),
                        BottomBarItem(
                          icon: const Icon(FontAwesomeIcons.user, size: 25),
                          title: const Text('Artists'),
                          activeColor: Colors.teal.withOpacity(0.7)
                        ),
                        BottomBarItem(
                          icon: const Icon(FontAwesomeIcons.recordVinyl, size: 25),
                          title: const Text('Albums'),
                          activeColor: Colors.teal.withOpacity(0.7)
                        ),
                        BottomBarItem(
                          icon: const Icon(FontAwesomeIcons.list, size: 25),
                          title: const Text('Playlists'),
                          activeColor: Colors.teal.withOpacity(0.7)
                        ),
                      ],
                      selectedIndex: selectedIndexValue,
                      onTap: ((index) {
                        if(mounted){
                          if(mainPageController.isLoaded.value){
                            mainPageController.pageController.jumpToPage(index);
                          }
                        }
                      })
                    ),
                  )
                ),
              ),
              !isLoaded ? 
                Container(
                  key: UniqueKey(),
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 15),
                            Text('Scanning'),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container()
            ]
          )
        ),
      );
    });
  }
}
