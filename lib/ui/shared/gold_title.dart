import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/bolixo_colors.dart';

/// App bar title with a gold gradient shader for a premium feel.
class GoldTitle extends StatelessWidget {
  final String text;

  const GoldTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          BolixoColors.goldLight,
          BolixoColors.gold,
          BolixoColors.goldLight,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white, // needed for ShaderMask to work
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
