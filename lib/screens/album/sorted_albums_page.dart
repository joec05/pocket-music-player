import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player_app/global_files.dart';

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
  late SortedAlbumsController controller;
  
  @override
  void initState(){
    super.initState();
    controller = SortedAlbumsController(context);
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
        child: ValueListenableBuilder(
          valueListenable: controller.albumsSongsList,
          builder: (context, albumSongsListValue, child) {
            if(albumSongsListValue.isEmpty) {
              return noItemsWidget(FontAwesomeIcons.recordVinyl, 'albums');
            }
            return ListView.builder(
              shrinkWrap: false,
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              primary: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: albumSongsListValue.length,
              itemBuilder: (context, index){
                return CustomAlbumDisplayWidget(
                  albumSongsData: albumSongsListValue[index], 
                  key: UniqueKey()
                );
              }
            );
          }
        )
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


