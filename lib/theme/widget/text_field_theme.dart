import 'package:flutter/material.dart';

class TextFieldTheme {
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: Colors.brown,
    floatingLabelStyle: const TextStyle(color: Colors.teal),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.5),
      borderSide: const BorderSide(width: 1, color: Colors.teal),
    ),
    fillColor: Colors.grey.withOpacity(0.5)
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: Colors.brown,
    floatingLabelStyle: const TextStyle(color: Colors.teal),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.5),
      borderSide: const BorderSide(width: 1, color: Colors.teal),
    ),
    fillColor: Colors.grey.withOpacity(0.5)
  );
}