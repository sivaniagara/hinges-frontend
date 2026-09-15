import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/theme/app_theme.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';
import 'package:hinges_frontend/features/login/presentation/widgets/mandala_background.dart';

import '../../../../core/utils/so_loud.dart';
import '../../../ads/bloc/ad_bloc.dart';
import '../../../ads/bloc/ad_event.dart';
import '../../../home/domain/entities/auction_category_item_entity.dart';
import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../../domain/entities/user_status_entity.dart';

/// ⏱ Timing constants — tune the "feel" here
const int kCalculatingDurationMs = 1400; // how long the "calculating" phase lasts
const int kRowStaggerMs = 220;           // gap between each row's reveal
const int kRowFlipDurationMs = 550;      // how long a single row takes to flip in
const int kNumberCountDurationMs = 750;  // how long purse/rating count-up takes
const int kRankRevealExtraMs = 200;      // extra beat before rank badge pops in

class ResultScreen extends StatefulWidget {
  final String auctionCategoryId;
  const ResultScreen({super.key, required this.auctionCategoryId});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isCalculating = true;
  bool _calcTimerStarted = false;

  @override
  void initState() {
    super.initState();
    context.read<AdBloc>().add(LoadInterstitialAd());
  }

  Widget _maybeStartCalculatingTimer(GameLoaded state) {
    if (!_calcTimerStarted) {
      _calcTimerStarted = true;
      Future.delayed(const Duration(milliseconds: kCalculatingDurationMs), () {
        if (mounted) setState(() => _isCalculating = false);
      });
    }

    if (_isCalculating) {
      return const _CalculatingView();
    }

    List<UserStatusEntity> sortedList = List.from(state.gameData.usersStatusList);
    sortedList.sort((a, b) {
      if (a.rank == 0 && b.rank == 0) return 0;
      if (a.rank == 0) return 1;
      if (b.rank == 0) return -1;
      return a.rank.compareTo(b.rank);
    });

    return ListView.builder(
      itemCount: sortedList.length,
      itemBuilder: (context, index) {
        final user = sortedList[index];
        final franchise = context.read<GameBloc>().getFranchiseEnum(user.teamId);
        final rowDelay = index * kRowStaggerMs;

        return _RowReveal(
          delay: rowDelay,
          child: _buildRow(context, user, franchise, rowDelay),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MandalaBackground(
      animateContent: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state is! GameLoaded) return const SizedBox.shrink();

              final homeLoaded = context.read<HomeBloc>().state as HomeLoaded;
              final userId = homeLoaded.userData.userId;
              final userStatus = state.gameData.usersStatusList.firstWhere((e) => e.userId == userId);
              final franchise = context.read<GameBloc>().getFranchise(state.gameData.usersStatusList, state.gameData.teamList, userId);
              final mySquad = context.read<GameBloc>().getMySquad(userId);

              return Column(
                children: [
                  // --- Header Row ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // RESULT TABLE Title Frame
                      Container(
                        width: 105,
                        height: 42,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.titleGoldenFrame),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "RESULT TABLE",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rajdhani(
                              color: const Color(0xFFD4AF37),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),

                      // Team Logo
                      Row(
                        children: [
                          Image.asset(franchise.image(), height: 50),
                          const SizedBox(width: 4),
                          Text(
                            franchise.shortName().toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Stats Section
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildHeaderStat('TOTAL PURSE', '60 CR', AppImages.purse),
                            const SizedBox(width: 6),
                            _buildHeaderStat(
                                'PURSE REM',
                                context.read<GameBloc>().formatPriceShort(userStatus.balanceAmount),
                                AppImages.purseRem,
                                valueColor: const Color(0xFF00FF00)
                            ),
                            const SizedBox(width: 6),
                            _buildHeaderStat(
                                'TOTAL RATING',
                                getSquadRating(mySquad).toStringAsFixed(1),
                                AppImages.rating,
                                valueColor: const Color(0xFFFFD700)
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Home Button
                      GestureDetector(
                        onTap: () {
                          playVibrateOnly(duration: 10);
                          context.push('/adPage');
                        },
                        child: Image.asset(AppImages.homeMenuIcon, width: 42),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// TABLE
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                      child: Column(
                        children: [
                          _buildTableHeader(),
                          Expanded(
                            child: _maybeStartCalculatingTimer(state),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// HEADER
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD4AF37))),
      ),
      child: Row(
        children: const [
          _HeaderCell("USER NAME", 2),
          _HeaderCell("FRANCHISE", 4),
          _HeaderCell("QUALIFICATION", 3),
          _HeaderCell("PURSE REMAINING", 2),
          _HeaderCell("FINAL RATING", 2),
          _HeaderCell("RANK", 2),
        ],
      ),
    );
  }

  /// ROW
  Widget _buildRow(
      BuildContext context,
      UserStatusEntity user,
      MiniAuctionFranchiseEnum franchise,
      int rowDelay,
      ) {
    final homeLoaded = context.read<HomeBloc>().state as HomeLoaded;
    AuctionCategoryItemEntity auctionCategoryItemEntity =
    homeLoaded.userData.auctionCategoryItem.firstWhere((e) => e.id == widget.auctionCategoryId);
    final isQualified = user.matchWinStatusEnum == MatchWinStatusEnum.qualified;

    final ratingValue = (context.read<GameBloc>().getRating(user.userId) as num).toDouble();
    final purseValue = user.balanceAmount.toDouble();

    final isTop3 = user.rank <= 3 && isQualified;

    // Numbers start counting once the row has visually landed
    final numberStartDelay = rowDelay + kRowFlipDurationMs;
    // Rank is revealed after the numbers finish "computing" — feels like the payoff
    final rankDelay = numberStartDelay + kNumberCountDurationMs + kRankRevealExtraMs;

    return _ShimmerWrapper(
      enabled: isTop3,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          gradient: isTop3
              ? LinearGradient(
            colors: [
              const Color(0xFFFFD700).withOpacity(0.15),
              Colors.transparent,
            ],
          )
              : null,
          boxShadow: isTop3
              ? [
            BoxShadow(
              color: AppTheme.borderGold.withValues(alpha: 0.1),
              blurRadius: 14,
              spreadRadius: 1,
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            _cell(user.userName, 2),

            /// FRANCHISE
            Expanded(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  playTap();
                  context.push('/game/mySquad?userId=${user.userId}');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    Image.asset(franchise.image(), height: 40),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        franchise.fullName(),
                        overflow: TextOverflow.ellipsis,
                        style: _textStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// QUALIFICATION
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: isQualified ? Colors.green : Colors.red),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isQualified ? Icons.check : Icons.close,
                        size: 14,
                        color: isQualified ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isQualified ? "QUALIFIED" : "DISQUALIFIED",
                        style: _textStyle(color: isQualified ? Colors.green : Colors.red, size: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// PURSE — counts up like it's being calculated
            Expanded(
              flex: 2,
              child: Center(
                child: _CountUpText(
                  end: purseValue,
                  delay: numberStartDelay,
                  duration: kNumberCountDurationMs,
                  style: _textStyle(),
                  formatter: (v) => context.read<GameBloc>().formatPriceShort(v.round()),
                ),
              ),
            ),

            /// RATING — counts up too
            Expanded(
              flex: 2,
              child: Center(
                child: _CountUpText(
                  end: ratingValue,
                  delay: numberStartDelay,
                  duration: kNumberCountDurationMs,
                  style: _textStyle(),
                  formatter: (v) => v.round().toString(),
                ),
              ),
            ),

            /// RANK — pops in last, as the "final answer"
            Expanded(
              flex: 2,
              child: Center(
                child: _RankReveal(
                  delay: rankDelay,
                  child: _buildRank(user.rank, isQualified, auctionCategoryItemEntity),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRank(int rank, bool isQualified, AuctionCategoryItemEntity auctionCategoryItemEntity) {
    if (!isQualified) {
      return const Text("-", style: TextStyle(color: Colors.white));
    }

    if (rank == 1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
          const SizedBox(width: 4),
          Text("1  ₹${auctionCategoryItemEntity.coinsFirstPrize}", style: const TextStyle(color: Colors.amber)),
        ],
      );
    } else if (rank == 2) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Colors.grey, size: 18),
          const SizedBox(width: 4),
          Text("2  ₹${auctionCategoryItemEntity.coinsSecondPrize}", style: const TextStyle(color: Colors.grey)),
        ],
      );
    } else if (rank == 3) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Colors.brown, size: 18),
          const SizedBox(width: 4),
          Text("3  ₹${auctionCategoryItemEntity.coinsThirdPrize}", style: const TextStyle(color: Colors.brown)),
        ],
      );
    }

    return Text(rank.toString(), style: _textStyle());
  }

  Widget _cell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(text, style: _textStyle(), maxLines: 2, textAlign: TextAlign.center),
      ),
    );
  }

  TextStyle _textStyle({Color color = Colors.white, double size = 13}) {
    return GoogleFonts.rajdhani(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildHeaderStat(String label, String value, String iconPath, {Color valueColor = const Color(0xFFFFD700)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 1.0),
        borderRadius: BorderRadius.circular(4),
        color: Colors.black.withOpacity(0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, width: 26, height: 26),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: GoogleFonts.quantico(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.bold)),
              Text(value, style: GoogleFonts.rajdhani(fontSize: 14, color: valueColor, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  double getSquadRating(Map<int, AuctionPlayerStatusEntity?> squad){
    double rating = 0.0;
    for(var key in squad.keys) {
      if(squad[key] != null){
        rating += squad[key]!.baseRating;
      }
    }
    return rating;
  }
}

/// HEADER CELL
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderCell(this.text, this.flex);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.rajdhani(
            color: const Color(0xFFFFD700),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// 🧮 CALCULATING VIEW — shown briefly before the table reveals
/// A pulsing "CALCULATING RESULTS..." label with a gold scan-line sweeping down,
/// so it reads as "the app is working something out" rather than "list is loading".
class _CalculatingView extends StatefulWidget {
  const _CalculatingView();

  @override
  State<_CalculatingView> createState() => _CalculatingViewState();
}

class _CalculatingViewState extends State<_CalculatingView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CircularProgressIndicator(
                  value: null,
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              // Pulse opacity between 0.5 and 1.0
              final pulse = 0.5 + 0.5 * (0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi));
              return Opacity(
                opacity: pulse,
                child: Text(
                  "CALCULATING RESULTS...",
                  style: GoogleFonts.rajdhani(
                    color: const Color(0xFFFFD700),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ✨ SHIMMER EFFECT (unchanged)
class _ShimmerWrapper extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const _ShimmerWrapper({
    required this.child,
    required this.enabled,
  });

  @override
  State<_ShimmerWrapper> createState() => _ShimmerWrapperState();
}

class _ShimmerWrapperState extends State<_ShimmerWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(1 + 2 * _controller.value, 0),
              colors: [
                Colors.transparent,
                AppTheme.borderGold.withValues(alpha: 0.2),
                Colors.transparent,
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.lighten,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// 🎬 ROW REVEAL — flips the row down into place like a card being turned face-up,
/// instead of a plain slide+fade. Feels heavier / more deliberate than a list fade-in.
class _RowReveal extends StatefulWidget {
  final Widget child;
  final int delay;

  const _RowReveal({
    required this.child,
    required this.delay,
  });

  @override
  State<_RowReveal> createState() => _RowRevealState();
}

class _RowRevealState extends State<_RowReveal> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: kRowFlipDurationMs),
  );
  late final Animation<double> curved = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        final t = curved.value; // 0 -> 1
        final angle = (1 - t) * (math.pi / 2.2); // starts tilted, ends flat
        final opacity = t.clamp(0.0, 1.0);
        final liftOffset = (1 - t) * 14; // slight downward drop as it settles

        return Opacity(
          opacity: opacity,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0018) // perspective
              ..rotateX(angle)
              ..translate(0.0, -liftOffset),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// 🔢 COUNT-UP NUMBER — animates from 0 up to the real value, so it visually reads
/// as "this number is being computed" before settling on the final result.
class _CountUpText extends StatelessWidget {
  final double end;
  final int delay;
  final int duration;
  final TextStyle style;
  final String Function(double value) formatter;

  const _CountUpText({
    required this.end,
    required this.delay,
    required this.duration,
    required this.style,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return _DelayedTween(
      delay: delay,
      duration: duration,
      begin: 0,
      end: end,
      builder: (context, value) {
        return Text(
          formatter(value),
          style: style,
          maxLines: 2,
          textAlign: TextAlign.center,
        );
      },
    );
  }
}

/// 🏆 RANK REVEAL — pops in with a bounce after the numbers finish counting,
/// so the rank feels like the "conclusion" of the calculation.
class _RankReveal extends StatefulWidget {
  final Widget child;
  final int delay;

  const _RankReveal({
    required this.child,
    required this.delay,
  });

  @override
  State<_RankReveal> createState() => _RankRevealState();
}

class _RankRevealState extends State<_RankReveal> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> scale = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
  late final Animation<double> opacity = CurvedAnimation(
    parent: controller,
    curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: FadeTransition(
        opacity: opacity,
        child: widget.child,
      ),
    );
  }
}

/// Generic delayed tween helper used by _CountUpText.
class _DelayedTween extends StatefulWidget {
  final int delay;
  final int duration;
  final double begin;
  final double end;
  final Widget Function(BuildContext context, double value) builder;

  const _DelayedTween({
    required this.delay,
    required this.duration,
    required this.begin,
    required this.end,
    required this.builder,
  });

  @override
  State<_DelayedTween> createState() => _DelayedTweenState();
}

class _DelayedTweenState extends State<_DelayedTween> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.duration),
  );
  late final Animation<double> curved = CurvedAnimation(parent: controller, curve: Curves.easeOut);
  late Animation<double> value = Tween(begin: widget.begin, end: widget.begin).animate(curved);

  @override
  void initState() {
    super.initState();
    value = Tween(begin: widget.begin, end: widget.end).animate(curved);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: value,
      builder: (context, _) => widget.builder(context, value.value),
    );
  }
}