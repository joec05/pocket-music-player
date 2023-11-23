import 'package:flutter/material.dart';
import 'package:music_player_app/appdata/GlobalLibrary.dart';

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

InputDecoration generateFormTextFieldDecoration(content){
  OutlineInputBorder textFieldBorder = const OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.black),
  );

  OutlineInputBorder focusedTextFieldBorder = const OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.brown),
  );
  return InputDecoration(
    counterText: "",
    contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.01, horizontal: getScreenWidth() * 0.02),
    focusedBorder: focusedTextFieldBorder,
    enabledBorder: textFieldBorder,
    disabledBorder: textFieldBorder,
    hintText: 'Enter $content'
  );
}

double defaultTextFieldVerticalMargin = getScreenHeight() * 0.015;