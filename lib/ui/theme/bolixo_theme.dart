import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bolixo_colors.dart';

class BolixoTheme {
  BolixoTheme._();

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: BolixoColors.backgroundPrimary,
    primaryColor: BolixoColors.electricViolet,
    colorScheme: const ColorScheme.dark(
      primary: BolixoColors.electricViolet,
      secondary: BolixoColors.accentGreen,
      surface: BolixoColors.surfaceCard,
      error: BolixoColors.error,
      onPrimary: BolixoColors.textPrimary,
      onSecondary: BolixoColors.textOnAccent,
      onSurface: BolixoColors.textPrimary,
      onError: BolixoColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: BolixoColors.textPrimary),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: BolixoColors.textPrimary,
      ),
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: BolixoColors.textPrimary),
        headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: BolixoColors.textPrimary),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: BolixoColors.textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: BolixoColors.textPrimary),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: BolixoColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BolixoColors.textSecondary),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: BolixoColors.textSecondary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BolixoColors.textOnAccent),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: BolixoColors.textSecondary),
      ),
    ),
    cardTheme: CardThemeData(
      color: BolixoColors.surfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: BolixoColors.white6, width: 1),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: BolixoColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: BolixoColors.backgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: BolixoColors.surfaceElevated,
      contentTextStyle: const TextStyle(color: BolixoColors.textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: BolixoColors.electricViolet,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: BolixoColors.white8,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: BolixoColors.white15),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: BolixoColors.white15),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: BolixoColors.electricViolet, width: 1.5),
      ),
    ),
  );
}
