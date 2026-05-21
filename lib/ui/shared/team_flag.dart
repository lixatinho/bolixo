import 'package:flutter/material.dart';
import '../theme/bolixo_colors.dart';

/// Displays a team flag clipped to a circle with proper aspect ratio handling.
class TeamFlag extends StatelessWidget {
  final String? abbreviation;
  final String? flagUrl;
  final double radius;

  const TeamFlag({
    super.key,
    this.abbreviation,
    this.flagUrl,
    this.radius = 20,
  });

  String get _assetPath {
    if (flagUrl != null && flagUrl!.isNotEmpty) return flagUrl!;
    if (abbreviation != null && abbreviation!.isNotEmpty) {
      return 'assets/images/teams/$abbreviation.png';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final path = _assetPath;
    final size = radius * 2;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: BolixoColors.surfaceCard,
        border: Border.all(color: BolixoColors.white10, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: path.isEmpty
          ? Icon(Icons.sports_soccer, color: Colors.white24, size: radius)
          : Image.asset(
              path,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.sports_soccer,
                color: Colors.white24,
                size: radius,
              ),
            ),
    );
  }
}
