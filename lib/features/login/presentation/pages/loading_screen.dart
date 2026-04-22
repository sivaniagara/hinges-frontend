import 'dart:async';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_images.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _rotationController;

  late Animation<double> _fade;
  late Animation<double> _scale;

  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    /// Lock landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    /// Fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _scale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    /// Rotation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _fadeController.forward();

    _startLoading();
  }

  /// 🔥 ORIGINAL LOADING LOGIC
  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_progress < 1.0) {
        setState(() {
          _progress += 0.008;
        });
      } else {
        _timer?.cancel();
        if (mounted) {
          context.go('/home');
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).toInt();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF020617)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            /// 🌌 PARTICLES BACKGROUND
            _buildParticles(),

            /// 🔹 MAIN CONTENT
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFranchiseCircle(),
                      const SizedBox(height: 10),

                      /// ⚡ SHIMMER PROGRESS BAR
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              colors: [
                                Colors.amber,
                                Colors.white,
                                Colors.amber,
                              ],
                              stops: [
                                (_progress - 0.2).clamp(0.0, 1.0),
                                _progress,
                                (_progress + 0.2).clamp(0.0, 1.0),
                              ],
                            ).createShader(rect);
                          },
                          child: LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: Colors.white10,
                            valueColor:
                            const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🔹 PERCENT
                      Text(
                        '$percent%',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// 🔹 FOOTER
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: const [
                  Text(
                    'POWERED BY',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'HINGES GAMES',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🌌 PARTICLES
  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (_, __) {
        return CustomPaint(
          painter: ParticlePainter(_rotationController.value),
          size: Size.infinite,
        );
      },
    );
  }

  /// 🔄 FRANCHISE CIRCLE
  Widget _buildFranchiseCircle() {
    final logos = [
      AppImages.cskLogo,
      AppImages.miLogo,
      AppImages.rcbLogo,
      AppImages.rrLogo,
      AppImages.lsgLogo,
      AppImages.gtLogo,
      AppImages.dcLogo,
      AppImages.pkLogo,
      AppImages.kkrLogo,
      AppImages.srhLogo,
    ];

    const radius = 100.0;

    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// ROTATING ORBIT
          AnimatedBuilder(
            animation: _rotationController,
            builder: (_, __) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * Math.pi,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    for (int i = 0; i < logos.length; i++)
                      _buildCircleItem(i, radius, logos),
                  ],
                ),
              );
            },
          ),

          /// 🔥 CENTER LOGO (PULSE)
          _buildCenterLogo(),
        ],
      ),
    );
  }

  Widget _buildCenterLogo() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (_, __) {
        double scale =
            1 + (Math.sin(_rotationController.value * 2 * Math.pi) * 0.05);

        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.4),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Image.asset(
              AppImages.indianBiddingLeague,
              height: 100,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircleItem(int index, double radius, List<String> logos) {
    final angle = (index * 2 * Math.pi) / logos.length;

    return Transform.translate(
      offset: Offset(
        radius * Math.cos(angle),
        radius * Math.sin(angle),
      ),
      child: Transform.rotate(
        angle: -_rotationController.value * 2 * Math.pi,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8),
            ],
          ),
          child: Image.asset(
            logos[index],
            height: 36,
            width: 36,
          ),
        ),
      ),
    );
  }
}

/// 🌌 PARTICLE PAINTER
class ParticlePainter extends CustomPainter {
  final double progress;

  ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08);

    final random = Math.Random(1);

    for (int i = 0; i < 60; i++) {
      final x = (random.nextDouble() * size.width + progress * 50) %
          size.width;
      final y = random.nextDouble() * size.height;

      canvas.drawCircle(
        Offset(x, y),
        random.nextDouble() * 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}