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
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
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
            // const GoldenRingBackground(),

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
                      GoldenSubtitle(
                        title: 'CONNECTING TO THE ARENA...',
                        fontSize: 14,
                        fontColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// ✨ CORNER DECORATIONS (same as login)
            // const MandalaDecoration(alignment: Alignment.bottomLeft),
            // const MandalaDecoration(
            //   alignment: Alignment.bottomRight,
            //   rotateY: math.pi,
            // ),
            // const MandalaDecoration(
            //   alignment: Alignment.topLeft,
            //   rotateX: math.pi,
            // ),
            // const MandalaDecoration(
            //   alignment: Alignment.topRight,
            //   rotateX: math.pi,
            //   rotateY: math.pi,
            // ),
          ],
        ),
      ),
    );
  }

  /// 🔥 PREMIUM GOLD PROGRESS BAR
  Widget _buildGoldenProgressBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 18,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
        color: const Color(0xFF0F5C8F),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            /// 🔥 Animated Gold Fill with Glow
            FractionallySizedBox(
              widthFactor: _progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF06162E),
                      Color(0xFF06162E),
                      Color(0xFF0A2548),
                      Color(0xFF06162E),
                      Color(0xFF06162E),
                    ],
                    stops: [0.0, 0.2, 0.5, 0.75, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            /// ✨ Shimmer Sweep
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (_, __) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment(-1.5 + _pulseController.value * 3, 0),
                        end: Alignment(-0.5 + _pulseController.value * 3, 0),
                        colors: const [
                          Colors.transparent,
                          Color(0x55FFFFFF),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// 💡 Top Highlight (glass effect)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 7,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// 🔴 Leading Edge Glow Dot
            // if (_progress > 0.03)
            //   Positioned(
            //     top: 0,
            //     bottom: 0,
            //     left: (MediaQuery.of(context).size.width * 0.45 - 2) * _progress - 6,
            //     child: Center(
            //       child: AnimatedBuilder(
            //         animation: _pulseController,
            //         builder: (_, __) {
            //           final pulse = (math.sin(_pulseController.value * math.pi * 2) + 1) / 2;
            //           return Container(
            //             width: 10,
            //             height: 10,
            //             decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               color: Colors.white,
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: const Color(0xFFFFD700).withOpacity(0.6 + pulse * 0.4),
            //                   blurRadius: 8 + pulse * 6,
            //                   spreadRadius: 2,
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

}

class FranchiseCircle extends StatelessWidget {
  const FranchiseCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final leftLogos = [
      AppImages.miLogo,
      AppImages.cskLogo,
      AppImages.kkrLogo,
      AppImages.rcbLogo,
      AppImages.pkLogo,
    ];

    final rightLogos = [
      AppImages.srhLogo,
      AppImages.rrLogo,
      AppImages.gtLogo,
      AppImages.lsgLogo,
      AppImages.dcLogo,
    ];

    const double logoSize = 60;
    const double containerW = 580;
    const double containerH = 260;

    /// LEFT: Diamond/chevron shape — alternates near/far from center
    /// Like: far, near, far, near, far  (zigzag horizontally)
    final leftPlacements = [
      _Placement(left: 0.02, top: 0.00, angle: -20, scale: 0.80), // top — far
      _Placement(left: 0.12, top: 0.22, angle:  -8, scale: 0.95), // upper — near
      _Placement(left: 0.03, top: 0.44, angle:   0, scale: 0.88), // mid — far
      _Placement(left: 0.13, top: 0.66, angle:   8, scale: 0.95), // lower — near
      _Placement(left: 0.02, top: 0.84, angle:  20, scale: 0.80), // bottom — far
    ];

    /// RIGHT: mirror of left (mathematically exact)
    const double logoFraction = logoSize / containerW;
    final rightPlacements = leftPlacements.map((p) => _Placement(
      left: 1.0 - p.left - logoFraction,
      top: p.top,
      angle: -p.angle,
      scale: p.scale,
    )).toList();

    return SizedBox(
      width: containerW,
      height: containerH,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// ✨ Curved connector lines
          Positioned.fill(
            child: CustomPaint(
              painter: _CurvedLinePainter(
                leftPlacements: leftPlacements,
                rightPlacements: rightPlacements,
                containerW: containerW,
                containerH: containerH,
                logoSize: logoSize,
              ),
            ),
          ),

          /// 🌟 Center Glow
          Positioned(
            left: containerW * 0.5 - 75,
            top: containerH * 0.5 - 55,
            child: Container(
              width: 150,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40FFD700),
                    blurRadius: 90,
                    spreadRadius: 35,
                  ),
                  BoxShadow(
                    color: Color(0x15FFFFFF),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                ],
              ),
            ),
          ),

          /// 🏏 IBL Logo — dead center
          Positioned(
            left: containerW * 0.5 - 65,
            top: containerH * 0.5 - 42,
            child: Image.asset(
              AppImages.indianBiddingLeague,
              width: 130,
              fit: BoxFit.contain,
            ),
          ),

          /// ◀ Left logos
          ...List.generate(leftLogos.length, (i) {
            final p = leftPlacements[i];
            return Positioned(
              left: p.left * containerW,
              top: p.top * containerH,
              child: Transform.scale(
                scale: p.scale,
                child: _LogoCard(
                  logo: leftLogos[i],
                  size: logoSize,
                  isNear: i % 2 == 1, // near ones get extra glow
                ),
              ),
            );
          }),

          /// ▶ Right logos
          ...List.generate(rightLogos.length, (i) {
            final p = rightPlacements[i];
            return Positioned(
              left: p.left * containerW,
              top: p.top * containerH,
              child: Transform.scale(
                scale: p.scale,
                child: _LogoCard(
                  logo: rightLogos[i],
                  size: logoSize,
                  isNear: i % 2 == 1,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Draws curved bezier lines from each logo to center
class _CurvedLinePainter extends CustomPainter {
  final List<_Placement> leftPlacements;
  final List<_Placement> rightPlacements;
  final double containerW;
  final double containerH;
  final double logoSize;

  const _CurvedLinePainter({
    required this.leftPlacements,
    required this.rightPlacements,
    required this.containerW,
    required this.containerH,
    required this.logoSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(containerW / 2, containerH / 2);
    final allPlacements = [...leftPlacements, ...rightPlacements];

    for (int i = 0; i < allPlacements.length; i++) {
      final p = allPlacements[i];
      final logoCenter = Offset(
        p.left * containerW + logoSize / 2,
        p.top * containerH + logoSize / 2,
      );

      final dist = (logoCenter - center).distance;
      final opacity = (1.0 - dist / (containerW * 0.55)).clamp(0.06, 0.22);

      final paint = Paint()
        ..color = const Color(0xFFFFD700).withOpacity(opacity)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      // Curved bezier: control point offset slightly upward for elegance
      final mid = Offset(
        (logoCenter.dx + center.dx) / 2,
        (logoCenter.dy + center.dy) / 2 - 18,
      );

      final path = Path()
        ..moveTo(logoCenter.dx, logoCenter.dy)
        ..quadraticBezierTo(mid.dx, mid.dy, center.dx, center.dy);

      // Dash the path
      _drawDashedPath(canvas, path, paint, dist);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double totalLen) {
    const dashLen = 5.0;
    const gapLen = 5.0;
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = logoSize / 2 + 6;
      while (distance < metric.length - logoSize * 0.6) {
        final end = (distance + dashLen).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(_CurvedLinePainter old) => false;
}

class _Placement {
  final double left;
  final double top;
  final double angle;
  final double scale;
  const _Placement({
    required this.left,
    required this.top,
    required this.angle,
    required this.scale,
  });
}

class _LogoCard extends StatelessWidget {
  final String logo;
  final double size;
  final bool isNear;

  const _LogoCard({required this.logo, required this.size, this.isNear = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   border: Border.all(
      //     color: const Color(0xFFFFD700).withOpacity(isNear ? 0.95 : 0.55),
      //     width: isNear ? 2.0 : 1.2,
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.55),
      //       blurRadius: 10,
      //       offset: const Offset(2, 4),
      //     ),
      //     BoxShadow(
      //       color: const Color(0xFFFFD700).withOpacity(isNear ? 0.35 : 0.12),
      //       blurRadius: isNear ? 18 : 10,
      //       spreadRadius: isNear ? 3 : 1,
      //     ),
      //   ],
      // ),
      child: ClipOval(
        child: Image.asset(logo, fit: BoxFit.cover),
      ),
    );
  }
}