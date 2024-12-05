import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

double defaultTextFieldVerticalMargin = getScreenHeight() * 0.025;

InputDecoration generateFormTextFieldDecoration(BuildContext context, content, prefixIcon){
  return InputDecoration(
    counterText: "",
    floatingLabelStyle: const TextStyle(fontSize: 13.5),
    hintStyle: const TextStyle(fontSize: 13.5),
    contentPadding: EdgeInsets.symmetric(
      horizontal: getScreenWidth() * 0.035,
      vertical: 10
    ),
    fillColor: Colors.grey.withOpacity(0.6),
    filled: true,
    hintText: 'Enter $content',
    prefixIcon: Icon(prefixIcon, size: 16, color: Theme.of(context).primaryColor),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.transparent),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.transparent),
    ),
  );
}

InputDecoration generatePlaylistNameTextFieldDecoration(BuildContext context, content, prefixIcon){
  return InputDecoration(
    counterText: "",
    floatingLabelStyle: const TextStyle(fontSize: 13.5),
    hintStyle: const TextStyle(fontSize: 13.5),
    contentPadding: EdgeInsets.symmetric(
      horizontal: getScreenWidth() * 0.035,
      vertical: 10
    ),
    fillColor: Colors.grey.withOpacity(0.6),
    filled: true,
    hintText: 'Enter $content',
    //prefixIcon: Icon(prefixIcon, size: 17, color: Theme.of(context).primaryColor),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
    ),
  );
}