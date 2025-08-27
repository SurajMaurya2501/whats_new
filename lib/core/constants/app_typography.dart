import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle bodyText = GoogleFonts.roboto(fontSize: 15);
}

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade900,
    titleTextStyle: GoogleFonts.quicksand(color: Colors.white, fontSize: 22),
  ),
  colorSchemeSeed: Colors.indigo,
  brightness: Brightness.dark,
);
