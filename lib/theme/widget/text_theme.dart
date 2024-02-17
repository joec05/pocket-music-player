import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextDisplayTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.poly(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: GoogleFonts.poly(fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.black),
    displaySmall: GoogleFonts.poly(fontSize: 15.5, fontWeight: FontWeight.normal, color: Colors.black),
    headlineMedium: GoogleFonts.poly(fontSize: 17.0, fontWeight: FontWeight.w600, color: Colors.black),
    headlineSmall: GoogleFonts.poly(fontSize: 15.5, fontWeight: FontWeight.normal, color: Colors.black),
    titleLarge: GoogleFonts.poly(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black),
    bodyLarge: GoogleFonts.poly(fontSize: 17.0, color: Colors.black),
    bodyMedium: GoogleFonts.poly(fontSize: 15.5, color: Colors.black),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.poly(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: GoogleFonts.poly(fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.white),
    displaySmall: GoogleFonts.poly(fontSize: 15.5, fontWeight: FontWeight.normal, color: Colors.white),
    headlineMedium: GoogleFonts.poly(fontSize: 17.0, fontWeight: FontWeight.w600, color: Colors.white),
    headlineSmall: GoogleFonts.poly(fontSize: 15.5, fontWeight: FontWeight.normal, color: Colors.white),
    titleLarge: GoogleFonts.poly(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
    bodyLarge: GoogleFonts.poly(fontSize: 17.0, color: Colors.white),
    bodyMedium: GoogleFonts.poly(fontSize: 15.5, color: Colors.white),
  );
}
