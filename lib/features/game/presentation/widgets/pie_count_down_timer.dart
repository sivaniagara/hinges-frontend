import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// A stopwatch-style countdown indicator: the face starts fully white and,
/// as [remainingSeconds] counts down, the white area shrinks away in an
/// anti-clockwise sweep starting from 12 o'clock — revealing the solid
/// [wedgeColor] underneath. No text/label is drawn, just the wedge itself.
///
/// Usage (drop-in replacement for the old `timerCircle` Container):
///
/// ```dart
/// PieCountdownTimer(
///   remainingSeconds: state.remainingSecondsToStart.toInt(),
///   totalSeconds: 30, // whatever the full countdown duration is
///   size: 60,
/// )
/// ```
class PieCountdownTimer extends StatelessWidget {
  /// Seconds left right now.
  final int remainingSeconds;

  /// The full duration the countdown started from (used to compute the
  /// white wedge's fraction of the circle). Must be > 0.
  final int totalSeconds;

  /// Diameter of the widget.
  final double size;

  /// Color revealed underneath as the white wedge shrinks away.
  final Color wedgeColor;

  /// Color of the faint stopwatch body (ring, top button, side ticks).
  final Color faceColor;

  /// Stroke width of the outer ring.
  final double ringWidth;

  const PieCountdownTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.size = 60,
    this.wedgeColor = Colors.transparent,
    this.faceColor = AppTheme.white,
    this.ringWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = totalSeconds <= 0
        ? 0.0
        : (remainingSeconds / totalSeconds).clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      // Animates smoothly from the previous fraction to the new one every
      // time `remainingSeconds` changes (e.g. once per second from the bloc)
      // instead of jumping abruptly.
      tween: Tween<double>(begin: fraction, end: fraction),
      duration: const Duration(milliseconds: 900),
      curve: Curves.linear,
      builder: (context, animatedFraction, child) {
        return CustomPaint(
          size: Size(size, size),
          painter: _PieTimerPainter(
            fraction: animatedFraction,
            wedgeColor: wedgeColor,
            faceColor: faceColor,
            ringWidth: ringWidth,
          ),
        );
      },
    );
  }
}

class _PieTimerPainter extends CustomPainter {
  final double fraction; // 1.0 = fully white, 0.0 = fully wedgeColor
  final Color wedgeColor;
  final Color faceColor;
  final double ringWidth;

  _PieTimerPainter({
    required this.fraction,
    required this.wedgeColor,
    required this.faceColor,
    required this.ringWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Faint stopwatch body: outer ring + top button + two side "ticks",
    // matching the reference image's pale grey stopwatch silhouette.
    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    final ringPaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;

    // Top button.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, -radius * 0.05),
          width: radius * 0.6,
          height: radius * 0.22,
        ),
        Radius.circular(radius * 0.1),
      ),
      facePaint,
    );

    // Side ticks.
    for (final dx in [-1.0, 1.0]) {
      canvas.save();
      canvas.translate(center.dx + dx * radius * 0.72, radius * 0.14);
      canvas.rotate(dx * -math.pi / 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: radius * 0.4, height: radius * 0.16),
          Radius.circular(radius * 0.08),
        ),
        facePaint,
      );
      canvas.restore();
    }

    // Outer ring (the watch face outline).
    canvas.drawCircle(center, radius - ringWidth / 2, ringPaint);

    final innerRadius = radius - ringWidth;

    // Base disc: fully filled with wedgeColor. As time runs out, this is
    // what gets revealed underneath the shrinking white wedge.
    final wedgePaint = Paint()
      ..color = wedgeColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, wedgePaint);

    // The white "remaining time" wedge, starting as a full circle and
    // sweeping away anti-clockwise from 12 o'clock as `fraction` shrinks
    // toward 0 — exposing more of the wedgeColor disc underneath.
    if (fraction > 0) {
      final whitePaint = Paint()
        ..color = AppTheme.borderGold
        ..style = PaintingStyle.fill;

      const startAngle = -math.pi / 2; // 12 o'clock
      final sweepAngle = -2 * math.pi * fraction; // negative = anti-clockwise

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PieTimerPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.wedgeColor != wedgeColor ||
        oldDelegate.faceColor != faceColor ||
        oldDelegate.ringWidth != ringWidth;
  }
}