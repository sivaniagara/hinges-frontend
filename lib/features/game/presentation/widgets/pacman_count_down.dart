import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PacmanCountdown extends StatelessWidget {
  final int remaining;
  final int total;

  const PacmanCountdown({
    super.key,
    required this.remaining,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (remaining / total).clamp(0.0, 1.0);

    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(50, 50),
            painter: TimerPainter(progress: progress),
          ),
        ],
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;

  const TimerPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 3;

    final background = Paint()
      ..color = Colors.white54
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final foreground = Paint()
      ..color = Colors.orange
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Background circle
    canvas.drawCircle(center, radius, background);

    // Clockwise countdown arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at top (12 o'clock)
      -2 * pi * progress, // Negative = clockwise
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant TimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}