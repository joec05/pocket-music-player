import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/global_files.dart';

class CustomPlaylistDisplayWidget extends StatefulWidget{
  final PlaylistSongsModel playlistSongsData;
  const CustomPlaylistDisplayWidget({super.key, required this.playlistSongsData});

  @override
  State<CustomPlaylistDisplayWidget> createState() =>_CustomPlaylistDisplayWidgetState();
}

class _CustomPlaylistDisplayWidgetState extends State<CustomPlaylistDisplayWidget>{
  late PlaylistSongsModel playlistSongsData;

  @override initState(){
    super.initState();
    playlistSongsData = widget.playlistSongsData;
  }

  @override void dispose(){
    super.dispose();
  }

  void deletePlaylist(){
    if(mounted){
      String playlistID = playlistSongsData.playlistID;
      List<PlaylistSongsModel> playlistList = appStateRepo.playlistList;
      int index = playlistList.indexWhere((e) => e.playlistID == playlistID);
      isarController.deletePlaylist(playlistList[index]);
      playlistList.removeAt(index);
      appStateRepo.setPlaylistList(playlistID, playlistList);
    }
  }


  void displayOptionsBottomSheet(){
    if(mounted){
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bottomSheetContext) {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 56, 54, 54),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)
                )
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: getScreenHeight() * 0.015),
                  Container(
                    height: getScreenHeight() * 0.01,
                    width: getScreenWidth() * 0.15,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  SizedBox(height: getScreenHeight() * 0.015), 
                  CustomButton(
                    onTapped: (){
                      if(mounted){
                        Navigator.of(bottomSheetContext).pop();
                      }
                      runDelay(() async{
                        if(mounted){
                          var updatedPlaylist = await Get.to(PlaylistEditorWidget(playlistSongsData: playlistSongsData));
                          if(updatedPlaylist != null){
                            appStateRepo.setPlaylistList(playlistSongsData.playlistID, updatedPlaylist);
                          }
                        }
                      }, navigationDelayDuration);
                    },
                    text: 'Edit playlist',
                    width: double.infinity,
                    height: getScreenHeight() * 0.08,
                    color: Colors.transparent,
                    setBorderRadius: false,
                    prefix: null,
                    loading: false
                  ),
                  CustomButton(
                    onTapped: (){
                      if(mounted){
                        Navigator.of(bottomSheetContext).pop();
                      }
                      runDelay(() => deletePlaylist(), navigationDelayDuration);
                    },
                    text: 'Delete playlist',
                    width: double.infinity,
                    height: getScreenHeight() * 0.08,
                    color: Colors.transparent,
                    setBorderRadius: false,
                    prefix: null,
                    loading: false
                  ),
                ]
              )
            )
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Card(
      color: defaultCustomButtonColor,
      margin: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(DisplayPlaylistSongsWidget(playlistSongsData: playlistSongsData)),
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
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: MemoryImage(
                              playlistSongsData.imageBytes.isEmpty ?
                                appStateRepo.audioImageData!.bytes
                              : 
                                Uint8List.fromList(playlistSongsData.imageBytes)
                            ), 
                            fit: BoxFit.fill,
                            onError: (exception, stackTrace) => Image.memory(appStateRepo.audioImageData!.bytes),
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
                                Flexible(child: Text(playlistSongsData.playlistName, style: const TextStyle(fontSize: 17), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            SizedBox(height: getScreenHeight() * 0.005),
                            Text(playlistSongsData.songsList.length == 1 ? '1 song' : '${playlistSongsData.songsList.length} songs', style: const TextStyle(color: Colors.grey, fontSize: 14),)
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    displayOptionsBottomSheet();
                  },
                  child: const Icon(Icons.more_vert)
                )
              ],
            )
          )
        )
      )
    );
  }
}