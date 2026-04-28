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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

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

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _fadeController.forward();
    _startLoading();
  }

  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_progress < 1.0) {
        setState(() => _progress += 0.008);
      } else {
        _timer?.cancel();
        if (mounted) context.go('/home');
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
            /// 🔥 EDGE LOGOS
            _buildEdgeLogos(),

            /// 🔥 CENTER CONTENT
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCenterLogo(),

                      /// PROGRESS BAR
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
                      Text(
                        'POWERED BY HINGES GAMES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 EDGE LOGO LAYOUT (CORNERS + SIDES)
  Widget _buildEdgeLogos() {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        const size = 60.0;
        const padding = 20.0;

        /// 📐 Define positions clearly (3 top, 3 bottom, 2 left, 2 right)
        final positions = [
          /// 🔝 TOP (3)
          Offset(w * 0.2 - size / 2, padding),
          Offset(w * 0.5 - size / 2, padding),
          Offset(w * 0.8 - size / 2, padding),

          /// 🔻 BOTTOM (3)
          Offset(w * 0.2 - size / 2, h - size - padding),
          Offset(w * 0.5 - size / 2, h - size - padding),
          Offset(w * 0.8 - size / 2, h - size - padding),

          /// ◀ LEFT (2)
          Offset(padding, h * 0.35 - size / 2),
          Offset(padding, h * 0.7 - size / 2),

          /// ▶ RIGHT (2)
          Offset(w - size - padding, h * 0.35 - size / 2),
          Offset(w - size - padding, h * 0.7 - size / 2),
        ];

        return Stack(
          children: List.generate(logos.length, (index) {
            return Positioned(
              left: positions[index].dx,
              top: positions[index].dy,
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (_, __) {
                  return Transform.translate(
                    offset: Offset(
                      Math.sin(_rotationController.value * 2 * Math.pi + index) * 3,
                      Math.cos(_rotationController.value * 2 * Math.pi + index) * 3,
                    ),
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        logos[index],
                        width: size,
                        height: size,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }

  /// 🔥 CENTER LOGO
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
}