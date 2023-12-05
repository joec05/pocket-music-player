// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:music_player_app/DisplayPlaylistSongs.dart';
import 'package:music_player_app/PlaylistEditor.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/custom/CustomButton.dart';
import 'package:music_player_app/state/main.dart';
import 'package:music_player_app/styles/AppStyles.dart';
import 'package:music_player_app/transition/RightToLeftTransition.dart';

class CustomPlaylistDisplayWidget extends StatefulWidget{
  final PlaylistSongsClass playlistSongsData;
  const CustomPlaylistDisplayWidget({super.key, required this.playlistSongsData});

  @override
  State<CustomPlaylistDisplayWidget> createState() =>_CustomPlaylistDisplayWidgetState();
}

class _CustomPlaylistDisplayWidgetState extends State<CustomPlaylistDisplayWidget>{
  late PlaylistSongsClass playlistSongsData;

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
      List<PlaylistSongsClass> playlistList = appStateClass.playlistList;
      playlistList.removeWhere((e) => e.playlistID == playlistID);
      appStateClass.setPlaylistList(playlistID, playlistList);
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
                          var updatedPlaylist = await Navigator.push(
                            context,
                            SliderRightToLeftRoute(page: PlaylistEditorWidget(playlistSongsData: playlistSongsData))
                          );
                          if(updatedPlaylist != null){
                            appStateClass.setPlaylistList(playlistSongsData.playlistID, updatedPlaylist);
                          }
                        }
                      }, navigationDelayDuration);
                    },
                    buttonText: 'Edit playlist',
                    width: double.infinity,
                    height: getScreenHeight() * 0.08,
                    buttonColor: Colors.transparent,
                    setBorderRadius: false,
                  ),
                  CustomButton(
                    onTapped: (){
                      if(mounted){
                        Navigator.of(bottomSheetContext).pop();
                      }
                      runDelay(() => deletePlaylist(), navigationDelayDuration);
                    },
                    buttonText: 'Delete playlist',
                    width: double.infinity,
                    height: getScreenHeight() * 0.08,
                    buttonColor: Colors.transparent,
                    setBorderRadius: false,
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
          onTap: (){
            runDelay(
              (){
                if(mounted){
                  Navigator.push(
                    context,
                    SliderRightToLeftRoute(
                      page: DisplayPlaylistSongsWidget(playlistSongsData: playlistSongsData)
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
                              playlistSongsData.playlistProfilePic.bytes.isEmpty ?
                                appStateClass.audioImageData!.bytes
                              : 
                                playlistSongsData.playlistProfilePic.bytes
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