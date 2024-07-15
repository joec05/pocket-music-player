import 'package:pocket_music_player/controllers/shared_preferences/shared_preferences_controller.dart';
import 'package:flutter/material.dart';

class ThemeModel {
  ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);

  void toggleMode() {
    mode.value = mode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    sharedPreferencesController.storeThemeModeData(mode.value);
  }
}

final themeModel = ThemeModel();