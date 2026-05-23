import 'package:flutter/material.dart';

class BolixoColors {
  BolixoColors._();

  // ── Deep green backgrounds (almost black with green undertone) ──
  static const deepPlum = Color(0xFF070E0B);          // deepest bg (app bar, loading)
  static const royalPurple = Color(0xFF0A1310);        // secondary
  static const backgroundPrimary = Color(0xFF060C09);  // main scaffold bg
  static const backgroundSecondary = Color(0xFF0B1510); // alternating rows
  static const surfaceCard = Color(0xFF101E17);         // card surfaces
  static const surfaceElevated = Color(0xFF162A20);     // dialogs, sheets, elevated

  // ── Gold accent (titles, highlights, premium) ──
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFDEBE6A);
  static const goldDark = Color(0xFFB08A30);

  // ── Legacy green accent (kept for semantic success only) ──
  static const accentGreen = Color(0xFF059669);
  static const accentGreenLight = Color(0xFF34D399);

  // ── Legacy cyan (unused in UI, kept for compatibility) ──
  static const accentCyan = Color(0xFF06B6D4);

  // ── Focus / interactive accent ──
  static const electricViolet = Color(0xFFD4A843);     // gold for focus borders

  // ── Text ──
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8BAA98);      // muted green-grey
  static const textTertiary = Color(0xFF5E8172);       // darker green-grey
  static const textOnAccent = Color(0xFFFFFFFF);
  static const textLink = Color(0xFFD4A843);           // gold links

  // ── Semantic ──
  static const success = Color(0xFF34D399);
  static const error = Color(0xFFF87171);
  static const warning = Color(0xFFFBBF24);
  static const easterEgg = Color(0xFFF7C948);

  // ── Opacity overlays ──
  static const white6 = Color(0x0FFFFFFF);
  static const white8 = Color(0x14FFFFFF);
  static const white10 = Color(0x1AFFFFFF);
  static const white12 = Color(0x1FFFFFFF);
  static const white15 = Color(0x26FFFFFF);
}
