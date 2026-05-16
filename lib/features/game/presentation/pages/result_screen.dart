import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';

import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../domain/entities/user_status_entity.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020B1A),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF0A1F44),
                    ),
                    child: Center(
                      child: Text(
                        "RESULT TABLE",
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFFFFD700),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => context.go('/home'),
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
                  color: const Color(0xFF04122A),
                ),
                child: Column(
                  children: [
                    _buildHeader(),

                    Expanded(
                      child: BlocBuilder<GameBloc, GameState>(
                        builder: (context, state) {
                          if (state is GameLoaded) {
                            return ListView.builder(
                              itemCount: state.gameData.usersStatusList.length,
                              itemBuilder: (context, index) {
                                final user = state.gameData.usersStatusList[index];
                                final franchise = getFranchiseEnum(user.teamId);

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
    );
  }

  /// HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD4AF37))),
      ),
      child: Row(
        children: const [
          _HeaderCell("USER NAME", 2),
          _HeaderCell("FRANCHISE", 3),
          _HeaderCell("QUALIFICATION", 3),
          _HeaderCell("REMAINING PURSE", 2),
          _HeaderCell("FINAL RATING", 2),
          _HeaderCell("RANK", 2),
        ],
      ),
    );
  }

  /// ROW
  Widget _buildRow(BuildContext context, UserStatusEntity user,
      MiniAuctionFranchiseEnum franchise, int index) {
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
        padding: const EdgeInsets.symmetric(vertical: 10),
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
              color: const Color(0xFFFFD700).withOpacity(0.4),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(franchise.image(), height: 26),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      franchise.shortName(),
                      overflow: TextOverflow.ellipsis,
                      style: _textStyle(),
                    ),
                  ),
                ],
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
                child: _buildRank(user.rank, isQualified),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRank(int rank, bool isQualified) {
    if (!isQualified) {
      return const Text("-", style: TextStyle(color: Colors.white));
    }

    if (rank == 1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.emoji_events, color: Colors.amber, size: 18),
          SizedBox(width: 4),
          Text("1  ₹300", style: TextStyle(color: Colors.amber)),
        ],
      );
    } else if (rank == 2) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.emoji_events, color: Colors.grey, size: 18),
          SizedBox(width: 4),
          Text("2  ₹200", style: TextStyle(color: Colors.grey)),
        ],
      );
    } else if (rank == 3) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.emoji_events, color: Colors.brown, size: 18),
          SizedBox(width: 4),
          Text("3  ₹100", style: TextStyle(color: Colors.brown)),
        ],
      );
    }

    return Text(rank.toString(), style: _textStyle());
  }

  Widget _cell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(text, style: _textStyle()),
      ),
    );
  }

  TextStyle _textStyle({Color color = Colors.white, double size = 12}) {
    return GoogleFonts.cinzel(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }

  MiniAuctionFranchiseEnum getFranchiseEnum(String teamId) {
    if (teamId == MiniAuctionFranchiseEnum.csk.teamId()) {
      return MiniAuctionFranchiseEnum.csk;
    } else if (teamId == MiniAuctionFranchiseEnum.mi.teamId()) {
      return MiniAuctionFranchiseEnum.mi;
    } else if (teamId == MiniAuctionFranchiseEnum.rcb.teamId()) {
      return MiniAuctionFranchiseEnum.rcb;
    } else if (teamId == MiniAuctionFranchiseEnum.kkr.teamId()) {
      return MiniAuctionFranchiseEnum.kkr;
    } else {
      return MiniAuctionFranchiseEnum.srh;
    }
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
          style: GoogleFonts.cinzel(
            color: const Color(0xFFFFD700),
            fontSize: 11,
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
              colors: const [
                Colors.transparent,
                Color(0xFFFFF3B0),
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