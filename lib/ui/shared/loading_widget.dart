import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/bolixo_colors.dart';
import '../theme/bolixo_gradients.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: BolixoGradients.primary,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/copa_ball.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            )
                .animate(onPlay: (c) => c.repeat())
                .moveY(begin: 0, end: -14, duration: 500.ms, curve: Curves.easeOut)
                .then()
                .moveY(begin: -14, end: 0, duration: 500.ms, curve: Curves.easeIn)
                .then()
                .scaleY(begin: 1.0, end: 0.95, duration: 120.ms)
                .then()
                .scaleY(begin: 0.95, end: 1.0, duration: 120.ms),
            const SizedBox(height: 20),
            const Text(
              'Carregando...',
              style: TextStyle(
                color: BolixoColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
