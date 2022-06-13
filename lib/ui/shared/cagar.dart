import 'package:flutter/material.dart';

class Cagar extends StatelessWidget {
  const Cagar({
    super.key,
    required this.child
  });

  final double angle = -3.14 / 12.0;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child:
        Transform.translate(
          offset: const Offset(80, 0),
          child: child,
        )
    );
  }
}