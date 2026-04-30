import 'dart:math' as math;
import 'package:flutter/material.dart';

class MandalaBackground extends StatefulWidget {
  final Widget child;
  final bool animateContent;

  const MandalaBackground({
    super.key,
    required this.child,
    this.animateContent = true,
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

    for (int i = 0; i < 500; i++) {
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
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF023FA8),
                Color(0xFF010218),
              ],
              radius: 0.8,
              focal: Alignment.center,
              focalRadius: 0.2,
            ),
          ),
          child: Stack(
            children: [
              /// Center Glow
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF3B82F6).withOpacity(0.15),
                        blurRadius: 100,
                        spreadRadius: 50,
                      ),
                      BoxShadow(
                        color: Color(0xFF60A5FA).withOpacity(0.08),
                        blurRadius: 150,
                        spreadRadius: 80,
                      ),
                    ],
                  ),
                ),
              ),

              /// Static Golden Particles (with twinkle)
              ..._buildParticleLayer(context),

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
        child: AnimatedBuilder(
          animation: _particlesController,
          builder: (context, child) {
            final twinkle =
                (math.sin(_particlesController.value * math.pi * 2 * particle.size * 2) + 1) / 2;

            return Container(
              width: particle.size,
              height: particle.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD700).withOpacity(
                  particle.opacity * clampedFade * (0.6 + twinkle * 0.4),
                ),
              ),
            );
          },
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