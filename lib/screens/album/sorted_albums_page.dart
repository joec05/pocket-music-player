import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

class SortedAlbumsPageWidget extends StatelessWidget {
  const SortedAlbumsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SortedAlbumsPageWidgetStateful();
  }
}

class _SortedAlbumsPageWidgetStateful extends StatefulWidget {
  const _SortedAlbumsPageWidgetStateful();

  @override
  State<_SortedAlbumsPageWidgetStateful> createState() => _SortedAlbumsPageWidgetState();
}

class _SortedAlbumsPageWidgetState extends State<_SortedAlbumsPageWidgetStateful> with AutomaticKeepAliveClientMixin{
  
  @override
  void initState(){
    super.initState();
    sortedAlbumsController.initializeController();
  }

  @override void dispose() {
    super.dispose();
    sortedAlbumsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: Obx(() {
          final searchedText = mainPageController.searchedText.trim().toLowerCase();
          List<AlbumSongsClass> albumsSongsList = sortedAlbumsController.albumsSongsList.where((e) {
            final String album = e.albumName?.toLowerCase() ?? '';
            final String artist = e.artistName?.toLowerCase() ?? '';
            if(album.contains(searchedText) || artist.contains(searchedText)) {
              return true;
            }
            return false;
          }).toList();
          LoadingStatus status = sortedAlbumsController.status.value;

          if(status == LoadingStatus.loading) {
            return const CircularProgressIndicator();
          }

          if(albumsSongsList.isEmpty) {
            return noItemsWidget(FontAwesomeIcons.recordVinyl, 'albums');
          }
          
          return ListView.builder(
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: albumsSongsList.length,
            itemBuilder: (context, index){
              return CustomAlbumDisplayWidget(
                albumSongsData: albumsSongsList[index], 
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


