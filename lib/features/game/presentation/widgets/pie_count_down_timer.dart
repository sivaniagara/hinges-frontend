import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class PieCountdownTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final double size;
  final Color wedgeColor;
  final Color faceColor;
  final double ringWidth;

  const PieCountdownTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.size = 40,
    this.wedgeColor = Colors.transparent,
    this.faceColor = AppTheme.white,
    this.ringWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = totalSeconds <= 0
        ? 0.0
        : (remainingSeconds / totalSeconds).clamp(0.0, 1.0);

    final isUrgent = remainingSeconds <= 3 && remainingSeconds > 0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: fraction, end: fraction),
      duration: const Duration(milliseconds: 1000),
      // curve: Curves.easeOutCubic, // smoother than linear, feels premium
      curve: Curves.linear, // smoother than linear, feels premium
      builder: (context, animatedFraction, child) {
        final timer = CustomPaint(
          size: Size(size, size),
          painter: _PieTimerPainter(
            fraction: animatedFraction,
            wedgeColor: wedgeColor,
            faceColor: faceColor,
            ringWidth: ringWidth,
          ),
        );

        if (!isUrgent) return timer;

        // Gentle pulse when time is nearly up — draws the eye without
        // being obnoxious.
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.94, end: 1.06),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
          builder: (context, scale, _) => Transform.scale(
            scale: scale,
            child: timer,
          ),
          onEnd: () {}, // repeats naturally as remainingSeconds keeps changing
        );
      },
    );
  }
}

class _PieTimerPainter extends CustomPainter {
  final double fraction;
  final Color wedgeColor;
  final Color faceColor;
  final double ringWidth;

  _PieTimerPainter({
    required this.fraction,
    required this.wedgeColor,
    required this.faceColor,
    required this.ringWidth,
  });

  /// Shifts the wedge color from gold -> amber -> red as fraction drops,
  /// so the timer visually communicates urgency, not just numerically.
  Color _urgencyColor(double fraction) {
    const gold = AppTheme.borderGold;
    const amber = Color(0xFFFFA726);
    const red = Color(0xFFEF5350);

    if (fraction > 0.5) {
      // gold -> amber over the 100%..50% range
      final t = (1 - fraction) / 0.5;
      return Color.lerp(gold, amber, t)!;
    } else {
      // amber -> red over the 50%..0% range
      final t = (0.5 - fraction) / 0.5;
      return Color.lerp(amber, red, t)!;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius - ringWidth;
    final activeColor = _urgencyColor(fraction);

    // --- Soft glow behind the whole disc -----------------------------
    // Blurred colored circle sitting *underneath* everything else. This
    // is what makes the widget pop against a dark background like
    // 0xFF012255 instead of looking flat / pasted on.
    final glowPaint = Paint()
      ..color = activeColor.withOpacity(0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, innerRadius * 0.95, glowPaint);

    // --- Faint stopwatch body (ring, button, ticks) -------------------
    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    final ringPaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;

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

    canvas.drawCircle(center, radius - ringWidth / 2, ringPaint);

    // --- Base disc (revealed as the wedge shrinks) --------------------
    final wedgePaint = Paint()
      ..color = wedgeColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, wedgePaint);

    // --- The countdown wedge, now with a sweep gradient ---------------
    if (fraction > 0) {
      final gradient = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: GradientRotation(-math.pi / 2), // align with 12 o'clock
        colors: [
          activeColor.withOpacity(1.0),
          Color.lerp(activeColor, Colors.white, 0.35)!,
          activeColor.withOpacity(1.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      );

      final wedgeFillPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: innerRadius),
        )
        ..style = PaintingStyle.fill;

      const startAngle = -math.pi / 2;
      final sweepAngle = -2 * math.pi * fraction;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, wedgeFillPaint);

      // Thin bright edge along the leading edge of the wedge for a
      // "glass rim" highlight.
      final edgeAngle = startAngle + sweepAngle;
      final edgePoint = Offset(
        center.dx + innerRadius * math.cos(edgeAngle),
        center.dy + innerRadius * math.sin(edgeAngle),
      );
      final edgePaint = Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawLine(center, edgePoint, edgePaint);
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