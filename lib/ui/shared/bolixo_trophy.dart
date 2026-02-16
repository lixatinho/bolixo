import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/bolixo_colors.dart';

/// Stylized World Cup trophy rendered with CustomPainter.
/// Gold/amber metallic appearance with a subtle green glow,
/// designed for the Bolixo dark premium theme.
class BolixoTrophy extends StatelessWidget {
  final double size;

  const BolixoTrophy({Key? key, this.size = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TrophyPainter(),
      ),
    );
  }
}

class _TrophyPainter extends CustomPainter {
  // Gold palette
  static const _goldDark = Color(0xFFB8860B);
  static const _gold = BolixoColors.easterEgg; // #F7C948
  static const _goldLight = Color(0xFFFFE082);
  static const _goldHighlight = Color(0xFFFFF8E1);
  static const _goldShadow = Color(0xFF8B6914);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // ── Outer green glow ──
    final glowPaint = Paint()
      ..color = BolixoColors.accentGreenLight.withValues(alpha: 0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawCircle(Offset(cx, h * 0.42), w * 0.40, glowPaint);

    // Second softer, wider glow layer
    final glowPaint2 = Paint()
      ..color = BolixoColors.accentGreenLight.withValues(alpha: 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(Offset(cx, h * 0.42), w * 0.55, glowPaint2);

    // ── Base / Pedestal ──
    _drawBase(canvas, w, h, cx);

    // ── Stem ──
    _drawStem(canvas, w, h, cx);

    // ── Cup body ──
    _drawCup(canvas, w, h, cx);

    // ── Handles ──
    _drawHandles(canvas, w, h, cx);

    // ── Lid / top sphere ──
    _drawLid(canvas, w, h, cx);

    // ── Star on cup ──
    _drawStar(canvas, w, h, cx);
  }

  /// Multi-tiered rectangular base with a gradient.
  void _drawBase(Canvas canvas, double w, double h, double cx) {
    // Bottom tier (widest)
    final bottomTier = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, h * 0.94),
        width: w * 0.50,
        height: h * 0.06,
      ),
      Radius.circular(w * 0.015),
    );
    final bottomTierPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_goldLight, _goldDark],
      ).createShader(bottomTier.outerRect);
    canvas.drawRRect(bottomTier, bottomTierPaint);

    // Bottom tier highlight
    final bottomHighlight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _goldHighlight.withValues(alpha: 0.4),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5],
      ).createShader(bottomTier.outerRect);
    canvas.drawRRect(bottomTier, bottomHighlight);

    // Bottom tier outline
    canvas.drawRRect(
      bottomTier,
      Paint()
        ..color = _goldShadow.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Middle tier
    final middleTier = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, h * 0.895),
        width: w * 0.40,
        height: h * 0.04,
      ),
      Radius.circular(w * 0.01),
    );
    final middleTierPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_goldLight, _gold, _goldDark],
      ).createShader(middleTier.outerRect);
    canvas.drawRRect(middleTier, middleTierPaint);

    canvas.drawRRect(
      middleTier,
      Paint()
        ..color = _goldShadow.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Top tier (narrowest base piece)
    final topTier = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, h * 0.862),
        width: w * 0.30,
        height: h * 0.03,
      ),
      Radius.circular(w * 0.008),
    );
    final topTierPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_goldHighlight, _gold, _goldDark],
      ).createShader(topTier.outerRect);
    canvas.drawRRect(topTier, topTierPaint);

    canvas.drawRRect(
      topTier,
      Paint()
        ..color = _goldShadow.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  /// Narrow column connecting base to cup with metallic gradient.
  void _drawStem(Canvas canvas, double w, double h, double cx) {
    final stemTop = h * 0.60;
    final stemBottom = h * 0.847;
    final stemHalfW = w * 0.04;

    // Flared node at top of stem (where it meets the cup)
    final nodeRect = Rect.fromCenter(
      center: Offset(cx, stemTop + h * 0.015),
      width: w * 0.14,
      height: h * 0.035,
    );
    final nodePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_goldLight, _gold, _goldDark],
      ).createShader(nodeRect);
    canvas.drawOval(nodeRect, nodePaint);

    // Main stem shaft
    final stemPath = Path();
    // Slightly tapered: wider at bottom
    stemPath.moveTo(cx - stemHalfW * 0.8, stemTop + h * 0.02);
    stemPath.lineTo(cx - stemHalfW * 1.1, stemBottom);
    stemPath.lineTo(cx + stemHalfW * 1.1, stemBottom);
    stemPath.lineTo(cx + stemHalfW * 0.8, stemTop + h * 0.02);
    stemPath.close();

    final stemPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [_goldDark, _goldLight, _gold, _goldDark],
        stops: const [0.0, 0.35, 0.65, 1.0],
      ).createShader(
        Rect.fromLTRB(cx - stemHalfW * 1.1, stemTop, cx + stemHalfW * 1.1, stemBottom),
      );
    canvas.drawPath(stemPath, stemPaint);

    // Stem outline
    canvas.drawPath(
      stemPath,
      Paint()
        ..color = _goldShadow.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Small flare at bottom of stem
    final bottomNode = Rect.fromCenter(
      center: Offset(cx, stemBottom),
      width: w * 0.12,
      height: h * 0.025,
    );
    canvas.drawOval(bottomNode, nodePaint);
  }

  /// The main cup bowl, drawn as a bezier shape with metallic shading.
  void _drawCup(Canvas canvas, double w, double h, double cx) {
    final cupTop = h * 0.14;
    final cupBottom = h * 0.60;
    final cupWidth = w * 0.52;
    final cupRimWidth = w * 0.56;

    // Cup body path
    final cupPath = Path();
    // Start at top-left rim
    cupPath.moveTo(cx - cupRimWidth / 2, cupTop);
    // Left side curves inward toward stem
    cupPath.cubicTo(
      cx - cupWidth / 2, cupTop + (cupBottom - cupTop) * 0.5,  // control 1
      cx - w * 0.12, cupBottom - h * 0.04,                      // control 2
      cx, cupBottom,                                              // end
    );
    // Right side (mirror)
    cupPath.cubicTo(
      cx + w * 0.12, cupBottom - h * 0.04,
      cx + cupWidth / 2, cupTop + (cupBottom - cupTop) * 0.5,
      cx + cupRimWidth / 2, cupTop,
    );
    cupPath.close();

    // Main gold fill with vertical metallic gradient
    final cupPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _goldLight,
          _gold,
          _goldDark,
          _goldShadow,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromLTRB(
        cx - cupRimWidth / 2, cupTop, cx + cupRimWidth / 2, cupBottom,
      ));
    canvas.drawPath(cupPath, cupPaint);

    // Horizontal metallic sheen (left-right gradient overlay)
    final sheenPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          _goldDark.withValues(alpha: 0.5),
          _goldHighlight.withValues(alpha: 0.3),
          Colors.transparent,
          _goldHighlight.withValues(alpha: 0.15),
          _goldDark.withValues(alpha: 0.5),
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTRB(
        cx - cupRimWidth / 2, cupTop, cx + cupRimWidth / 2, cupBottom,
      ));
    canvas.drawPath(cupPath, sheenPaint);

    // Central bright highlight (reflection band)
    final reflectPath = Path();
    final reflectLeft = cx - w * 0.06;
    final reflectRight = cx + w * 0.02;
    reflectPath.moveTo(reflectLeft, cupTop + h * 0.03);
    reflectPath.quadraticBezierTo(
      reflectLeft - w * 0.01, (cupTop + cupBottom) / 2,
      cx - w * 0.02, cupBottom - h * 0.06,
    );
    reflectPath.lineTo(reflectRight - w * 0.02, cupBottom - h * 0.06);
    reflectPath.quadraticBezierTo(
      reflectRight, (cupTop + cupBottom) / 2,
      reflectRight, cupTop + h * 0.03,
    );
    reflectPath.close();

    canvas.save();
    canvas.clipPath(cupPath);
    final reflectPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _goldHighlight.withValues(alpha: 0.5),
          _goldHighlight.withValues(alpha: 0.15),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromLTRB(
        reflectLeft, cupTop, reflectRight, cupBottom,
      ));
    canvas.drawPath(reflectPath, reflectPaint);
    canvas.restore();

    // Cup outline
    canvas.drawPath(
      cupPath,
      Paint()
        ..color = _goldShadow.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Rim highlight (bright line along top edge)
    final rimPath = Path();
    rimPath.moveTo(cx - cupRimWidth / 2 + w * 0.02, cupTop + h * 0.005);
    rimPath.lineTo(cx + cupRimWidth / 2 - w * 0.02, cupTop + h * 0.005);
    canvas.drawPath(
      rimPath,
      Paint()
        ..color = _goldHighlight.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    // Decorative horizontal band across the middle of the cup
    final bandY = cupTop + (cupBottom - cupTop) * 0.42;
    final bandPath = Path();
    // Approximate the cup width at that Y level
    final bandHalfW = cupWidth * 0.46;
    bandPath.moveTo(cx - bandHalfW, bandY - h * 0.008);
    bandPath.quadraticBezierTo(cx, bandY - h * 0.012, cx + bandHalfW, bandY - h * 0.008);
    bandPath.lineTo(cx + bandHalfW, bandY + h * 0.008);
    bandPath.quadraticBezierTo(cx, bandY + h * 0.012, cx - bandHalfW, bandY + h * 0.008);
    bandPath.close();

    canvas.save();
    canvas.clipPath(cupPath);
    canvas.drawPath(
      bandPath,
      Paint()..color = _goldHighlight.withValues(alpha: 0.18),
    );
    canvas.drawPath(
      bandPath,
      Paint()
        ..color = _goldShadow.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
    canvas.restore();
  }

  /// Two curved handles on either side of the cup.
  void _drawHandles(Canvas canvas, double w, double h, double cx) {
    final handlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.032
      ..strokeCap = StrokeCap.round;

    final handleOutline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.032 + 1.5
      ..strokeCap = StrokeCap.round
      ..color = _goldShadow.withValues(alpha: 0.4);

    // Handle attachment points on the cup
    final attachTopY = h * 0.20;
    final attachBottomY = h * 0.44;
    final handleOuterX = w * 0.16; // how far handles extend

    // Left handle
    final leftHandle = Path();
    leftHandle.moveTo(cx - w * 0.26, attachTopY);
    leftHandle.cubicTo(
      cx - w * 0.26 - handleOuterX, attachTopY - h * 0.02,
      cx - w * 0.22 - handleOuterX, attachBottomY + h * 0.04,
      cx - w * 0.20, attachBottomY,
    );

    // Right handle (mirror)
    final rightHandle = Path();
    rightHandle.moveTo(cx + w * 0.26, attachTopY);
    rightHandle.cubicTo(
      cx + w * 0.26 + handleOuterX, attachTopY - h * 0.02,
      cx + w * 0.22 + handleOuterX, attachBottomY + h * 0.04,
      cx + w * 0.20, attachBottomY,
    );

    // Draw outline first (acts as shadow/depth)
    canvas.drawPath(leftHandle, handleOutline);
    canvas.drawPath(rightHandle, handleOutline);

    // Left handle gradient (outer = dark, inner = light)
    handlePaint.shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [_goldDark, _goldLight, _gold],
    ).createShader(Rect.fromLTRB(
      cx - w * 0.26 - handleOuterX, attachTopY, cx - w * 0.20, attachBottomY,
    ));
    canvas.drawPath(leftHandle, handlePaint);

    // Right handle gradient
    handlePaint.shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [_gold, _goldLight, _goldDark],
    ).createShader(Rect.fromLTRB(
      cx + w * 0.20, attachTopY, cx + w * 0.26 + handleOuterX, attachBottomY,
    ));
    canvas.drawPath(rightHandle, handlePaint);

    // Handle tip accents (small circles at the bottom of each handle)
    final tipPaint = Paint()..color = _goldLight;
    canvas.drawCircle(
      Offset(cx - w * 0.20, attachBottomY),
      w * 0.016,
      tipPaint,
    );
    canvas.drawCircle(
      Offset(cx + w * 0.20, attachBottomY),
      w * 0.016,
      tipPaint,
    );
  }

  /// Small globe / sphere on top of the trophy.
  void _drawLid(Canvas canvas, double w, double h, double cx) {
    final sphereCenter = Offset(cx, h * 0.11);
    final sphereR = w * 0.055;

    // Small pedestal connecting cup rim to sphere
    final pedestalPath = Path();
    pedestalPath.moveTo(cx - w * 0.025, h * 0.14);
    pedestalPath.lineTo(cx - w * 0.015, h * 0.125);
    pedestalPath.lineTo(cx + w * 0.015, h * 0.125);
    pedestalPath.lineTo(cx + w * 0.025, h * 0.14);
    pedestalPath.close();
    canvas.drawPath(
      pedestalPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_goldDark, _goldLight, _goldDark],
        ).createShader(Rect.fromLTRB(
          cx - w * 0.025, h * 0.125, cx + w * 0.025, h * 0.14,
        )),
    );

    // Globe sphere
    final spherePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 1.0,
        colors: [
          _goldHighlight,
          _goldLight,
          _gold,
          _goldDark,
        ],
        stops: const [0.0, 0.3, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: sphereCenter, radius: sphereR));
    canvas.drawCircle(sphereCenter, sphereR, spherePaint);

    // Sphere outline
    canvas.drawCircle(
      sphereCenter,
      sphereR,
      Paint()
        ..color = _goldShadow.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Tiny bright specular highlight
    final specCenter = Offset(
      sphereCenter.dx - sphereR * 0.25,
      sphereCenter.dy - sphereR * 0.25,
    );
    canvas.drawCircle(
      specCenter,
      sphereR * 0.2,
      Paint()..color = Colors.white.withValues(alpha: 0.6),
    );
  }

  /// Five-pointed star emblem on the front of the cup.
  void _drawStar(Canvas canvas, double w, double h, double cx) {
    final starCenter = Offset(cx, h * 0.34);
    final outerR = w * 0.055;
    final innerR = outerR * 0.42;
    const points = 5;

    final starPath = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final r = i.isEven ? outerR : innerR;
      final x = starCenter.dx + cos(angle) * r;
      final y = starCenter.dy + sin(angle) * r;
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();

    // Star fill - bright highlight color
    canvas.drawPath(
      starPath,
      Paint()..color = _goldHighlight.withValues(alpha: 0.6),
    );

    // Star outline
    canvas.drawPath(
      starPath,
      Paint()
        ..color = _goldShadow.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
