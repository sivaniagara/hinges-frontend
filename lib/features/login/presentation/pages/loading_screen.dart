import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_images.dart';
import '../widgets/mandala_background.dart';
import '../widgets/shared_decorations.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;

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
      duration: const Duration(milliseconds: 1000),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _scale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

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
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MandalaBackground(
        animateContent: false,
        child: Stack(
          children: [
            const GoldenRingBackground(),

            /// 🌟 CENTER CONTENT
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// 🔁 ROTATING TEAM CIRCLE
                      FranchiseCircle(),

                      /// 🟡 GOLD PROGRESS BAR (LIKE YOUR IMAGE)
                      _buildGoldenProgressBar(),


                      /// ✨ TEXT
                      const GoldenTitle(
                        title: 'CONNECTING TO THE ARENA...',
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// ✨ CORNER DECORATIONS (same as login)
            const MandalaDecoration(alignment: Alignment.bottomLeft),
            const MandalaDecoration(
              alignment: Alignment.bottomRight,
              rotateY: math.pi,
            ),
            const MandalaDecoration(
              alignment: Alignment.topLeft,
              rotateX: math.pi,
            ),
            const MandalaDecoration(
              alignment: Alignment.topRight,
              rotateX: math.pi,
              rotateY: math.pi,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 PREMIUM GOLD PROGRESS BAR
  Widget _buildGoldenProgressBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFD4AF37), width: 1.2),
        color: Colors.black.withOpacity(0.4),
      ),
      child: Stack(
        children: [
          /// 🔥 Animated Fill
          FractionallySizedBox(
            widthFactor: _progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFB8962E),
                    Color(0xFFFFE082),
                    Color(0xFFB8962E),
                  ],
                ),
              ),
            ),
          ),

          /// ✨ SHIMMER EFFECT
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) {
                return Opacity(
                  opacity: 0.4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment(-1 + _pulseController.value * 2, 0),
                        end: Alignment(1 + _pulseController.value * 2, 0),
                        colors: const [
                          Colors.transparent,
                          Colors.white,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FranchiseCircle extends StatelessWidget {
  const FranchiseCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final logos = [
      AppImages.miLogo,
      AppImages.cskLogo,
      AppImages.kkrLogo,
      AppImages.rcbLogo,
      AppImages.pkLogo,
      AppImages.srhLogo,
      AppImages.rrLogo,
      AppImages.gtLogo,
      AppImages.lsgLogo,
      AppImages.dcLogo,
    ];

    const double radius = 100;
    const double size = 55;

    final double containerSize = radius * 3;
    final double center = containerSize / 2;

    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: Stack(
        children: [
          ...List.generate(logos.length, (index) {
            final angle = (2 * math.pi / logos.length) * index;

            final dx = center + radius * math.cos(angle) - size / 2;
            final dy = center + radius * math.sin(angle) - size / 2;

            return Positioned(
              left: dx,
              top: dy,
              child: ClipOval(
                child: Image.asset(
                  logos[index],
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
          Center(
            child: Image.asset(
              AppImages.indianBiddingLeague,
              height: 100,
            ),
          )
        ],
      ),
    );
  }
}