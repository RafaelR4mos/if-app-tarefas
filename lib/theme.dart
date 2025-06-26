import 'package:flutter/material.dart';

class AppTheme {
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple, // cor base da paleta
    brightness: Brightness.dark,
    primary: const Color.fromARGB(143, 134, 136, 231),
    secondary: Colors.purpleAccent,
    surface: const Color(0x00121212),
    onPrimary: Colors.white,
    onSurface: Colors.white70,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onPrimary,
        centerTitle: true,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: TextStyle(color: darkColorScheme.onSurface),
      ),
    );
  }
}
