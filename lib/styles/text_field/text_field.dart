import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

double defaultTextFieldVerticalMargin = getScreenHeight() * 0.015;

InputDecoration generateFormTextFieldDecoration(content, prefixIcon){
  return InputDecoration(
    counterText: "",
    contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
    fillColor: const Color.fromARGB(255, 116, 108, 108),
    filled: true,
    hintText: 'Enter $content',
    prefixIcon: Icon(prefixIcon, size: 18),
    prefixIconColor: Colors.teal,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.transparent),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.transparent),
    ),
  );
}

InputDecoration generatePlaylistNameTextFieldDecoration(content, prefixIcon){
  return InputDecoration(
    counterText: "",
    contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
    fillColor: const Color.fromARGB(255, 94, 85, 85),
    filled: true,
    hintText: 'Enter $content',
    prefixIcon: Icon(prefixIcon, size: 18),
    prefixIconColor: Colors.teal,
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