// ignore_for_file: dead_code

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_player_app/TagEditor.dart';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';
import 'package:music_player_app/class/ImageDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/custom/CustomButton.dart';
import 'package:music_player_app/custom/CustomPlayingIndicator.dart';
import 'package:music_player_app/state/main.dart';
import 'package:music_player_app/styles/AppStyles.dart';
import 'package:music_player_app/transition/RightToLeftTransition.dart';
import 'package:uuid/uuid.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';

class CustomAudioPlayerWidget extends StatefulWidget{
  final AudioCompleteDataClass audioCompleteData;
  final List<String> directorySongsList;
  final PlaylistSongsClass? playlistSongsData;

  const CustomAudioPlayerWidget({
    super.key, 
    required this.audioCompleteData, 
    required this.directorySongsList,
    required this.playlistSongsData,
  });

  @override
  State<CustomAudioPlayerWidget> createState() =>_CustomAudioPlayerWidgetState();
}

class _CustomAudioPlayerWidgetState extends State<CustomAudioPlayerWidget> with SingleTickerProviderStateMixin {
  late AudioCompleteDataClass audioCompleteData;

  @override initState(){
    super.initState();
    audioCompleteData = widget.audioCompleteData;
  }

  void playAudio() async{
    List<String> directorySongsList = [...widget.directorySongsList];
    List<String> directorySongsListShuffled = [...widget.directorySongsList];
    directorySongsListShuffled.shuffle();
    appStateClass.audioHandler!.updateListDirectory(
      directorySongsList, directorySongsListShuffled
    );
    appStateClass.audioHandler!.setCurrentSong(audioCompleteData);
    appStateClass.audioHandler!.play();
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
                          runDelay((){
                            if(mounted){
                              Navigator.push(
                                context,
                                SliderRightToLeftRoute(
                                  page: TagEditorWidget(audioCompleteData: audioCompleteData)
                                )
                              );
                            }
                          }, navigationDelayDuration);
                        },
                        buttonText: 'Edit tags',
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
                          List<String> favouritesList = appStateClass.favouritesList;
                          if(mounted){
                            Navigator.of(bottomSheetContext).pop();
                          }
                          runDelay((){
                            if(mounted){
                              if(favouritesList.contains(audioCompleteData.audioUrl)){
                                favouritesList.remove(audioCompleteData.audioUrl);
                              }else{
                                favouritesList.insert(0, audioCompleteData.audioUrl);
                              }
                              appStateClass.setFavouritesList(favouritesList);
                            }
                          }, navigationDelayDuration);
                        },
                        buttonText: appStateClass.favouritesList.contains(audioCompleteData.audioUrl) ? 'Remove from favourites' : 'Add to favourites',
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
                          runDelay(() => displayAddToPlaylistDialog(), navigationDelayDuration);
                        },
                        buttonText: 'Add to playlist',
                        width: double.infinity,
                        height: getScreenHeight() * 0.075,
                        buttonColor: Colors.transparent,
                        setBorderRadius: false,
                      )
                    )
                  ) ,
                  widget.playlistSongsData != null ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (){},
                      splashFactory: InkRipple.splashFactory,
                      child: CustomButton(
                        onTapped: (){
                          if(mounted){
                            Navigator.of(bottomSheetContext).pop();
                          }
                          runDelay(() => removeFromPlaylist(), navigationDelayDuration);
                        },
                        buttonText: 'Remove from playlist',
                        width: double.infinity,
                        height: getScreenHeight() * 0.075,
                        buttonColor: Colors.transparent,
                        setBorderRadius: false
                      )
                    )
                  ) : Container(),
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
                          runDelay(() => deleteAudioFile(audioCompleteData), navigationDelayDuration);
                        },
                        buttonText: 'Delete',
                        width: double.infinity,
                        height: getScreenHeight() * 0.075,
                        buttonColor: Colors.transparent,
                        setBorderRadius: false,
                      )
                    )
                  ) ,
                ]
              )
            )
          );
        }
      );
    }
  }

  void displayAddToPlaylistDialog(){
    if(mounted){
      showDialog(
        context: context,
        builder: (bottomSheetContext) {
          return AlertDialog(
            titlePadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.015, horizontal: getScreenWidth() * 0.035),
            contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
            title: const Text('Add to playlist'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey,
                  height: 1.5
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
                        runDelay(() => displayCreatePlaylistDialog(), navigationDelayDuration);
                      },
                      buttonText: 'Create new playlist',
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
                        runDelay(() => displaySelectExistingPlaylistDialog(), navigationDelayDuration);
                      },
                      buttonText: 'Select existing playlist',
                      width: double.infinity,
                      height: getScreenHeight() * 0.075,
                      buttonColor: Colors.transparent,
                      setBorderRadius: false,
                    )
                  )
                ),
              ],
            )
          );
        }
      );
    }
  }

  void displaySelectExistingPlaylistDialog(){
    List<PlaylistSongsClass> playlistList = appStateClass.playlistList;
    if(mounted){
      showDialog(
        context: context,
        builder: (bottomSheetContext) {
          return AlertDialog(
            titlePadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.015, horizontal: getScreenWidth() * 0.035),
            contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
            title: const Text('Select existing playlist'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey,
                  height: 1.5
                ),
                for(int i = 0; i < playlistList.length; i++)
                  playlistList[i].songsList.contains(audioCompleteData.audioUrl) ?
                    const Material(color: Colors.transparent)
                  :
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
                            runDelay(() => addToPlaylist(playlistList[i].playlistID), navigationDelayDuration);
                          },
                          buttonText: playlistList[i].playlistName,
                          width: double.infinity,
                          height: getScreenHeight() * 0.075,
                          buttonColor: Colors.transparent,
                          setBorderRadius: false,
                        )
                      )
                    ) 
              ],
            )
          );
        }
      );
    }
  }
  
  void displayCreatePlaylistDialog(){
    TextEditingController inputController = TextEditingController();
    bool verifyInput = false;
    if(mounted){
      showDialog(
        context: context,
        builder: (bottomSheetContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                titlePadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.015, horizontal: getScreenWidth() * 0.035),
                contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                title: const Text('Create new playlist'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.grey,
                      height: 1.5
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.075,
                      child: TextField(
                        maxLength: defaultTextFieldLimit,
                        controller: inputController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: getScreenWidth() * 0.035),
                          hintText: 'Enter playlist name',
                          counterText: ''
                        ),
                        onChanged: (text){
                          setState((){
                            verifyInput = text.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    CustomButton(
                      width: double.infinity, height: getScreenHeight() * 0.065, 
                      buttonColor: verifyInput ? Colors.red : Colors.grey.withOpacity(0.5), 
                      buttonText: 'Create playlist and add song', 
                      onTapped: (){
                        if(mounted){
                          if(verifyInput){
                            Navigator.of(bottomSheetContext).pop();
                            runDelay(() => createPlaylistAndAddSong(inputController.text), navigationDelayDuration);
                          }else{
                            return;
                          }
                        }
                      }, setBorderRadius: false
                    )
                  ],
                )
              );
            },
          );
        }
      );
    }
  }
  
  void createPlaylistAndAddSong(String playlistName){
    if(mounted){
      String playlistID = const Uuid().v4();
      List<PlaylistSongsClass> playlistList = appStateClass.playlistList;
      playlistList.add(PlaylistSongsClass(
        playlistID, playlistName, ImageDataClass('', Uint8List.fromList([])), DateTime.now().toIso8601String(), [audioCompleteData.audioUrl]
      ));
      appStateClass.setPlaylistList(playlistID, playlistList);
    }
  }

  void addToPlaylist(String playlistID){
    if(mounted){
      List<PlaylistSongsClass> playlistList = appStateClass.playlistList;
      for(int i = 0; i < playlistList.length; i++){
        if(playlistList[i].playlistID == playlistID){
          playlistList[i].songsList.insert(0, audioCompleteData.audioUrl);
        }
      }
      appStateClass.setPlaylistList(playlistID, playlistList);
    }
  }

  void removeFromPlaylist(){
    if(mounted){
      String playlistID = widget.playlistSongsData!.playlistID;
      List<PlaylistSongsClass> playlistList = appStateClass.playlistList;
      for(int i = playlistList.length - 1; i >= 0; i--){
        if(playlistList[i].playlistID == playlistID){
          playlistList[i].songsList.remove(audioCompleteData.audioUrl);
          if(playlistList[i].songsList.isEmpty){
            playlistList.removeAt(i);
          }
        }
      }
      int getIndex = playlistList.indexWhere((e) => e.playlistID == playlistID);
      if(getIndex == -1){
        Navigator.pop(context);
      }
      appStateClass.setPlaylistList(playlistID, playlistList);
    }
  }

  @override
  Widget build(BuildContext context){
    bool audioIsSelected = audioCompleteData.playerState == AudioPlayerState.playing || audioCompleteData.playerState == AudioPlayerState.paused;
    if(audioCompleteData.deleted){
      return Container();
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          runDelay(() => playAudio(), playingDelayDuration);
        },
        splashFactory: InkRipple.splashFactory,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2, vertical: defaultVerticalPadding / 2),
          color: audioIsSelected || appStateClass.audioHandler!.currentAudioUrl == audioCompleteData.audioUrl ? Colors.grey.withOpacity(0.6) : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: getScreenWidth() * 0.125, height: getScreenWidth() * 0.125,
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.black),
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: MemoryImage(
                                    audioCompleteData.audioMetadataInfo.albumArt.bytes.isEmpty ?
                                      appStateClass.audioImageData!.bytes
                                    : 
                                      audioCompleteData.audioMetadataInfo.albumArt.bytes
                                  ), fit: BoxFit.fill
                                )
                              )
                            ),
                            audioIsSelected ?
                              const CustomAudioPlayingIndicator()
                            : Container()
                          ]
                        ),
                      ),
                    ),
                    SizedBox(width: getScreenWidth() * 0.035),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(child: Text(audioCompleteData.audioMetadataInfo.title ?? getNameFromAudioUrl(audioCompleteData.audioUrl), style: const TextStyle(fontSize: 17), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          SizedBox(height: getScreenHeight() * 0.005),
                          Text(audioCompleteData.audioMetadataInfo.artistName ?? 'Unknown', style: const TextStyle(color: Colors.grey, fontSize: 14),),
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
    );
  }
}