import 'dart:math';
import 'package:flutter/material.dart';

/// 🟡 GOLDEN DOT CIRCLE
///
/// A single ring of evenly spaced gold dots.
///
/// Usage:
///   GoldenDotCircle(
///     diameter: 200,
///     dotCount: 24,
///     dotRadius: 3,
///   )
class GoldenDotCircle extends StatelessWidget {
  final double diameter;
  final int dotCount;
  final double dotRadius;
  final Color color;

  const GoldenDotCircle({
    super.key,
    this.diameter = 200,
    this.dotCount = 24,
    this.dotRadius = 4,
    this.color = const Color(0xFFFFC72C),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: CustomPaint(
        painter: _GoldenDotCirclePainter(
          dotCount: dotCount,
          dotRadius: dotRadius,
          color: color,
        ),
      ),
    );
  }
}

class _GoldenDotCirclePainter extends CustomPainter {
  final int dotCount;
  final double dotRadius;
  final Color color;

  _GoldenDotCirclePainter({
    required this.dotCount,
    required this.dotRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - dotRadius;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * pi / dotCount) * i;
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GoldenDotCirclePainter oldDelegate) {
    return oldDelegate.dotCount != dotCount ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.color != color;
  }
}