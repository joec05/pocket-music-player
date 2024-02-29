import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

Widget noItemsWidget(IconData icon, String item) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 25),
        SizedBox(
          height: getScreenHeight() * 0.015,
        ),
        Text('No $item found')
      ],
    ),
  );
}