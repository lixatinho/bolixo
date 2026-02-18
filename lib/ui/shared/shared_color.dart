import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/bolixo_colors.dart';

Color shadeByIndex(MaterialColor color, int index) {
  int shade = 900 - min(800, 100 * index);
  return color[shade] ?? color.shade500;
}

/// Returns alternating dark row colors for ranking
Color rankingRowColor(int index) {
  return index.isEven ? BolixoColors.backgroundSecondary : const Color(0xFF151020);
}
