import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class SortedArtistsPageWidget extends StatelessWidget {
  const SortedArtistsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SortedArtistsPageWidgetStateful();
  }
}

class _SortedArtistsPageWidgetStateful extends StatefulWidget {
  const _SortedArtistsPageWidgetStateful();

  @override
  State<_SortedArtistsPageWidgetStateful> createState() => _SortedArtistsPageWidgetState();
}

class _SortedArtistsPageWidgetState extends State<_SortedArtistsPageWidgetStateful> with AutomaticKeepAliveClientMixin {
  late SortedArtistsController controller;

  @override
  void initState(){
    super.initState();
    controller = SortedArtistsController(context);
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
        child: Obx(() {
          final searchedText = mainPageController.searchedText.trim().toLowerCase();
          List<ArtistSongsClass> artistsSongsList = controller.artistsSongsList.where((e) {
            final String artist = e.artistName?.toLowerCase() ?? '';
            if(artist.contains(searchedText)) {
              return true;
            }
            return false;
          }).toList();
          LoadingStatus status = controller.status.value;

          if(status == LoadingStatus.loading) {
            return const CircularProgressIndicator();
          }

          if(artistsSongsList.isEmpty) {
            return noItemsWidget(FontAwesomeIcons.user, 'artists');
          }

          return ListView.builder(
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: artistsSongsList.length,
            itemBuilder: (context, index){
              return CustomArtistDisplayWidget(
                artistSongsData: artistsSongsList[index], 
                key: UniqueKey()
              );
            }
          );
        })
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


