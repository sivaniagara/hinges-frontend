import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hinges_frontend/features/login/presentation/widgets/golden_mandala_painter.dart';

import 'golden_dot_circle.dart';

class MandalaBackground extends StatefulWidget {
  final Widget child;
  final bool animateContent;
  final bool showParticle;
  final Color backGroundColor;

  const MandalaBackground({
    super.key,
    required this.child,
    this.animateContent = true,
    this.showParticle = true,
    this.backGroundColor = const Color(0xff012255),
  });

  @override
  State<MandalaBackground> createState() => _MandalaBackgroundState();
}

class _MandalaBackgroundState extends State<MandalaBackground>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _particlesController;
  late Animation<double> _bgAnimation;

  late List<Particle> _particles;

  AnimationController? _mainController;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _initializeParticles();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );

    /// Only for twinkle (NOT movement)
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    if (widget.animateContent) {
      _mainController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      );

      _fade = CurvedAnimation(
        parent: _mainController!,
        curve: Curves.easeIn,
      );

      _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(
          parent: _mainController!,
          curve: Curves.easeOutBack,
        ),
      );

      _mainController!.forward();
    }
  }

  void _initializeParticles() {
    _particles = [];
    final random = math.Random();

    for (int i = 0; i < 80; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 3 + 1.5,
          opacity: random.nextDouble() * 0.6 + 0.3,
        ),
      );
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _particlesController.dispose();
    _mainController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_bgAnimation, _particlesController]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: widget.backGroundColor,
            // gradient: widget.showParticle ? RadialGradient(
            //   colors: [
            //     Color(0xFF023FA8),
            //     // Color(0xFF023FA8),
            //     Color(0xFF010218),
            //   ],
            //   radius: 0.8,
            //   focal: Alignment.center,
            //   focalRadius: 0.2,
            // ) : null,
          ),
          child: Stack(
            children: [
              /// Center Glow
              // Center(
              //   child: Container(
              //     width: MediaQuery.of(context).size.width * 0.5,
              //     height: MediaQuery.of(context).size.height * 0.5,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Color(0xFF3B82F6).withOpacity(0.15),
              //           blurRadius: 100,
              //           spreadRadius: 50,
              //         ),
              //         BoxShadow(
              //           color: Color(0xFF60A5FA).withOpacity(0.08),
              //           blurRadius: 150,
              //           spreadRadius: 80,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              if(widget.showParticle)
              ...[
                Positioned(
                  left: 0,
                  top: 40,
                  child: SizedBox(
                      width: 120,
                      height: 120,
                      child: getMandala()
                  ),
                ),
                Positioned(
                  left: -10,
                  top: 155,
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: getMandala()
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 40,
                  child: SizedBox(
                      width: 120,
                      height: 120,
                      child: getMandala()
                  ),
                ),
                Positioned(
                  right: -10,
                  bottom: 155,
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: getMandala()
                  ),
                ),

                Positioned.fill(
                  child: goldenDotCircle(500),
                ),
                Positioned.fill(
                  child: goldenDotCircle(450),
                ),
              ],


              /// Static Golden Particles (with twinkle)
              // if(widget.showParticle)
              //   ..._buildParticleLayer(context),
              /// Content
              if (widget.animateContent && _mainController != null)
                Center(
                  child: FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: widget.child,
                    ),
                  ),
                )
              else
                Center(child: widget.child),
            ],
          ),
        );
      },
    );
  }

  Widget getMandala() {
    return Opacity(
        opacity: 0.5,
        child: GoldenMandala(seed: 1)
    );
  }

  Widget goldenDotCircle(double diameter) {
    return Opacity(
      opacity: 0.3,
      child: Center(
        child: OverflowBox(
          maxWidth: diameter,
          maxHeight: diameter,
          child: GoldenDotCircle(
            diameter: diameter,
            dotCount: 200,
            dotRadius: 1,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildParticleLayer(BuildContext context) {
    return List.generate(_particles.length, (index) {
      final particle = _particles[index];

      final dx = particle.x - 0.5;
      final dy = particle.y - 0.5;
      final distanceFromCenter = math.sqrt(dx * dx + dy * dy);

      /// Keep center clean
      if (distanceFromCenter < 0.35) return const SizedBox.shrink();

      final fadeFactor = (distanceFromCenter - 0.35) / 0.45;
      final clampedFade = fadeFactor.clamp(0.0, 1.0);

      return Positioned(
        left: particle.x * MediaQuery.of(context).size.width,
        top: particle.y * MediaQuery.of(context).size.height,
        child: CustomPaint(
          size: Size(particle.size * 2, particle.size * 2),
          painter: StarPainter(
            color: const Color(0xFFFFD700).withOpacity(
              (particle.opacity * clampedFade + 0.5).clamp(0.0, 1.0),
            ),
          ),
        ),
      );
    });
  }
}



class Particle {
  double x;
  double y;
  double size;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
  });
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4;
    const points = 4;

    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (math.pi / points) * i - math.pi / 2;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = cx + radius * math.cos(angle);
      final y = cy + radius * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => oldDelegate.color != color;
}