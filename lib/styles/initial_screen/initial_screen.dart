import 'package:flutter/material.dart';

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