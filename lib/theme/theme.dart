import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

class AppTheme {
  ThemeData light = ThemeData(
    brightness: Brightness.light,
    textTheme: TextDisplayTheme.lightTextTheme,
    inputDecorationTheme: TextFieldTheme.lightInputDecorationTheme,
    dividerColor: Colors.black,
    cardColor: Colors.grey.withOpacity(0.5)
  );

  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextDisplayTheme.darkTextTheme,
    inputDecorationTheme: TextFieldTheme.darkInputDecorationTheme,
    dividerColor: Colors.white,
    cardColor: Colors.grey.withOpacity(0.5)
  );
}

final AppTheme globalTheme = AppTheme();
