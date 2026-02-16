import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/bolixo_colors.dart';

class AppElevatedButton extends StatelessWidget {
  final Function onPressedCallback;
  final String text;

  const AppElevatedButton({
    Key? key,
    required this.onPressedCallback,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: BolixoColors.accentGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onPressedCallback(),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: BolixoColors.textOnAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
