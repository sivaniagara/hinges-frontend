import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/theme/app_theme.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';

import '../../../../core/utils/so_loud.dart';
import '../../../ads/bloc/ad_bloc.dart';
import '../../../ads/bloc/ad_event.dart';
import '../../../home/domain/entities/auction_category_item_entity.dart';
import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../domain/entities/user_status_entity.dart';

class ResultScreen extends StatefulWidget {
  final String auctionCategoryId;
  const ResultScreen({super.key, required this.auctionCategoryId});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    // Preload Interstitial Ad when the screen opens
    context.read<AdBloc>().add(LoadInterstitialAd());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF020B1A),
      body: Container(
        color: const Color(0xff065387),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF0A1F44),
                    ),
                    child: Center(
                      child: Text(
                        "RESULT TABLE",
                        style: GoogleFonts.rajdhani(
                          color: const Color(0xFFFFD700),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      playTap();
                      // Show Interstitial Ad then go home
                      context.read<AdBloc>().add(ShowInterstitialAd(
                        onAdClosed: () {
                          if (mounted) {
                            context.go('/home');
                          }
                        },
                      ));
                    },
                    child: Image.asset(AppImages.homeMenuIcon, width: 50),
                  )
                ],
              ),

              const SizedBox(height: 10),

              /// TABLE
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Column(
                    children: [
                      _buildHeader(),

                      Expanded(
                        child: BlocBuilder<GameBloc, GameState>(
                          builder: (context, state) {
                            if (state is GameLoaded) {
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

                                  return _AnimatedRow(
                                    delay: index * 120,
                                    child: _buildRow(
                                      context,
                                      user,
                                      franchise,
                                      index,
                                    ),
                                  );
                                },
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD4AF37))),
      ),
      child: Row(
        children: const [
          _HeaderCell("USER NAME", 2),
          _HeaderCell("FRANCHISE", 3),
          _HeaderCell("QUALIFICATION", 3),
          _HeaderCell("PURSE REMAINING", 2),
          _HeaderCell("FINAL RATING", 2),
          _HeaderCell("RANK", 2),
        ],
      ),
    );
  }

  /// ROW
  Widget _buildRow(BuildContext context, UserStatusEntity user,
      MiniAuctionFranchiseEnum franchise, int index) {
    final homeLoaded = context.read<HomeBloc>().state as HomeLoaded;
    AuctionCategoryItemEntity auctionCategoryItemEntity = homeLoaded.userData.auctionCategoryItem.firstWhere((e) => e.id == widget.auctionCategoryId);
    final isQualified =
        user.matchWinStatusEnum == MatchWinStatusEnum.qualified;

    final rating =
    context.read<GameBloc>().getRating(user.userId).toString();

    final purse =
    context.read<GameBloc>().formatPriceShort(user.balanceAmount);

    final isTop3 = user.rank <= 3 && isQualified;

    return _ShimmerWrapper(
      enabled: isTop3,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),

          /// 🔥 GOLD BACKGROUND GLOW
          gradient: isTop3
              ? LinearGradient(
            colors: [
              const Color(0xFFFFD700).withOpacity(0.15),
              Colors.transparent,
            ],
          )
              : null,

          /// 🔥 OUTER GLOW
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
              flex: 3,
              child: GestureDetector(
                onTap: (){
                  playTap();
                  context.push('/game/mySquad?userId=${user.userId}');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(franchise.image(), height: 40),
                    const SizedBox(width: 6),
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
                    border: Border.all(
                        color: isQualified ? Colors.green : Colors.red),
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
                        style: _textStyle(
                            color: isQualified ? Colors.green : Colors.red,
                            size: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            _cell(purse, 2),
            _cell(rating, 2),

            Expanded(
              flex: 2,
              child: Center(
                child: _buildRank(user.rank, isQualified, auctionCategoryItemEntity),
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
        child: Text(text, style: _textStyle(), maxLines: 2, textAlign: TextAlign.center,),
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

/// ✨ SHIMMER EFFECT
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

class _ShimmerWrapperState extends State<_ShimmerWrapper>
    with SingleTickerProviderStateMixin {
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

/// 🎬 ROW ENTRY ANIMATION
class _AnimatedRow extends StatefulWidget {
  final Widget child;
  final int delay;

  const _AnimatedRow({
    required this.child,
    required this.delay,
  });

  @override
  State<_AnimatedRow> createState() => _AnimatedRowState();
}

class _AnimatedRowState extends State<_AnimatedRow>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    offset = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

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
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: offset,
        child: widget.child,
      ),
    );
  }
}