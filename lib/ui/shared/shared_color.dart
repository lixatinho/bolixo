import 'dart:math';

import 'package:flutter/material.dart';

Color shadeByIndex(MaterialColor color, int index) {
  int shade = 900 - min(800, 100 * index);
  return color[shade] ?? color.shade500;
}