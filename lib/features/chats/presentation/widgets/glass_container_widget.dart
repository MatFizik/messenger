import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainerWidget extends StatelessWidget {
  final Widget child;
  final double radius;

  const GlassContainerWidget({
    super.key,
    required this.child,
    this.radius = 25,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
