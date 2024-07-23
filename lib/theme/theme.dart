import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

class AppTheme {
  ThemeData light = ThemeData(
    brightness: Brightness.light,
    textTheme: TextDisplayTheme.lightTextTheme,
    inputDecorationTheme: TextFieldTheme.lightInputDecorationTheme,
    dividerColor: Colors.black,
    cardColor: Colors.grey.withOpacity(0.5),
    primaryColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Color.fromARGB(255, 214, 219, 224))
  );

  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextDisplayTheme.darkTextTheme,
    inputDecorationTheme: TextFieldTheme.darkInputDecorationTheme,
    dividerColor: Colors.white,
    cardColor: Colors.grey.withOpacity(0.5),
    primaryColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Color.fromARGB(255, 57, 63, 63))
  );
}

final AppTheme globalTheme = AppTheme();
