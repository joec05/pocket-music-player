import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player_app/global_files.dart';
import 'package:uuid/uuid.dart';

class SongOptionController {
  final BuildContext context;
  final AudioCompleteDataClass audioCompleteData;
  final PlaylistSongsClass? playlistSongsData;

  SongOptionController(
    this.context,
    this.audioCompleteData,
    this.playlistSongsData
  );

  bool get mounted => context.mounted;

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
                      Navigator.of(bottomSheetContext).pop();
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
                    text: 'Edit tags',
                    width: double.infinity,
                    height: getScreenHeight() * 0.08,
                    color: Colors.transparent,
                    setBorderRadius: false,
                    prefix: null,
                    loading: false
                  ),
                  CustomButton(
                    onTapped: () {
                      Navigator.of(bottomSheetContext).pop();
                      toggleFavourites();
                    },
                    text: appStateRepo.favouritesList.contains(audioCompleteData.audioUrl) ? 'Remove from favourites' : 'Add to favourites',
                    width: double.infinity,
                    height: getScreenHeight() * 0.08,
                    color: Colors.transparent,
                    setBorderRadius: false,
                    prefix: null,
                    loading: false
                  ),
                  CustomButton(
                    onTapped: (){
                      Navigator.of(bottomSheetContext).pop();
                      runDelay(() => displayAddToPlaylistDialog(), navigationDelayDuration);
                    },
                    text: 'Add to playlist',
                    width: double.infinity,
                    height: getScreenHeight() * 0.08,
                    color: Colors.transparent,
                    setBorderRadius: false,
                    prefix: null,
                    loading: false
                  ),
                  playlistSongsData != null ? 
                    CustomButton(
                      onTapped: (){
                        Navigator.of(bottomSheetContext).pop();
                        runDelay(() => removeFromPlaylist(), navigationDelayDuration);
                      },
                      text: 'Remove from playlist',
                      width: double.infinity,
                      height: getScreenHeight() * 0.08,
                      color: Colors.transparent,
                      setBorderRadius: false,
                      prefix: null,
                      loading: false
                    )
                  : Container(),
                  CustomButton(
                    onTapped: (){
                      Navigator.of(bottomSheetContext).pop();
                      displayConfirmDeleteSongDialog();
                    },
                    text: 'Delete',
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

  void displayAddToPlaylistDialog(){
    if(mounted){
      showDialog(
        context: context,
        builder: (bottomSheetContext) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.5),
                topRight: Radius.circular(12.5)
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.02
                ),
                const Text(
                  'Add to playlist',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                SizedBox(
                  height: getScreenHeight() * 0.02
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey,
                  height: 1.5
                ),
                CustomButton(
                  onTapped: (){
                    Navigator.of(bottomSheetContext).pop();
                    runDelay(() => displayCreatePlaylistDialog(), navigationDelayDuration);
                  },
                  text: 'Create new playlist',
                  width: double.infinity,
                  height: getScreenHeight() * 0.08,
                  color: Colors.transparent,
                  setBorderRadius: false,
                  prefix: null,
                  loading: false
                ),
                CustomButton(
                  onTapped: (){
                    Navigator.of(bottomSheetContext).pop();
                    runDelay(() => displaySelectExistingPlaylistDialog(), navigationDelayDuration);
                  },
                  text: 'Select existing playlist',
                  width: double.infinity,
                  height: getScreenHeight() * 0.08,
                  color: Colors.transparent,
                  setBorderRadius: false,
                  prefix: null,
                  loading: false
                ),
              ],
            )
          );
        }
      );
    }
  }

  void displaySelectExistingPlaylistDialog(){
    List<PlaylistSongsClass> playlistList = appStateRepo.playlistList;
    if(mounted){
      showDialog(
        context: context,
        builder: (bottomSheetContext) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.5),
                topRight: Radius.circular(12.5)
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.02
                ),
                const Text(
                  'Select existing playlist',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                SizedBox(
                  height: getScreenHeight() * 0.02
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey,
                  height: 1.5
                ),
                for(int i = 0; i < playlistList.length; i++)
                  playlistList[i].songsList.contains(audioCompleteData.audioUrl) ?
                    const Material(color: Colors.transparent)
                  :
                    CustomButton(
                      onTapped: (){
                        Navigator.of(bottomSheetContext).pop();
                        runDelay(() => addToPlaylist(playlistList[i].playlistID), navigationDelayDuration);
                      },
                      text: playlistList[i].playlistName,
                      width: double.infinity,
                      height: getScreenHeight() * 0.08,
                      color: Colors.transparent,
                      setBorderRadius: false,
                      prefix: null,
                      loading: false
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
              return Dialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.5),
                    topRight: Radius.circular(12.5)
                  )
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: getScreenHeight() * 0.02
                    ),
                    const Text(
                      'Create new playlist',
                      style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.02
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.grey,
                      height: 1.5
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.08,
                      child: TextField(
                        maxLength: defaultTextFieldLimit,
                        controller: inputController,
                        decoration: generatePlaylistNameTextFieldDecorationNoFocus('playlist name', FontAwesomeIcons.list),
                        onChanged: (text){
                          setState((){
                            verifyInput = text.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    CustomButton(
                      width: double.infinity, height: getScreenHeight() * 0.065, 
                      color: verifyInput ? const Color.fromARGB(255, 143, 58, 52) : Colors.grey.withOpacity(0.5), 
                      text: 'Create playlist and add song', 
                      onTapped: (){
                        if(mounted){
                          if(verifyInput){
                            Navigator.of(bottomSheetContext).pop();
                            runDelay(() => createPlaylistAndAddSong(inputController.text), navigationDelayDuration);
                          }else{
                            return;
                          }
                        }
                      }, 
                      setBorderRadius: false,
                      prefix: null,
                      loading: false
                    ),
                  ],
                )
              );
            },
          );
        }
      );
    }
  }
  
  void displayConfirmDeleteSongDialog() {
    if(mounted){
      showDialog(
        context: context,
        builder: (bottomSheetContext) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.5),
                topRight: Radius.circular(12.5)
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.02
                ),
                const Text(
                  'Are you sure you want to delete this song?',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                SizedBox(
                  height: getScreenHeight() * 0.02
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey,
                  height: 1.5
                ),
                CustomButton(
                  onTapped: (){
                    Navigator.of(bottomSheetContext).pop();
                    runDelay(() => songFileController.deleteSong(
                      context, audioCompleteData
                    ), navigationDelayDuration);
                  },
                  text: 'Yes',
                  width: double.infinity,
                  height: getScreenHeight() * 0.08,
                  color: Colors.transparent,
                  setBorderRadius: false,
                  prefix: null,
                  loading: false
                ),
                CustomButton(
                  onTapped: (){
                    Navigator.of(bottomSheetContext).pop();
                  },
                  text: 'Select existing playlist',
                  width: double.infinity,
                  height: getScreenHeight() * 0.08,
                  color: Colors.transparent,
                  setBorderRadius: false,
                  prefix: null,
                  loading: false
                ),
              ],
            )
          );
        }
      );
    }
  }

  void createPlaylistAndAddSong(String playlistName){
    if(mounted){
      String playlistID = const Uuid().v4();
      List<PlaylistSongsClass> playlistList = appStateRepo.playlistList;
      playlistList.add(PlaylistSongsClass(
        playlistID, playlistName, ImageDataClass('', Uint8List.fromList([])), DateTime.now().toIso8601String(), [audioCompleteData.audioUrl]
      ));
      appStateRepo.setPlaylistList(playlistID, playlistList);
      handler.displaySnackbar(
        context, 
        SnackbarType.successful, 
        tSuccess.createPlaylistAddSong
      );
    }
  }

  void addToPlaylist(String playlistID){
    if(mounted){
      List<PlaylistSongsClass> playlistList = appStateRepo.playlistList;
      for(int i = 0; i < playlistList.length; i++){
        if(playlistList[i].playlistID == playlistID){
          playlistList[i].songsList.insert(0, audioCompleteData.audioUrl);
        }
      }
      appStateRepo.setPlaylistList(playlistID, playlistList);
      handler.displaySnackbar(
        context, 
        SnackbarType.successful, 
        tSuccess.addSongToPlaylist
      );
    }
  }

  void removeFromPlaylist(){
    if(mounted){
      String playlistID = playlistSongsData!.playlistID;
      List<PlaylistSongsClass> playlistList = appStateRepo.playlistList;
      for(int i = playlistList.length - 1; i >= 0; i--){
        if(playlistList[i].playlistID == playlistID){
          playlistList[i].songsList.remove(audioCompleteData.audioUrl);
          if(playlistList[i].songsList.isEmpty){
            playlistList.removeAt(i);
          }
        }
      }
      appStateRepo.setPlaylistList(playlistID, playlistList);
      handler.displaySnackbar(
        context, 
        SnackbarType.successful, 
        tSuccess.removeSongFromPlaylist
      );
      int getIndex = playlistList.indexWhere((e) => e.playlistID == playlistID);
      if(getIndex == -1){
        Navigator.pop(context);
      }
    }
  }

  void toggleFavourites() {
    List<String> favouritesList = appStateRepo.favouritesList;
    runDelay((){
      if(mounted){
        if(favouritesList.contains(audioCompleteData.audioUrl)){
          favouritesList.remove(audioCompleteData.audioUrl);
          handler.displaySnackbar(
            context, 
            SnackbarType.successful, 
            tSuccess.removeSongFromFavourites
          );
        }else{
          favouritesList.insert(0, audioCompleteData.audioUrl);
          handler.displaySnackbar(
            context, 
            SnackbarType.successful, 
            tSuccess.addSongToFavourites
          );
        }
        appStateRepo.setFavouritesList(favouritesList);
      }
    }, navigationDelayDuration);
  }
}
