// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:music_player_app/DisplayPlaylistSongs.dart';
import 'package:music_player_app/PlaylistEditor.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/custom/CustomButton.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
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
      List<PlaylistSongsClass> playlistList = fetchReduxDatabase().playlistList;
      playlistList.removeWhere((e) => e.playlistID == playlistID);
      StoreProvider.of<AppState>(context).dispatch(PlaylistList(playlistList));
    }
  }


  void displayOptionsBottomSheet(){
    if(mounted){
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bottomSheetContext) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [   
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (){},
                      splashFactory: InkRipple.splashFactory,
                      child: CustomButton(
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
                                StoreProvider.of<AppState>(context).dispatch(PlaylistList(updatedPlaylist));
                              }
                            }
                          }, navigationDelayDuration);
                        },
                        buttonText: 'Edit playlist',
                        width: double.infinity,
                        height: getScreenHeight() * 0.075,
                        buttonColor: Colors.transparent,
                        setBorderRadius: false,
                      )
                    )
                  ),  
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (){},
                      splashFactory: InkRipple.splashFactory,
                      child: CustomButton(
                        onTapped: (){
                          if(mounted){
                            Navigator.of(bottomSheetContext).pop();
                          }
                          runDelay(() => deletePlaylist(), navigationDelayDuration);
                        },
                        buttonText: 'Delete playlist',
                        width: double.infinity,
                        height: getScreenHeight() * 0.075,
                        buttonColor: Colors.transparent,
                        setBorderRadius: false,
                      )
                    )
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
                                fetchReduxDatabase().audioImageDataClass!.bytes
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
                            Text('${playlistSongsData.songsList.length} songs', style: const TextStyle(color: Colors.grey, fontSize: 14),)
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