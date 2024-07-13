import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

double defaultTextFieldVerticalMargin = getScreenHeight() * 0.015;

InputDecoration generateFormTextFieldDecoration(content, prefixIcon){
  return InputDecoration(
    counterText: "",
    contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
    fillColor: const Color.fromARGB(255, 70, 64, 64),
    filled: true,
    border: InputBorder.none,
    hintText: 'Enter $content',
    prefixIcon: Icon(prefixIcon, size: 18),
    prefixIconColor: Colors.blueGrey,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.transparent),
    ),
  );
}

InputDecoration generatePlaylistNameTextFieldDecoration(content, prefixIcon){
  return InputDecoration(
    counterText: "",
    contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
    fillColor: const Color.fromARGB(255, 70, 64, 64),
    filled: true,
    hintText: 'Enter $content',
    prefixIcon: Icon(prefixIcon, size: 18),
    prefixIconColor: Colors.blueGrey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: const BorderSide(width: 1, color: Colors.transparent),
    ),
  );
}

InputDecoration generatePlaylistNameTextFieldDecorationNoFocus(content, prefixIcon){
  return InputDecoration(
    counterText: "",
    contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
    fillColor: const Color.fromARGB(255, 70, 64, 64),
    filled: true,
    hintText: 'Enter $content',
    prefixIcon: Icon(prefixIcon, size: 18),
    prefixIconColor: Colors.blueGrey,
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
      borderRadius: BorderRadius.circular(0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
      borderRadius: BorderRadius.circular(0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    ),
  );
}