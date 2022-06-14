import 'package:flutter/material.dart';

class AnimatedShit extends AnimatedWidget {

  const AnimatedShit({
    super.key,
    required Animation<double> animation,
    required this.child
  }): super(listenable: animation);

  static final _angleTween = Tween<double>(begin: 0, end: 3.14);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.rotate(
      angle: _angleTween.evaluate(animation),
      child:
        Transform.translate(
          offset: const Offset(80, 0),
          child: child,
        )
    );
  }
}