import 'package:flutter/cupertino.dart';

import 'cagar.dart';

class Shit extends StatefulWidget {
  const Shit({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  _Shit createState() => _Shit(child: child);
}

class _Shit extends State<Shit> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  Widget child;

  _Shit({required Widget this.child});

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedShit(animation: animation, child: child);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}