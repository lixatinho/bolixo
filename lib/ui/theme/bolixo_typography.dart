import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bolixo_colors.dart';

class BolixoTypography {
  BolixoTypography._();

  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: BolixoColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: BolixoColors.textPrimary,
  );

  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: BolixoColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: BolixoColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: BolixoColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: BolixoColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: BolixoColors.textSecondary,
  );

  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: BolixoColors.textOnAccent,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: BolixoColors.textSecondary,
  );
}
