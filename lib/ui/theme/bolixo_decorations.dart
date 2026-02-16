import 'package:flutter/material.dart';
import 'bolixo_colors.dart';
import 'bolixo_typography.dart';

class BolixoDecorations {
  BolixoDecorations._();

  // Glass container
  static BoxDecoration glass({double radius = 24}) => BoxDecoration(
    color: BolixoColors.white6,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: BolixoColors.white12, width: 1),
  );

  // Standard card
  static BoxDecoration card({double radius = 20}) => BoxDecoration(
    color: BolixoColors.surfaceCard,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: BolixoColors.white6, width: 1),
  );

  // Elevated card
  static BoxDecoration elevatedCard({double radius = 24}) => BoxDecoration(
    color: BolixoColors.surfaceElevated,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: BolixoColors.white10, width: 1),
  );

  // Input decoration for dark theme
  static InputDecoration inputDecoration({String? hint, IconData? prefixIcon}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: BolixoTypography.bodyLarge.copyWith(
          color: BolixoColors.textTertiary,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: BolixoColors.textTertiary, size: 20)
            : null,
        filled: true,
        fillColor: BolixoColors.white8,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: BolixoColors.white15, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: BolixoColors.white15, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: BolixoColors.electricViolet, width: 1.5),
        ),
        counter: const SizedBox.shrink(),
      );

  // Bet input decoration (compact)
  static InputDecoration betInputDecoration = InputDecoration(
    filled: true,
    fillColor: BolixoColors.white8,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: BolixoColors.white15, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: BolixoColors.white15, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: BolixoColors.electricViolet, width: 1.5),
    ),
    counter: const SizedBox.shrink(),
  );
}
