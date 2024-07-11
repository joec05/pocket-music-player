import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class MainPageController {
  RxInt selectedIndexValue = 0.obs;
  final PageController pageController = PageController(initialPage: 0, keepPage: true);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isLoaded = false.obs;
  Rx<LoadType> loadType = LoadType.initial.obs;
  Rx<bool> isSearching = false.obs;
  List<Widget> widgetOptions = List<Widget>.from([]).obs;
  Rx<String> searchedText = ''.obs;
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
    String text = '';
    if(index == 0){
      text = 'All Music';
    }else if(index == 1){
      text = 'Artists';
    }else if(index == 2){
      text = 'Albums';
    }else if(index == 3){
      text = 'Playlists';
    }

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
                child: const Icon(Icons.arrow_back, size: 20)
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
            InkWell(
              onTap: () {
                isSearching.value = true;
              },
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(FontAwesomeIcons.magnifyingGlass, size: 20),
              )
            )
          ],
        );
      }),
      titleSpacing: defaultAppBarTitleSpacingWithoutBackBtn,
    );
  }
}

final mainPageController = MainPageController();