import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player_app/AllMusicPage.dart';
import 'package:music_player_app/PlaylistsPage.dart';
import 'package:music_player_app/SortedAlbumsPage.dart';
import 'package:music_player_app/SortedArtistsPage.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'styles/AppStyles.dart';
import 'package:flutter/services.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:path_provider/path_provider.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'dart:io';

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
  ValueNotifier<int> selectedIndexValue = ValueNotifier(0);
  final PageController _pageController = PageController(initialPage: 0, keepPage: true);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> isLoaded = ValueNotifier(false);
  List<Widget> widgetOptions = <Widget>[];
  ValueNotifier<LoadType> loadType = ValueNotifier(LoadType.initial);

  @override void initState(){
    super.initState();
    initializeDefaultStartingDisplayImage();
  }

  @override void dispose(){
    super.dispose();
    selectedIndexValue.dispose();
    _pageController.dispose();
    isLoaded.dispose();
    loadType.dispose();
  }

  void setLoadingState(bool state, LoadType loadingType){
    if(mounted){
      isLoaded.value = state;
      loadType.value = loadingType;
    }
  }

  void onPageChanged(newIndex){
    if(mounted){
      if(isLoaded.value){
        selectedIndexValue.value = newIndex;
      }
    }
  }

  Future<void> initializeDefaultStartingDisplayImage() async{
    ByteData byteData = await rootBundle.load('assets/images/music-icon.png');
    final tempFile = File('${(await getTemporaryDirectory()).path}/music-icon.png');
    final file = await tempFile.writeAsBytes(
      byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)
    );
    final ImageDataClass audioImageDataClass = ImageDataClass(
      file.path, byteData.buffer.asUint8List()
    );
    if(mounted){
      StoreProvider.of<AppState>(context).dispatch(AudioImageDataClass(audioImageDataClass));
      widgetOptions = [
        AllMusicPageWidget(setLoadingState: setLoadingState), const SortedArtistsPageWidget(), const SortedAlbumsPageWidget(), const PlaylistPageWidget()
      ];
    }
  }

  PreferredSizeWidget setAppBar(index){
    if(index == 0){
      return AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('All Music'), titleSpacing: defaultAppBarTitleSpacingWithoutBackBtn,
      );
    }else if(index == 1){
      return AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('Artists'), titleSpacing: defaultAppBarTitleSpacingWithoutBackBtn,
      );
    }else if(index == 2){
      return AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('Albums'), titleSpacing: defaultAppBarTitleSpacingWithoutBackBtn,
      );
    }else if(index == 3){
      return AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('Playlists'), titleSpacing: defaultAppBarTitleSpacingWithoutBackBtn,
      );
    }
    return AppBar();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ImageDataClass?>(
      converter: (store) => store.state.audioImageDataClass,
      builder: (context, ImageDataClass? imageDataClass){
        return Stack(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: selectedIndexValue,
              builder: (BuildContext context, int selectedIndexValue, Widget? child) {
                return Scaffold(
                  key: scaffoldKey,
                  drawerEdgeDragWidth: 0.85 * getScreenWidth(),
                  onDrawerChanged: (isOpened) {
                    if(isOpened){
                    }
                  },
                  body: PageView(
                    controller: _pageController,
                    onPageChanged: onPageChanged,
                    children: widgetOptions,
                  ),
                  bottomNavigationBar: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [                                                               
                        BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                      ],
                    ),
                    child: SizedBox(
                    width: 0.7 * getScreenWidth(),
                    child: BottomNavigationBar(
                      selectedFontSize: 13,
                      unselectedFontSize: 13,
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
                          if(isLoaded.value){
                            _pageController.jumpToPage(index);
                          }
                        }
                      })
                    ),
                    )
                  ),
                );
              }
            ),
            ValueListenableBuilder(
              valueListenable: isLoaded,
              builder: (context, isLoaded, child){
                if(!isLoaded){
                  return ValueListenableBuilder(
                    valueListenable: loadType,
                    builder: (context, loadType, child){
                      if(loadType == LoadType.initial){
                        return Container(
                          decoration: defaultInitialScreenDecoration,
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: imageDataClass != null ? Image.memory(imageDataClass.bytes, width: getScreenWidth() * 0.325, height: getScreenWidth() * 0.325) : Container()
                          )
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator()
                      );
                    }
                  );
                }
                return Container();
              }
            )
          ]
        );
      }
    );
  }
}
