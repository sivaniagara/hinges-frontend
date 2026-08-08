import 'dart:math';
import 'package:flutter/material.dart';

/// 🟡 GOLDEN MANDALA PATTERN
///
/// Recreates the concentric gold-dot mandala: a glowing center disc with a
/// punched-out hole, a ring of radial "sunburst" spokes, a few clean
/// concentric dot rings, and a set of loose, sparse dotted rings fading out
/// toward the edge (the "scattered dust" look in the reference image).
///
/// Usage:
///   Positioned.fill(
///     child: IgnorePointer(
///       child: CustomPaint(painter: GoldenMandalaPainter()),
///     ),
///   )
///
/// or wrap it with the [GoldenMandala] convenience widget below.
class GoldenMandalaPainter extends CustomPainter {
  /// Base gold color. A lighter tint is derived automatically for
  /// highlights (center disc) and a faded tint for the outer dust rings.
  final Color goldColor;

  /// Overall opacity multiplier — handy if you want the whole mandala to
  /// sit subtly behind foreground content.
  final double opacity;

  /// Fixed seed so the "scattered dust" rings look the same every rebuild
  /// (set to null for a new random scatter each time).
  final int? seed;

  GoldenMandalaPainter({
    this.goldColor = const Color(0xFFFFC72C),
    this.opacity = 1.0,
    this.seed = 7,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    // Reference design was authored against a 1024x1024 canvas — scale
    // every radius/stroke relative to that so the pattern holds its
    // proportions at any size.
    final scale = size.shortestSide / 400;
    final rnd = Random(seed ?? DateTime.now().millisecondsSinceEpoch);

    double s(double v) => v * scale;

    Paint dotPaint(double a) => Paint()
      ..color = goldColor.withOpacity(a * opacity)
      ..style = PaintingStyle.fill;

    Paint linePaint(double a, double width) => Paint()
      ..color = goldColor.withOpacity(a * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s(width);

    // ---------------------------------------------------------------
    // 1) OUTER SCATTERED DUST RINGS — sparse, jittered, fading outward
    // ---------------------------------------------------------------
    // final outerRadii = [230, 255, 280, 305, 330, 358, 388, 420, 452, 484];
    // for (int ringIndex = 0; ringIndex < outerRadii.length; ringIndex++) {
    //   final baseRadius = outerRadii[ringIndex].toDouble();
    //   final t = ringIndex / (outerRadii.length - 1); // 0 (inner) -> 1 (outer)
    //   final count = (34 + ringIndex * 5);
    //   final dotR = s(4.2 - t * 2.2).clamp(1.0, 6.0);
    //   final ringOpacity = (0.85 - t * 0.65).clamp(0.08, 1.0);
    //   final startAngle = rnd.nextDouble() * pi * 2;
    //
    //   for (int i = 0; i < count; i++) {
    //     // Randomly skip dots so the ring reads as loose/broken, not a
    //     // perfect circle — more gaps further out.
    //     if (rnd.nextDouble() < 0.18 + t * 0.22) continue;
    //
    //     final angle = startAngle + (2 * pi / count) * i;
    //     final jitter = (rnd.nextDouble() - 0.5) * s(10 + t * 14);
    //     final r = baseRadius * scale + jitter;
    //     final dx = center.dx + r * cos(angle);
    //     final dy = center.dy + r * sin(angle);
    //
    //     final sizeJitter = 0.6 + rnd.nextDouble() * 0.7;
    //     canvas.drawCircle(
    //       Offset(dx, dy),
    //       dotR * sizeJitter,
    //       dotPaint(ringOpacity * (0.7 + rnd.nextDouble() * 0.3)),
    //     );
    //   }
    // }

    // ---------------------------------------------------------------
    // 2) CLEAN INNER DOT RINGS + THIN OUTLINE CIRCLES
    // ---------------------------------------------------------------
    // thin plain ring
    canvas.drawCircle(center, s(205), linePaint(0.35, 1.0));

    _dotRing(canvas, center, s(185), 40, s(3.0), dotPaint(0.75));

    canvas.drawCircle(center, s(165), linePaint(0.4, 1.0));

    _dotRing(canvas, center, s(148), 16, s(5.2), dotPaint(0.9)); // big evenly spaced dots

    _dotRing(canvas, center, s(128), 32, s(2.6), dotPaint(0.8));

    canvas.drawCircle(center, s(112), linePaint(0.45, 1.0));

    // ---------------------------------------------------------------
    // 3) RADIAL SUNBURST SPOKES (with dot tips) + inner dashed dot ring
    // ---------------------------------------------------------------
    _spokes(
      canvas,
      center,
      innerR: s(58),
      outerR: s(92),
      count: 16,
      linePaint: linePaint(0.8, 1.6),
      dotRadius: s(4.0),
      dotPaint: dotPaint(0.95),
    );

    _dotRing(canvas, center, s(45), 20, s(2.0), dotPaint(0.85));

    // ---------------------------------------------------------------
    // 4) CENTER GLOWING DISC WITH PUNCHED HOLE
    // ---------------------------------------------------------------
    final centerRadius = s(34);
    // final glowPaint = Paint()
    //   ..shader = RadialGradient(
    //     colors: [
    //       goldColor.withOpacity(1.0 * opacity),
    //       goldColor.withOpacity(0.0),
    //     ],
    //   ).createShader(
    //     Rect.fromCircle(center: center, radius: centerRadius * 1.8),
    //   );
    // canvas.drawCircle(center, centerRadius * 1.8, glowPaint);

    final discPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(goldColor, Colors.white, 0.35)!.withOpacity(opacity),
          goldColor.withOpacity(opacity),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: centerRadius));
    canvas.drawCircle(center, centerRadius, discPaint);

    // punched-out hole in the middle
    canvas.drawCircle(
      center,
      s(9),
      Paint()..color = Colors.white.withOpacity(opacity),
    );
  }

  void _dotRing(
      Canvas canvas,
      Offset center,
      double radius,
      int count,
      double dotRadius,
      Paint paint,
      ) {
    for (int i = 0; i < count; i++) {
      final angle = (2 * pi / count) * i;
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
    }
  }

  void _spokes(
      Canvas canvas,
      Offset center, {
        required double innerR,
        required double outerR,
        required int count,
        required Paint linePaint,
        required double dotRadius,
        required Paint dotPaint,
      }) {
    for (int i = 0; i < count; i++) {
      final angle = (2 * pi / count) * i;
      final start = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      final end = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );
      canvas.drawLine(start, end, linePaint);
      canvas.drawCircle(end, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GoldenMandalaPainter oldDelegate) {
    return oldDelegate.goldColor != goldColor ||
        oldDelegate.opacity != opacity ||
        oldDelegate.seed != seed;
  }
}

/// Convenience widget — sizes itself to fill its parent and ignores
/// pointer events, so it's safe to drop behind other UI.
class GoldenMandala extends StatelessWidget {
  final Color goldColor;
  final double opacity;
  final int? seed;

  const GoldenMandala({
    super.key,
    this.goldColor = const Color(0xFFFFC72C),
    this.opacity = 1.0,
    this.seed = 7,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: GoldenMandalaPainter(
          goldColor: goldColor,
          opacity: opacity,
          seed: seed,
        ),
        size: Size.infinite,
      ),
    );
  }
}