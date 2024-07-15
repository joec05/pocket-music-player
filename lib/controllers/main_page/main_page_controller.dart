import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';
import 'package:pocket_music_player/screens/settings/settings_page.dart';

class MainPageController {
  RxInt selectedIndexValue = 0.obs;
  final PageController pageController = PageController(initialPage: 0, keepPage: true);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isLoaded = false.obs;
  Rx<LoadType> loadType = LoadType.initial.obs;
  RxBool isSearching = false.obs;
  List<Widget> widgetOptions = List<Widget>.from([]).obs;
  RxString searchedText = ''.obs;
  TextEditingController searchController = TextEditingController();

  MainPageController();

  void initializeController() async {
    widgetOptions = [
      const AllSongsPageWidget(), 
      const SortedArtistsPageWidget(), 
      const SortedAlbumsPageWidget(), 
      const PlaylistPageWidget()
    ];
    searchController.addListener(() {
      searchedText.value = searchController.text;
    });
  }

  void dispose(){
    pageController.dispose();
  }

  void setLoadingState(bool state, LoadType loadingType){
    isLoaded.value = state;
    loadType.value = loadingType;
  }

  void onPageChanged(newIndex){
    if(isLoaded.value){
      selectedIndexValue.value = newIndex;
    }
  }

  PreferredSizeWidget setAppBar(index){
    String text = 'Pocket Music Player';

    return AppBar(
      flexibleSpace: Container(
        decoration: defaultAppBarDecoration
      ),
      title: Obx(() {
        if(isSearching.value) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  isSearching.value = false;
                  searchController.text = '';
                },
                child: const Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Icon(Icons.arrow_back, size: 25),
                )
              ),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: EdgeInsets.symmetric(horizontal: getScreenWidth() * 0.025),
                  fillColor: Colors.transparent,
                  filled: true,
                  hintText: 'Search anything',
                  constraints: BoxConstraints(
                    maxWidth: getScreenWidth() * 0.75,
                    maxHeight: getScreenHeight() * 0.07,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                )
              )
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    isSearching.value = true;
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Icon(FontAwesomeIcons.magnifyingGlass, size: 20),
                  )
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () => Get.to(const SettingsPage()),
                  child: const Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Icon(FontAwesomeIcons.gear, size: 20),
                  )
                ),
              ],
            )
          ],
        );
      }),
      titleSpacing: defaultAppBarTitleSpacingWithoutBackBtn,
    );
  }
}

final mainPageController = MainPageController();