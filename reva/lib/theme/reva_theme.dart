import 'package:flutter/material.dart';

/// REVA's visual identity, carried over from the River web prototype.
class RevaTheme {
  static const Color background = Color(0xFF0E0E10);
  static const Color surface = Color(0xFF1A1A1D);
  static const Color accent = Color(0xFF7C5CFC);
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFA0A0A8);

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accent,
        surface: surface,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(color: textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: textPrimary,
      ),
      useMaterial3: true,
    );
  }
}
