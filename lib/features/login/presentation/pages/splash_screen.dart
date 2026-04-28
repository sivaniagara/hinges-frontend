import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import '../bloc/user_auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _bgController;
  late AnimationController _particlesController;

  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _bgAnimation;

  bool _timerDone = false;
  bool _authChecked = false;

  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _initializeParticles();

    /// 🔹 Main Animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fade = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeIn,
    );

    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    /// 🔹 Background Glow Animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );

    /// 🔹 Particle Animation
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _mainController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      _timerDone = true;
      _navigateIfReady();
    });
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < 500; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 3 + 1.5,
          speedX: (random.nextDouble() - 0.5) * 0.002,
          speedY: (random.nextDouble() - 0.5) * 0.002,
          opacity: random.nextDouble() * 0.6 + 0.3,
        ),
      );
    }
  }

  void _navigateIfReady() {
    if (!_timerDone || !mounted) return;

    final state = context.read<UserAuthBloc>().state;
    print("state : ${state}");
    if (state is AuthenticatedState) {
      context.go('/loading');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bgController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAuthBloc, UserAuthState>(
      listener: (context, state) {
        _authChecked = true;
        _navigateIfReady();
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([_bgAnimation, _particlesController]),
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF023FA8),
                    const Color(0xFF010218),
                  ],
                  radius: 0.8,
                  focal: Alignment.center,
                  focalRadius: 0.2,
                ),
              ),
              child: Stack(
                children: [

                  /// 🔥 Center Glow - Clean and Premium
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.15),
                            blurRadius: 100,
                            spreadRadius: 50,
                          ),
                          BoxShadow(
                            color: const Color(0xFF60A5FA).withOpacity(0.08),
                            blurRadius: 150,
                            spreadRadius: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                  /// ✨ Golden Particles - Only in darker outer region
                  ..._buildParticleLayer(),
                  /// 🔥 MAIN UI
                  Center(
                    child: FadeTransition(
                      opacity: _fade,
                      child: ScaleTransition(
                        scale: _scale,
                        child: Stack(
                          children: [
                            Center(
                              child: Opacity(
                                opacity: 0.5,
                                child: Image.asset(
                                  AppImages.goldenRingStump,
                                  height: MediaQuery.of(context).size.height,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.indianBiddingLeague,
                                  height: 170,
                                ),
                                /// 🔥 TITLE
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: const [
                                      Color(0xFFB26D01),
                                      Color(0xFFFDFFAF),
                                      Color(0xFFB26D01),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ).createShader(bounds),
                                  child: Text(
                                    'INDIAN BIDDING LEAGUE',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.goldman(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(0, 6),
                                          blurRadius: 8,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Row(
                                  spacing: 10,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppImages.goldenStarLine,
                                      width: 50,
                                    ),
                                    ShaderMask(
                                      shaderCallback: (bounds) => LinearGradient(
                                        colors: const [
                                          Color(0xFFFDFFAF),
                                          Color(0xFFE2A509),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ).createShader(bounds),
                                      child: Text(
                                        'OWN YOUR DREAM TEAM',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.goldman(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          shadows: [
                                            Shadow(
                                              offset: const Offset(0, 6),
                                              blurRadius: 8,
                                              color: Colors.black.withOpacity(0.6),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: Image.asset(
                                        AppImages.goldenStarLine,
                                        width: 50,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  AppImages.goldenCrownLine,
                                  width: 200,
                                  height: 50,
                                ),
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: const [
                                      Color(0xFFFDFFAF),
                                      Color(0xFFE2A509),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ).createShader(bounds),
                                  child: Text(
                                    'POWERED BY HINGES GAMES',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.goldman(
                                      fontSize: 13,
                                      letterSpacing: 2,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(0, 6),
                                          blurRadius: 8,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            buildMandala(alignment: Alignment.bottomLeft),
                            buildMandala(
                              alignment: Alignment.bottomRight,
                              rotateY: math.pi,
                            ),
                            buildMandala(
                              alignment: Alignment.topLeft,
                              rotateX: math.pi,
                            ),
                            buildMandala(
                              alignment: Alignment.topRight,
                              rotateX: math.pi,
                              rotateY: math.pi,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildParticleLayer() {
    return List.generate(_particles.length, (index) {
      final particle = _particles[index];

      // Update particle position
      particle.x += particle.speedX;
      particle.y += particle.speedY;

      // Wrap around screen
      if (particle.x < 0) particle.x = 1;
      if (particle.x > 1) particle.x = 0;
      if (particle.y < 0) particle.y = 1;
      if (particle.y > 1) particle.y = 0;

      // Calculate distance from center (0.5, 0.5)
      final dx = particle.x - 0.5;
      final dy = particle.y - 0.5;
      final distanceFromCenter = math.sqrt(dx * dx + dy * dy);

      // Only show particles in outer region (distance > 0.35)
      // This ensures particles are NOT inside the clean center glow
      if (distanceFromCenter < 0.35) return const SizedBox.shrink();

      // Particles closer to center fade out smoothly
      final fadeFactor = (distanceFromCenter - 0.35) / 0.45;
      final clampedFade = fadeFactor.clamp(0.0, 1.0);

      return Positioned(
        left: particle.x * MediaQuery.of(context).size.width,
        top: particle.y * MediaQuery.of(context).size.height,
        child: AnimatedBuilder(
          animation: _particlesController,
          builder: (context, child) {
            // Twinkling effect
            final twinkle = (math.sin(_particlesController.value * math.pi * 2 * particle.size * 2) + 1) / 2;
            return Container(
              width: particle.size,
              height: particle.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD700).withOpacity(
                    particle.opacity * clampedFade * (0.6 + twinkle * 0.4)
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildMandala({
    required Alignment alignment,
    double rotateX = 0,
    double rotateY = 0,
  }) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(rotateX)..rotateY(rotateY),
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppImages.mandalaPattern,
              width: MediaQuery.of(context).size.height * 0.35,
            ),
          ),
        ),
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });
}