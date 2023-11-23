import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music_player_app/TagEditor.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';
import 'package:music_player_app/class/AudioCompleteDataClass.dart';
import 'package:music_player_app/class/PlaylistSongsClass.dart';
import 'package:music_player_app/custom/CustomButton.dart';
import 'package:music_player_app/redux/reduxLibrary.dart';
import 'package:music_player_app/streams/EditAudioMetadataStreamClass.dart';
import 'package:music_player_app/streams/CurrentAudioStreamClass.dart';
import 'package:music_player_app/styles/AppStyles.dart';
import 'package:music_player_app/transition/RightToLeftTransition.dart';
import 'package:uuid/uuid.dart';

class CustomCurrentlyPlayingExpandedWidget extends StatefulWidget{
  const CustomCurrentlyPlayingExpandedWidget({super.key});

  @override
  State<CustomCurrentlyPlayingExpandedWidget> createState() =>_CustomCurrentlyPlayingExpandedWidgetState();
}

class _CustomCurrentlyPlayingExpandedWidgetState extends State<CustomCurrentlyPlayingExpandedWidget>{
  ValueNotifier<AudioCompleteDataClass?> audioCompleteData = ValueNotifier(null);
  ValueNotifier<Duration> timeRemaining = ValueNotifier(Duration.zero);
  ValueNotifier<bool> isDraggingSlider = ValueNotifier(false); 
  ValueNotifier<double> currentPosition = ValueNotifier(0.0);
  ValueNotifier<String> currentDurationStr = ValueNotifier('00:00'); 
  ValueNotifier<DurationEndDisplay> displayCurrentDurationType = ValueNotifier(DurationEndDisplay.totalDuration);
  ValueNotifier<LoopStatus> currentLoopStatus = ValueNotifier(LoopStatus.repeatCurrent);
  late StreamSubscription currentAudioStreamClassSubscription;
  late StreamSubscription editAudioMetadataStreamClassSubscription;

  @override initState(){
    super.initState();
    initializeCurrentAudio();
    if(mounted){
      currentLoopStatus.value = fetchReduxDatabase().audioHandlerClass!.currentLoopStatus;
    }
    updateSliderPosition();
    isDraggingSlider.addListener((){
      if(mounted){
        if(audioCompleteData.value != null && !isDraggingSlider.value){
          updateSliderPosition();
        }
      }
    });
    fetchReduxDatabase().audioHandlerClass!.audioPlayer.positionStream.listen((newPosition) {
      if(mounted){
        if(audioCompleteData.value != null && !isDraggingSlider.value && newPosition.inMilliseconds <= audioCompleteData.value!.audioMetadataInfo.duration){
          currentPosition.value = min((newPosition.inMilliseconds / audioCompleteData.value!.audioMetadataInfo.duration), 1);
          currentDurationStr.value = _formatDuration(newPosition);
          timeRemaining.value = Duration(milliseconds: audioCompleteData.value!.audioMetadataInfo.duration) - newPosition;
        }
      }
    });
    currentAudioStreamClassSubscription = CurrentAudioStreamClass().currentAudioStream.listen((CurrentAudioStreamControllerClass data) {
      if(mounted){
        if(data.audioCompleteData.playerState == AudioPlayerState.stopped){
          Navigator.pop(context);
        }else{
          audioCompleteData.value = data.audioCompleteData;
        }
      }
    });
    editAudioMetadataStreamClassSubscription = EditAudioMetadataStreamClass().editAudioMetadataStream.listen((EditAudioMetadataStreamControllerClass data) {
      if(mounted){
        if(audioCompleteData.value != null){
          audioCompleteData.value = data.newAudioData;  
        }
      }
    });
  }

  void initializeCurrentAudio(){
    if(mounted){
      String currentAudioUrl = fetchReduxDatabase().audioHandlerClass!.currentAudioUrl;
      audioCompleteData.value = fetchReduxDatabase().allAudiosList[currentAudioUrl] == null ? null : fetchReduxDatabase().allAudiosList[currentAudioUrl]!.notifier.value;
    }
  }

