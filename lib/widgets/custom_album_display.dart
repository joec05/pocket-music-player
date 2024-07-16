import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_music_player/global_files.dart';

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
          onTap: () => Get.to(DisplayAlbumSongsWidget(albumSongsData: albumSongsData)),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedMemoryImage(
                          width: getScreenWidth() * 0.125, 
                          height: getScreenWidth() * 0.125,
                          bytes: albumSongsData.albumProfilePic == null ?
                              appStateRepo.audioImageData!
                            : 
                              albumSongsData.albumProfilePic!,
                          uniqueKey: albumSongsData.songsList.first,
                          errorBuilder: (context, exception, stackTrace) => Image.memory(appStateRepo.audioImageData!),
                          errorWidget: Image.memory(appStateRepo.audioImageData!),
                          fit: BoxFit.cover
                        )
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
                            Text(albumSongsData.artistName ?? 'Unknown', style: const TextStyle(fontSize: 14),),
                            SizedBox(height: getScreenHeight() * 0.005),
                            Text(albumSongsData.songsList.length == 1 ? '1 song' : '${albumSongsData.songsList.length} songs', style: const TextStyle(fontSize: 14),)
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