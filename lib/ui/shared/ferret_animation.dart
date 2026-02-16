import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Interactive ferret mascot.
///
/// Idle: ferretWithArms.png with breathing animation.
/// Scrolling: swaps to push image (mirrored by direction).
///
/// Control via GlobalKey<FerretAnimationState>:
///   setDirection(double) — call on pointer move
///   resetDirection()     — call on pointer up (springs back)
///   bounce()             — call on date tap
class FerretAnimation extends StatefulWidget {
  final double width;
  final double height;

  const FerretAnimation({
    super.key,
    this.width = 80,
    this.height = 110,
  });

  @override
  State<FerretAnimation> createState() => FerretAnimationState();
}

class FerretAnimationState extends State<FerretAnimation>
    with TickerProviderStateMixin {
  double _direction = 0.0;
  double _lastNonZeroDir = -1.0;

  late AnimationController _idleController;
  late Animation<double> _breathAnim;
  late Animation<double> _swayAnim;

  late AnimationController _springController;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  final _pushImage = const AssetImage('assets/images/ferret_push_right.png');

  @override
  void initState() {
    super.initState();

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _breathAnim = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
    _swayAnim = Tween<double>(begin: -0.012, end: 0.012).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _springController.addListener(() {
      setState(() => _direction = _springController.value);
    });

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -3.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 12,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -3.0, end: -18.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -18.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.0),
        weight: 23,
      ),
    ]).animate(_bounceController);
  }

  void setDirection(double value) {
    if (_springController.isAnimating) _springController.stop();
    final clamped = value.clamp(-1.0, 1.0);
    if (clamped.abs() > 0.05) _lastNonZeroDir = clamped;
    setState(() => _direction = clamped);
  }

  void resetDirection() {
    final spring =
        SpringDescription(mass: 1.0, stiffness: 200.0, damping: 14.0);
    _springController.animateWith(
      SpringSimulation(spring, _direction, 0.0, 0.0),
    );
  }

  void bounce() => _bounceController.forward(from: 0);

  @override
  void dispose() {
    _idleController.dispose();
    _springController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_idleController, _bounceController]),
      builder: (context, _) {
        final isJumping = _bounceController.isAnimating;
        final bounceY = _bounceAnim.value;

        final stretchY = isJumping
            ? 1.0 + (bounceY.abs() / 100.0)
            : _breathAnim.value;
        final squashX =
            isJumping ? 1.0 - (bounceY.abs() / 200.0) : 1.0;

        // Use last known direction to keep facing that way when idle
        final facing = _direction.abs() > 0.05
            ? _direction
            : _lastNonZeroDir;
        final flipX = facing < 0 ? -1.0 : 1.0;

        return Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..translate(0.0, bounceY)
            ..rotateZ(isJumping ? 0.0 : _swayAnim.value)
            ..scale(squashX, stretchY),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(flipX, 1.0),
              child: Image(
                image: _pushImage,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
