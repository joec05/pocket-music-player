import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

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