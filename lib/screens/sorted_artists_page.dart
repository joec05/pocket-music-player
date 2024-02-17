import 'package:flutter/material.dart';
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

class _SortedArtistsPageWidgetState extends State<_SortedArtistsPageWidgetStateful> with AutomaticKeepAliveClientMixin{
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
        child: ValueListenableBuilder(
          valueListenable: controller.artistsSongsList,
          builder: (context, artistsSongsListValue, child) {
            return ListView.builder(
              shrinkWrap: false,
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              primary: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: artistsSongsListValue.length,
              itemBuilder: (context, index){
                return CustomArtistDisplayWidget(
                  artistSongsData: artistsSongsListValue[index], 
                  key: UniqueKey()
                );
              }
            );
          },
        )
      ),
      bottomNavigationBar: CustomCurrentlyPlayingBottomWidget(key: UniqueKey()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


