import 'dart:async';
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
        child: SafeArea(
          child: Stack(
            children: [
              /// ◀ LEFT COLUMN — team logos + names
              Positioned(
                left: 28,
                top: 0,
                bottom: 0,
                child: _TeamColumn(teams: _leftTeams),
              ),

              /// ▶ RIGHT COLUMN — team logos + names
              Positioned(
                right: 28,
                top: 0,
                bottom: 0,
                child: _TeamColumn(teams: _rightTeams),
              ),

              /// 🌟 CENTER CONTENT
              Center(
                child: FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// 🏆 CENTER SHIELD BADGE
                        Image.asset(
                          AppImages.indianBiddingLeague,
                          width: 220,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 36),

                        /// 🟡 GOLD PROGRESS BAR
                        _buildGoldenProgressBar(),

                        const SizedBox(height: 14),

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
            ],
          ),
        ),
      ),
    );
  }

  /// Team data — logo asset + two-line display name
  static final List<_TeamData> _leftTeams = [
    _TeamData(AppImages.miLogo, 'MUMBAI', 'IGNITES'),
    _TeamData(AppImages.cskLogo, 'CHENNAI', 'SUPREME KINGS'),
    _TeamData(AppImages.kkrLogo, 'KOLKATA', 'KNIGHT ROCKERS'),
    _TeamData(AppImages.rcbLogo, 'ROYAL CHAMPIONS', 'BENGALURU'),
    _TeamData(AppImages.pkLogo, 'PUNJAB', 'KINETICS'),
  ];

  static final List<_TeamData> _rightTeams = [
    _TeamData(AppImages.srhLogo, 'STORMRISERS', 'HYDERABAD'),
    _TeamData(AppImages.rrLogo, 'RAJASTHAN', 'RANGERS'),
    _TeamData(AppImages.gtLogo, 'GUJARAT', 'THUNDERS'),
    _TeamData(AppImages.lsgLogo, 'LUCKNOW', 'SUPER GALLANTS'),
    _TeamData(AppImages.dcLogo, 'DELHI', 'COMBATS'),
  ];

  /// 🔥 PREMIUM GOLD PROGRESS BAR
  Widget _buildGoldenProgressBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.32,
      height: 18,
      decoration: BoxDecoration(
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
        child: Stack(
          children: [
            /// 🔥 Animated Gold Fill with Glow
            FractionallySizedBox(
              widthFactor: _progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFFFF3C4),
                      Color(0xFFFFD700),
                    ],
                    stops: [0.0, 0.5, 1.0],
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
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
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
          ],
        ),
      ),
    );
  }
}

/// Holds a team's logo + its two display lines (matches reference UI)
class _TeamData {
  final String logo;
  final String line1;
  final String line2;
  const _TeamData(this.logo, this.line1, this.line2);
}

/// A straight vertical column of team rows (logo + name), evenly spaced
/// top-to-bottom — matches the reference screenshot exactly.
class _TeamColumn extends StatelessWidget {
  final List<_TeamData> teams;
  const _TeamColumn({required this.teams});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: teams.map((t) => _TeamRow(team: t)).toList(),
    );
  }
}

/// A single "logo + two-line name" row
class _TeamRow extends StatelessWidget {
  final _TeamData team;
  const _TeamRow({required this.team});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Logo — kept at native shape (no circular crop), just a subtle
        /// drop shadow so it lifts off the background.
        SizedBox(
          width: 52,
          height: 52,
          child: Image.asset(
            team.logo,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 14),

        /// Two-line team name, gold, bold, uppercase — as in reference
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              team.line1,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 0.6,
                height: 1.25,
              ),
            ),
            Text(
              team.line2,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 0.6,
                height: 1.25,
              ),
            ),
          ],
        ),
      ],
    );
  }
}