import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

class CustomArtistDisplayWidget extends StatefulWidget{
  final ArtistSongsClass artistSongsData;
  
  const CustomArtistDisplayWidget({super.key, required this.artistSongsData});

  @override
  State<CustomArtistDisplayWidget> createState() =>_CustomArtistDisplayWidgetState();
}

class _CustomArtistDisplayWidgetState extends State<CustomArtistDisplayWidget>{
  late ArtistSongsClass artistSongsData;

  @override initState(){
    super.initState();
    artistSongsData = widget.artistSongsData;
  }

  @override void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Card(
      color: defaultCustomButtonColor,
      margin: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => (DisplayArtistSongsWidget(artistSongsData: artistSongsData)))),
          splashFactory: InkSparkle.splashFactory,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Text(
                                            artistSongsData.artistName ?? 'Unknown', 
                                            style: const TextStyle(fontSize: 16), 
                                            maxLines: 1, 
                                            overflow: TextOverflow.ellipsis
                                          )
                                        ]
                                      )
                                    ),
                                  ],
                                ),
                                SizedBox(height: getScreenHeight() * 0.005),
                                Text(
                                  artistSongsData.songsList.length == 1 ? '1 song' : 
                                  '${artistSongsData.songsList.length} songs', 
                                  style: const TextStyle(fontSize: 13)
                                )
                              ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          )
        )
      )
    );
  }
}