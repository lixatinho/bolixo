import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/bolixo_colors.dart';
import '../theme/bolixo_gradients.dart';
import '../theme/bolixo_typography.dart';

const _loadingMessages = [
  'Cortando a grama...',
  'Levantando o Neymar...',
  'Abrindo o estádio...',
  'Calculando mitadas...',
];

/// Full-screen loading overlay with gradient background and bouncing ball.
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
      child: const Center(
        child: BolixoLoadingBall(size: 100, showLabel: true),
      ),
    );
  }
}

/// Inline bouncing ball loading indicator. Use instead of CircularProgressIndicator.
class BolixoLoadingBall extends StatelessWidget {
  final double size;
  final bool showLabel;

  const BolixoLoadingBall({
    super.key,
    this.size = 40,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/copa_ball.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        )
            .animate(onPlay: (c) => c.repeat())
            .moveY(begin: 0, end: -size * 0.14, duration: 500.ms, curve: Curves.easeOut)
            .then()
            .moveY(begin: -size * 0.14, end: 0, duration: 500.ms, curve: Curves.easeIn)
            .then()
            .scaleY(begin: 1.0, end: 0.95, duration: 120.ms)
            .then()
            .scaleY(begin: 0.95, end: 1.0, duration: 120.ms),
        if (showLabel) ...[
          const SizedBox(height: 20),
          Text(
            _loadingMessages[Random().nextInt(_loadingMessages.length)],
            style: BolixoTypography.bodyMedium.copyWith(
              color: BolixoColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
