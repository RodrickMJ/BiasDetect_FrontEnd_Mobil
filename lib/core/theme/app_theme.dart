import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final _seed = Color(0xFF2563EB);

  static ThemeData light(ColorScheme? dynamic) {
    final schema = dynamic ?? ColorScheme.fromSeed(seedColor: _seed);
    return ThemeData(
      useMaterial3: true,
      colorScheme: schema,
      textTheme: GoogleFonts.poppinsTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

        )
      )
    );
  }

  static ThemeData dark(ColorScheme? dynamic) {
    final schema = dynamic ?? ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: schema,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    );
  }
}