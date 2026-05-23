import 'package:flutter/material.dart';

class BolixoColors {
  BolixoColors._();

  // ── Navy backgrounds (dark → light) ──
  static const deepPlum = Color(0xFF060D18);       // deepest bg (app bar, loading)
  static const royalPurple = Color(0xFF0C1826);     // secondary navy
  static const backgroundPrimary = Color(0xFF080E1A);  // main scaffold bg
  static const backgroundSecondary = Color(0xFF0E1726); // alternating rows
  static const surfaceCard = Color(0xFF121F35);      // card surfaces
  static const surfaceElevated = Color(0xFF1A2A45);  // dialogs, sheets, elevated

  // ── Gold accent (titles, highlights, premium) ──
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFDEBE6A);
  static const goldDark = Color(0xFFB08A30);

  // ── Green accent (buttons, active states, CTAs) ──
  static const accentGreen = Color(0xFF059669);
  static const accentGreenLight = Color(0xFF34D399);

  // ── Cyan accent (links, progress, secondary highlights) ──
  static const accentCyan = Color(0xFF06B6D4);

  // ── Focus / interactive accent ──
  static const electricViolet = Color(0xFFD4A843);   // gold for focus borders

  // ── Text ──
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8B9BB5);    // muted blue-grey
  static const textTertiary = Color(0xFF5E7191);     // darker blue-grey
  static const textOnAccent = Color(0xFFFFFFFF);
  static const textLink = Color(0xFFD4A843);         // gold links

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
