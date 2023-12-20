import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/global_library.dart';

double defaultHorizontalPadding = getScreenWidth() * 0.045;

double defaultVerticalPadding = getScreenHeight() * 0.025;

double defaultAppBarTitleSpacingWithBackBtn = getScreenWidth() * 0.02;

double defaultAppBarTitleSpacingWithoutBackBtn = getScreenWidth() * 0.045;

BoxDecoration defaultAppBarDecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color.fromARGB(255, 111, 126, 211), Color.fromARGB(255, 18, 151, 138)
    ],
    stops: [
      0.35, 0.75
    ],
  ),
);

BoxDecoration defaultInitialScreenDecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color.fromARGB(255, 111, 126, 211), Color.fromARGB(255, 18, 151, 138)
    ],
    stops: [
      0.35, 0.75
    ],
  ),
);

Color defaultCustomButtonColor = const Color.fromARGB(255, 66, 63, 63);

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
  );
}

double defaultTextFieldVerticalMargin = getScreenHeight() * 0.015;