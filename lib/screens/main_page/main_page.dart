import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

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
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      selectedFontSize: 13,
                      unselectedFontSize: 13,
                      showUnselectedLabels: true,
                      selectedItemColor: Colors.red,
                      unselectedItemColor: const Color.fromARGB(255, 110, 102, 102),
                      key: UniqueKey(),
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.music, size: 25),
                          label: 'All Music',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.user, size: 25),
                          label: 'Artists',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.recordVinyl, size: 25),
                          label: 'Albums',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.list, size: 25),
                          label: 'Playlists',
                        ),
                      ],
                      currentIndex: selectedIndexValue,
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
                          color: Colors.transparent.withOpacity(0.75),
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
