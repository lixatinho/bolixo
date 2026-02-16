import 'package:flutter/material.dart';
import 'bolixo_colors.dart';

class BolixoGradients {
  BolixoGradients._();

  /// Full-screen backgrounds (auth, loading)
  static const primary = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      BolixoColors.deepPlum,
      BolixoColors.royalPurple,
    ],
  );

  /// Bolao accent bar, easter egg borders
  static const accent = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      BolixoColors.accentGreen,
      BolixoColors.accentGreenLight,
    ],
  );
}