  @override void dispose(){
    super.dispose();
    currentAudioStreamClassSubscription.cancel();
    editAudioMetadataStreamClassSubscription.cancel();
    audioCompleteData.dispose();
    timeRemaining.dispose();
    isDraggingSlider.dispose();
    currentPosition.dispose();
    currentDurationStr.dispose();
    displayCurrentDurationType.dispose();
    currentLoopStatus.dispose();
  }

  void updateSliderPosition(){
    if(mounted){
      if(fetchReduxDatabase().audioHandlerClass != null && audioCompleteData.value != null){
        Duration? currentDuration = fetchReduxDatabase().audioHandlerClass!.audioPlayer.duration;
        if(currentDuration != null){
          currentPosition.value = min((currentDuration.inMilliseconds / audioCompleteData.value!.audioMetadataInfo.duration), 1);
          currentDurationStr.value = _formatDuration(currentDuration);
          timeRemaining.value = Duration(milliseconds: audioCompleteData.value!.audioMetadataInfo.duration) - currentDuration;
        }
      }
    }
  }

  void pauseAudio() async{
    await fetchReduxDatabase().audioHandlerClass!.pause();
  }  

  void resumeAudio() async{
    await fetchReduxDatabase().audioHandlerClass!.play();
  }

  void modifyLoopStatus(LoopStatus loopStatus){
    if(mounted){
      currentLoopStatus.value = loopStatus;
    }
    fetchReduxDatabase().audioHandlerClass!.modifyLoopStatus(loopStatus);
  }

  void playNext() async{
    await fetchReduxDatabase().audioHandlerClass!.skipToNext();
  }

  void playPrev() async{
    await fetchReduxDatabase().audioHandlerClass!.skipToPrevious();
  }

  void onSliderChange(value){ 
    if(mounted){
      isDraggingSlider.value = true;
      currentPosition.value = value;
      var currentSecond = (value * audioCompleteData.value!.audioMetadataInfo.duration/ 1000).floor();
      currentDurationStr.value = formatSeconds(currentSecond);
    }
  }

  void onSliderEnd(value) async{
    if(mounted){
      var duration = ((value * audioCompleteData.value!.audioMetadataInfo.duration) ~/ 10) * 10;
      currentPosition.value = value ;
      isDraggingSlider.value = false;
      await fetchReduxDatabase().audioHandlerClass!.audioPlayer.seek(Duration(milliseconds: duration));
    } 
  }

  String _formatDuration(Duration duration) { //convert duration to string
    String hours = (duration.inHours).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (hours == '00') {
      return '$minutes:$seconds';
    } else {
      return '$hours:$minutes:$seconds';
    }
  }

  String formatSeconds(int seconds) { //convert total seconds to string
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;
    
    String formattedTime = '';
    
    if (hours > 0) {
      formattedTime += '${hours.toString().padLeft(2, '0')}:';
    }
    
    formattedTime += '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    
    return formattedTime;
  }

