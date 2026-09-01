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
  late AnimationController _teamsController;

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

    /// Drives the "teams fly in from outside" entrance — each row reads
    /// its own slice of this single controller (see _TeamRow) so the
    /// whole roster staggers in one-by-one instead of popping at once.
    _teamsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _scale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
    _teamsController.forward();
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
    _teamsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MandalaBackground(
        backGroundColor: Colors.black,
        animateContent: false,
        showParticle: false,
        child: SafeArea(
          child: Stack(
            children: [
              /// ◀ LEFT COLUMN — team logos + names (flies in from left)
              Positioned(
                left: 18,
                top: 0,
                bottom: 0,
                child: _TeamColumn(
                  teams: _leftTeams,
                  pulseController: _pulseController,
                  entranceController: _teamsController,
                  alignRight: false,
                ),
              ),

              /// ▶ RIGHT COLUMN — team logos + names (flies in from right)
              Positioned(
                right: 18,
                top: 0,
                bottom: 0,
                child: _TeamColumn(
                  teams: _rightTeams,
                  pulseController: _pulseController,
                  entranceController: _teamsController,
                  alignRight: true,
                ),
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

  /// 🔥 PREMIUM GOLD PROGRESS BAR (slimmer)
  Widget _buildGoldenProgressBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.32,
      height: 10, // was 18
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFFD700), width: 1.2),
        color: const Color(0xFF0F5C8F),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.25),
            blurRadius: 8,
            spreadRadius: 0.5,
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
                      blurRadius: 10,
                      spreadRadius: 1.5,
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
              height: 4,
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

class _TeamData {
  final String logo;
  final String line1;
  final String line2;
  const _TeamData(this.logo, this.line1, this.line2);
}

class _TeamColumn extends StatelessWidget {
  final List<_TeamData> teams;
  final AnimationController pulseController;
  final AnimationController entranceController;
  final bool alignRight;
  const _TeamColumn({
    required this.teams,
    required this.pulseController,
    required this.entranceController,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment:
      alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: teams
          .asMap()
          .entries
          .map((e) => _TeamRow(
        team: e.value,
        pulseController: pulseController,
        entranceController: entranceController,
        alignRight: alignRight,
        index: e.key,
        total: teams.length,
      ))
          .toList(),
    );
  }
}

/// 🏷️ Redesigned team row — circular glowing logo + a soft glass pill
/// for the name. No diamond frame, no diagonal corner-cut panel.
class _TeamRow extends StatelessWidget {
  final _TeamData team;
  final AnimationController pulseController;
  final AnimationController entranceController;
  final bool alignRight;
  final int index;
  final int total;

  const _TeamRow({
    required this.team,
    required this.pulseController,
    required this.entranceController,
    this.alignRight = false,
    this.index = 0,
    this.total = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedBuilder(
        animation: Listenable.merge([pulseController, entranceController]),
        builder: (context, _) {
          // stagger the breathing glow per-row so the column feels "live"
          final t = (pulseController.value + index * 0.15) % 1.0;
          final glow = 0.28 + 0.4 * (1 - (t - 0.5).abs() * 2);

          // --- entrance: each row owns a slice of entranceController ---
          final slotStart = (index / total) * 0.65;
          const slotSpread = 0.45;
          final slotEnd = (slotStart + slotSpread).clamp(0.0, 1.0);
          final localT = slotEnd > slotStart
              ? ((entranceController.value - slotStart) /
              (slotEnd - slotStart))
              .clamp(0.0, 1.0)
              : 1.0;
          final entrance = Curves.easeOutCubic.transform(localT);

          // slide in from outside: left column from the left (-dx),
          // right column from the right (+dx)
          final dx = (1 - entrance) * (alignRight ? 60 : -60);

          return Opacity(
            opacity: entrance,
            child: Transform.translate(
              offset: Offset(dx, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                textDirection:
                alignRight ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  /// 🔵 CIRCULAR CREST — soft glow ring, no rotation
                  Container(
                    width: 38,
                    height: 38,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF071B33),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.85),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(glow),
                          blurRadius: 10,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      team.logo,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// 🏷️ NAME PILL — clean rounded glass, no diagonal cut
                  Container(
                    constraints: const BoxConstraints(maxWidth: 148),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFF071B33).withOpacity(0.85),
                          const Color(0xFF0F5C8F).withOpacity(0.35),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.4),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: alignRight
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.line1,
                          textAlign:
                          alignRight ? TextAlign.right : TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 10.5,
                            letterSpacing: 0.5,
                            height: 1.15,
                          ),
                        ),
                        Text(
                          team.line2,
                          textAlign:
                          alignRight ? TextAlign.right : TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                            letterSpacing: 0.6,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}