import 'package:flutter/material.dart';

class ScaleAnimationWidget extends StatelessWidget {
  final Widget child;
  final AnimationController controller;

  ScaleAnimationWidget({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Utilisation d'un AnimatedBuilder pour reconstruire l'enfant avec la valeur d'échelle correcte.
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) => Transform.scale(
        scale: controller.value,
        child: child,
      ),
    );
  }
}
