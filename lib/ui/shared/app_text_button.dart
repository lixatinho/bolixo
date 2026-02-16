import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/bolixo_colors.dart';

class AppTextButton extends StatelessWidget {
  final Function onPressedCallback;
  final String text;

  const AppTextButton({
    Key? key,
    required this.onPressedCallback,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressedCallback(),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: BolixoColors.textLink,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
