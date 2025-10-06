import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class AppTheme {
  // Shared Colors
  static const Color accentColor = Color(0xFF00FFD5);
  static const Color secondaryColor = Color(0xFF9F70FD);
  static const Color tertiaryColor = Color(0xFF42A5F5);
  static const Color primaryColor = Color(0xFF02040F);

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: secondaryColor,
      background: primaryColor,
      surface: Color(0xFF1A1C2A),
    ),
    appBarTheme: _buildAppBarTheme(GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme)),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1C2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: GoogleFonts.rajdhaniTextTheme(ThemeData.dark().textTheme),
    inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF0F2F5),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.deepPurple,
      background: Color(0xFFF0F2F5),
      surface: Colors.white,
    ),
    appBarTheme: _buildAppBarTheme(GoogleFonts.orbitronTextTheme(ThemeData.light().textTheme)),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: GoogleFonts.rajdhaniTextTheme(ThemeData.light().textTheme),
    inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
  );

  static AppBarTheme _buildAppBarTheme(TextTheme baseTextTheme) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: true,
      titleTextStyle: baseTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  // --- THIS IS THE UPDATED METHOD ---
  static InputDecorationTheme _buildInputDecorationTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[400]!;

    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
      // Style for the border when the field is not focused
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      // Style for the border when the field is focused (tapped on)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? accentColor : Colors.blue, width: 2),
      ),
      // Default border style (used by other states like error)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
    );
  }
}

