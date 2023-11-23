import 'package:flutter/material.dart';
import 'package:music_player_app/DisplayAlbumSongs.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AlbumSongsClass.dart';
import 'package:music_player_app/styles/AppStyles.dart';
import 'package:music_player_app/transition/RightToLeftTransition.dart';

class CustomAlbumDisplayWidget extends StatefulWidget{
  final AlbumSongsClass albumSongsData;

  const CustomAlbumDisplayWidget({super.key, required this.albumSongsData});

  @override
  State<CustomAlbumDisplayWidget> createState() =>_CustomAlbumDisplayWidgetState();
}

class _CustomAlbumDisplayWidgetState extends State<CustomAlbumDisplayWidget>{
  late AlbumSongsClass albumSongsData;

  @override initState(){
    super.initState();
    albumSongsData = widget.albumSongsData;
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
          onTap: (){
            runDelay(
              (){
                if(mounted){
                  Navigator.push(
                    context,
                    SliderRightToLeftRoute(
                      page: DisplayAlbumSongsWidget(albumSongsData: albumSongsData)
                    )
                  );
                }
              }, navigationDelayDuration
            );
          },
          splashFactory: InkRipple.splashFactory,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: getScreenWidth() * 0.125, height: getScreenWidth() * 0.125,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: MemoryImage(
                              albumSongsData.albumProfilePic.bytes.isEmpty ?
                                fetchReduxDatabase().audioImageDataClass!.bytes
                              : 
                                albumSongsData.albumProfilePic.bytes
                            ), fit: BoxFit.fill
                          )
                        ),
                      ),
                      SizedBox(width: getScreenWidth() * 0.035),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(child: Text(albumSongsData.albumName ?? 'Unknown', style: const TextStyle(fontSize: 17), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            SizedBox(height: getScreenHeight() * 0.005),
                            Text(albumSongsData.artistName ?? 'Unknown', style: const TextStyle(color: Colors.grey, fontSize: 14),),
                            SizedBox(height: getScreenHeight() * 0.005),
                            Text('${albumSongsData.songsList.length} songs', style: const TextStyle(color: Colors.grey, fontSize: 14),)
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          )
        )
      )
    );
  }
}