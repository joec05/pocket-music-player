import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController {
  SharedPreferences? prefs;
  final String themeModeKey = 'theme-mode';

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  void storeThemeModeData(ThemeMode themeMode) async {
    await prefs!.setString(themeModeKey, themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<ThemeMode> getThemeModeData() async {
    String? nullableThemeModeData = prefs!.getString(themeModeKey);
    String themeModeData = nullableThemeModeData ?? 'light';
    if(themeModeData == 'light') {
      return ThemeMode.light;
    }

    return ThemeMode.dark;
  }
}

final sharedPreferencesController = SharedPreferencesController();