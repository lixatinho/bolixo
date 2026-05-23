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
          Color(0xFFC9A84C),
          Color(0xFFDABE6A),
          Color(0xFFCBAA4E),
          Color(0xFFD6B85E),
          Color(0xFFC49E42),
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
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
