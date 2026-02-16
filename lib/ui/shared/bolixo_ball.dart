import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/bolixo_colors.dart';

/// Copa 2026 inspired soccer ball.
/// Modern triangular panel design with vibrant accent colors
/// that match the app's purple/green/cyan palette.
class BolixoBall extends StatelessWidget {
  final double size;

  const BolixoBall({Key? key, this.size = 80}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _Copa2026BallPainter(),
      ),
    );
  }
}

class _Copa2026BallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // Soft glow behind ball
    final glowPaint = Paint()
      ..color = BolixoColors.accentGreenLight.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(center, r, glowPaint);

    // Ball base - warm white
    final basePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 1.2,
        colors: [
          Colors.white,
          const Color(0xFFF5F0FA),
          const Color(0xFFE8E0F0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r * 0.9, basePaint);

    // Triangular panel design (Copa 2026 style)
    // 6 triangular panels radiating from center with alternating colors
    final colors = [
      BolixoColors.royalPurple,        // purple
      BolixoColors.accentGreen,         // green
      BolixoColors.accentCyan,          // cyan
      BolixoColors.royalPurple,        // purple
      BolixoColors.accentGreen,         // green
      BolixoColors.accentCyan,          // cyan
    ];

    for (int i = 0; i < 6; i++) {
      final startAngle = (i * 60 - 30) * pi / 180;
      final endAngle = (i * 60 + 30) * pi / 180;

      // Inner triangle (closer to center, larger)
      final innerPath = Path();
      innerPath.moveTo(
        center.dx + cos(startAngle) * r * 0.25,
        center.dy + sin(startAngle) * r * 0.25,
      );
      innerPath.lineTo(
        center.dx + cos(startAngle) * r * 0.72,
        center.dy + sin(startAngle) * r * 0.72,
      );
      innerPath.lineTo(
        center.dx + cos(endAngle) * r * 0.72,
        center.dy + sin(endAngle) * r * 0.72,
      );
      innerPath.lineTo(
        center.dx + cos(endAngle) * r * 0.25,
        center.dy + sin(endAngle) * r * 0.25,
      );
      innerPath.close();

      final panelPaint = Paint()
        ..color = colors[i].withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;
      canvas.drawPath(innerPath, panelPaint);

      // Panel edge lines
      final edgePaint = Paint()
        ..color = colors[i].withValues(alpha: 0.3)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke;
      canvas.drawPath(innerPath, edgePaint);
    }

    // Thin seam lines between panels
    final seamPaint = Paint()
      ..color = BolixoColors.textTertiary.withValues(alpha: 0.25)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * pi / 180;
      final inner = Offset(
        center.dx + cos(angle) * r * 0.2,
        center.dy + sin(angle) * r * 0.2,
      );
      final outer = Offset(
        center.dx + cos(angle) * r * 0.78,
        center.dy + sin(angle) * r * 0.78,
      );
      canvas.drawLine(inner, outer, seamPaint);
    }

    // Inner ring
    canvas.drawCircle(center, r * 0.25, seamPaint);
    // Outer ring
    canvas.drawCircle(center, r * 0.72, seamPaint);

    // 3D highlight / shine
    final shinePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        radius: 0.5,
        colors: [
          Colors.white.withValues(alpha: 0.55),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r * 0.88, shinePaint);

    // Ball outline
    final borderPaint = Paint()
      ..color = BolixoColors.white15
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, r * 0.9, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
