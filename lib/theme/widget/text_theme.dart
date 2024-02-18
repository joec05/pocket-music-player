import 'package:flutter/material.dart';

class TextDisplayTheme {
  static TextTheme lightTextTheme = const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.black),
    displaySmall: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 15.5, fontWeight: FontWeight.normal, color: Colors.black),
    headlineMedium: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 17.0, fontWeight: FontWeight.w600, color: Colors.black),
    headlineSmall: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 15.5, fontWeight: FontWeight.normal, color: Colors.black),
    titleLarge: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black),
    bodyLarge: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 17.0, color: Colors.black),
    bodyMedium: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 15.5, color: Colors.black),
  );

  static TextTheme darkTextTheme = const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.white),
    displaySmall: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 15.5, fontWeight: FontWeight.normal, color: Colors.white),
    headlineMedium: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 17.0, fontWeight: FontWeight.w600, color: Colors.white),
    headlineSmall: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 15.5, fontWeight: FontWeight.normal, color: Colors.white),
    titleLarge: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
    bodyLarge: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 17.0, color: Colors.white),
    bodyMedium: TextStyle(fontFamily: 'Poly', fontStyle: FontStyle.normal, fontSize: 15.5, color: Colors.white),
  );
}