  void displayOptionsBottomSheet(){
    List<String> favouritesList = fetchReduxDatabase().favouritesList;
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
                                  page: TagEditorWidget(audioCompleteData: audioCompleteData.value!)
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
                          if(mounted){
                            Navigator.of(bottomSheetContext).pop();
                          }
                          runDelay((){
                            if(mounted && mounted){
                              if(favouritesList.contains(audioCompleteData.value!.audioUrl)){
                                favouritesList.remove(audioCompleteData.value!.audioUrl);
                              }else{
                                favouritesList.add(audioCompleteData.value!.audioUrl);
                              }
                              StoreProvider.of<AppState>(context).dispatch(FavouritesList(favouritesList));
                            }
                          }, navigationDelayDuration);
                        },
                        buttonText: favouritesList.contains(audioCompleteData.value!.audioUrl) ? 'Remove from favourites' : 'Add to favourites',
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
                          runDelay((){
                            if(mounted){
                              deleteAudioFile(audioCompleteData.value!);
                            }
                          }, navigationDelayDuration);
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
    List<PlaylistSongsClass> playlistList = fetchReduxDatabase().playlistList;
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
                  playlistList[i].songsList.contains(audioCompleteData.value!.audioUrl) ?
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
                              runDelay(() => addToPlaylist(playlistList[i].playlistID), navigationDelayDuration);
                            }
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
      List<PlaylistSongsClass> playlistList = fetchReduxDatabase().playlistList;
      playlistList.add(PlaylistSongsClass(
        const Uuid().v4(), playlistName, fetchReduxDatabase().audioImageDataClass!, DateTime.now().toIso8601String(), [audioCompleteData.value!.audioUrl]
      ));
      StoreProvider.of<AppState>(context).dispatch(PlaylistList(playlistList));
    }
  }

  void addToPlaylist(String playlistID){
    if(mounted){
      List<PlaylistSongsClass> playlistList = fetchReduxDatabase().playlistList;
      for(int i = 0; i < playlistList.length; i++){
        if(playlistList[i].playlistID == playlistID){
          playlistList[i].songsList.add(audioCompleteData.value!.audioUrl);
        }
      }
      StoreProvider.of<AppState>(context).dispatch(PlaylistList(playlistList));
    }
  }

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: audioCompleteData, 
          builder: (context, audioCompleteDataValue, child){
            if(audioCompleteDataValue == null){
              return Container();
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultVerticalPadding * 2.5),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: getScreenWidth() * 0.7, height: getScreenWidth() * 0.7,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(150),
                            image: DecorationImage(
                              image: MemoryImage(
                                audioCompleteData.value!.audioMetadataInfo.albumArt.bytes.isEmpty ?
                                  fetchReduxDatabase().audioImageDataClass!.bytes
                                : 
                                  audioCompleteData.value!.audioMetadataInfo.albumArt.bytes
                              ), fit: BoxFit.fill
                            )
                          ),
                        ),
                        SizedBox(height: getScreenHeight() * 0.02),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.02),
                            child: Text(
                              audioCompleteDataValue.audioMetadataInfo.title ?? getNameFromAudioUrl(audioCompleteDataValue.audioUrl), 
                              style: const TextStyle(fontSize: 20), maxLines: 1
                            ),
                          ),
                        ),
                        Text(audioCompleteDataValue.audioMetadataInfo.artistName ?? 'Unknown', style: const TextStyle(color: Colors.grey, fontSize: 16.5),),
                        SizedBox(height: getScreenHeight() * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: getScreenWidth() * 0.07,),
                            ValueListenableBuilder(
                              valueListenable: currentLoopStatus,
                              builder: (context, currentLoopStatusValue, child){
                                return GestureDetector(
                                  onTap: (){
                                    if(currentLoopStatusValue == LoopStatus.repeatCurrent){
                                      modifyLoopStatus(LoopStatus.repeatAll);
                                    }else if(currentLoopStatusValue == LoopStatus.repeatAll){
                                      modifyLoopStatus(LoopStatus.shuffleAll);
                                    }else if(currentLoopStatusValue == LoopStatus.shuffleAll){
                                      modifyLoopStatus(LoopStatus.repeatCurrent);
                                    }
                                  },
                                  child: currentLoopStatusValue == LoopStatus.repeatCurrent ?
                                    const Icon(Icons.repeat_one, size: 30)
                                  : currentLoopStatusValue == LoopStatus.repeatAll ?
                                    const Icon(Icons.repeat , size: 30)
                                  : currentLoopStatusValue == LoopStatus.shuffleAll ?
                                    const Icon(Icons.shuffle, size: 30)
                                  : Container()
                                );
                              }
                            ),
                            SizedBox(width: getScreenWidth() * 0.07,),
                            GestureDetector(
                              onTap: () => playPrev(),
                              child: const Icon(Icons.skip_previous, size: 30)
                            ),
                            SizedBox(width: getScreenWidth() * 0.07,),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                                border: Border.all(width: 6.5, color: defaultCustomButtonColor),
                                color: defaultCustomButtonColor
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  if(audioCompleteDataValue.playerState == AudioPlayerState.paused){
                                    resumeAudio();
                                  }else if(audioCompleteDataValue.playerState == AudioPlayerState.playing){
                                    pauseAudio();
                                  }
                                },
                                child: audioCompleteDataValue.playerState == AudioPlayerState.paused ?
                                  const Icon(Icons.play_arrow, size: 35)
                                : const Icon(Icons.pause, size: 35)
                              ),
                            ),
                            SizedBox(width: getScreenWidth() * 0.07,),
                            GestureDetector(
                              onTap: () => playNext(),
                              child: const Icon(Icons.skip_next, size: 30)
                            ),
                            SizedBox(width: getScreenWidth() * 0.07),
                            GestureDetector(
                              onTap: (){
                                displayOptionsBottomSheet();
                              },
                              child: const Icon(Icons.more_vert, size: 30)
                            ),
                            SizedBox(width: getScreenWidth() * 0.07,),
                          ]
                        )
                      ],
                    ),
                    SizedBox(height: getScreenHeight() * 0.04),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 4),
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: displayCurrentDurationType,
                            builder: (BuildContext context, DurationEndDisplay displayType, Widget? child){
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ValueListenableBuilder<String>(
                                      valueListenable: currentDurationStr,
                                      builder: (BuildContext context, String currentDurationStr, Widget? child) {
                                        return Text(
                                          currentDurationStr, style: const TextStyle(fontSize: 15)
                                        );
                                      }
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        if(mounted){
                                          if(displayType == DurationEndDisplay.totalDuration){
                                            displayCurrentDurationType.value = DurationEndDisplay.timeRemaining;
                                          }else{
                                            displayCurrentDurationType.value = DurationEndDisplay.totalDuration;
                                          }
                                        }
                                      },
                                      child: ValueListenableBuilder<String>(
                                        valueListenable: currentDurationStr,
                                        builder: (BuildContext context, String currentDurationStr, Widget? child) {
                                          return displayType == DurationEndDisplay.totalDuration ?
                                            Text(
                                              _formatDuration(Duration(milliseconds: audioCompleteDataValue.audioMetadataInfo.duration)),
                                              style: const TextStyle(fontSize: 15)
                                            )
                                          : 
                                            ValueListenableBuilder<Duration>(
                                              valueListenable: timeRemaining,
                                              builder: (BuildContext context, Duration timeRemaining, Widget? child) {
                                                return Text(
                                                  _formatDuration(timeRemaining), style: const TextStyle(fontSize: 15)
                                                );
                                              }
                                            );
                                        }
                                      )
                                    )
                                  ]
                                ),
                              );
                            }
                          ),
                          SizedBox(height: getScreenHeight() * 0.01),
                          SizedBox(
                            height: 15,
                            child: SliderTheme(
                              data: const SliderThemeData(
                                trackHeight: 3.0,
                                thumbColor: Colors.cyan,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.blueGrey,
                                inactiveTrackColor: Colors.grey
                              ),
                              child: ValueListenableBuilder<double>(
                                valueListenable: currentPosition,
                                builder: (BuildContext context, double currentPosition, Widget? child) {
                                  return Slider(
                                    min: 0.0,
                                    max: 1.0,
                                    value: currentPosition,
                                    onChanged: (newValue) {
                                      onSliderChange(newValue);
                                    },
                                    onChangeEnd: (newValue){
                                      onSliderEnd(newValue);
                                    },
                                  );
                                }
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            );
          }
        ),
      ],
    );
  }
}