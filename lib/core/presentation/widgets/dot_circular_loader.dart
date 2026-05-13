import 'dart:math';
import 'package:flutter/material.dart';

class DotCircleLoader extends StatefulWidget {
  const DotCircleLoader({super.key});

  @override
  State<DotCircleLoader> createState() => _DotCircleLoaderState();
}

class _DotCircleLoaderState extends State<DotCircleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: controller,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: List.generate(12, (index) {
            final angle = (2 * pi / 12) * index;
            return Positioned(
              left: 20 + 14 * cos(angle) - 3,
              top: 20 + 14 * sin(angle) - 3,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(index / 12),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}