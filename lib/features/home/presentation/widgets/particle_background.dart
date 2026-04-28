import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int particleCount = 150;
  final Random random = Random();

  late List<Offset> positions;
  late List<double> sizes;
  late List<double> speeds;
  late List<double> opacities;
  late List<Color> colors;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    positions = List.generate(
      particleCount,
          (_) => Offset(random.nextDouble(), random.nextDouble()),
    );

    sizes = List.generate(
      particleCount,
          (_) => random.nextDouble() * 3.0 + 0.5,
    );

    speeds = List.generate(
      particleCount,
          (_) => random.nextDouble() * 60 + 20,
    );

    opacities = List.generate(
      particleCount,
          (_) => random.nextDouble() * 0.7 + 0.2,
    );

    colors = List.generate(
      particleCount,
          (_) {
        final colorType = random.nextInt(100);
        if (colorType < 70) {
          return Colors.white;
        } else if (colorType < 85) {
          return Colors.blue[300]!;
        } else {
          return Colors.cyan[200]!;
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: _SpaceParticlePainter(
              positions,
              sizes,
              speeds,
              opacities,
              colors,
              _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _SpaceParticlePainter extends CustomPainter {
  final List<Offset> positions;
  final List<double> sizes;
  final List<double> speeds;
  final List<double> opacities;
  final List<Color> colors;
  final double animationValue;

  _SpaceParticlePainter(
      this.positions,
      this.sizes,
      this.speeds,
      this.opacities,
      this.colors,
      this.animationValue,
      );

  void _drawGlow(Canvas canvas, Offset center, double radius, Paint paint) {
    for (int i = 3; i > 0; i--) {
      final glowPaint = Paint()
        ..color = paint.color.withOpacity(paint.color.opacity * (0.3 / i))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * i);

      canvas.drawCircle(center, radius * (1 + i * 0.5), glowPaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Sort particles by size to draw smaller ones first (depth effect)
    List<int> indices = List.generate(positions.length, (i) => i);
    indices.sort((a, b) => sizes[a].compareTo(sizes[b]));

    for (int i in indices) {
      final dx = positions[i].dx * size.width;

      // Slower movement for larger particles (parallax effect)
      final speedMultiplier = sizes[i] > 2.0 ? 0.3 : (sizes[i] > 1.0 ? 0.6 : 1.0);
      final dy = (positions[i].dy * size.height +
          animationValue * speeds[i] * speedMultiplier) %
          size.height;

      final size_particle = sizes[i];
      final isStar = size_particle > 1.8;
      final isTwinkle = size_particle > 2.5;

      // Twinkling effect for big stars
      double opacity = opacities[i];
      if (isTwinkle) {
        final twinkle = (sin(animationValue * 8 * size_particle) + 1) / 2;
        opacity = opacities[i] * (0.5 + twinkle * 0.5);
      }

      // Gradient for bigger particles
      if (isStar) {
        final radialGradient = RadialGradient(
          center: Alignment.center,
          radius: 0.5,
          colors: [
            colors[i].withOpacity(opacity),
            colors[i].withOpacity(opacity * 0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        );

        final paint = Paint()..shader = radialGradient.createShader(
            Rect.fromCircle(center: Offset(dx, dy), radius: size_particle)
        );

        canvas.drawCircle(Offset(dx, dy), size_particle, paint);

        // Star cross effect for very bright stars
        if (size_particle > 2.8 && opacity > 0.6) {
          final crossPaint = Paint()
            ..color = colors[i].withOpacity(opacity * 0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

          final crossLength = size_particle * 1.5;
          canvas.drawLine(
            Offset(dx - crossLength, dy),
            Offset(dx + crossLength, dy),
            crossPaint,
          );
          canvas.drawLine(
            Offset(dx, dy - crossLength),
            Offset(dx, dy + crossLength),
            crossPaint,
          );
        }
      } else {
        // Small dust particles
        final paint = Paint()
          ..color = colors[i].withOpacity(opacity * 0.4)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, size_particle * 0.8);

        canvas.drawCircle(Offset(dx, dy), size_particle * 0.6, paint);
      }

      // Tiny highlight for all particles
      if (size_particle > 1.0) {
        final highlightPaint = Paint()
          ..color = Colors.white.withOpacity(opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

        canvas.drawCircle(
          Offset(dx - size_particle * 0.2, dy - size_particle * 0.2),
          size_particle * 0.2,
          highlightPaint,
        );
      }
    }

    // Add a very subtle nebula effect
    _drawNebulaEffect(canvas, size);
  }

  void _drawNebulaEffect(Canvas canvas, Size size) {
    final nebulaPaint = Paint()
      ..color = Colors.blue.withOpacity(0.03)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      size.width * 0.3,
      nebulaPaint,
    );

    final nebulaPaint2 = Paint()
      ..color = Colors.purple.withOpacity(0.02)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      size.width * 0.35,
      nebulaPaint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}