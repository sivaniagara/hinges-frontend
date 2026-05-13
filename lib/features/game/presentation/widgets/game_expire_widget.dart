import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/presentation/widgets/adaptive_status_bar.dart';
import 'package:hinges_frontend/core/presentation/widgets/dot_circular_loader.dart';
import 'package:hinges_frontend/features/game/domain/entities/game_data_entity.dart';

import '../../../../core/presentation/widgets/back_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../home/presentation/widgets/app_background.dart';
import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../../mini_auction/presentation/pages/mini_auction_screen.dart';
import '../bloc/game_bloc.dart';

class GameExpireWidget extends StatelessWidget {
  final MiniAuctionLiteMode mode;

  const GameExpireWidget({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: AppBackground(
        animateContent: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<GameBloc, GameState>(
              builder: (context, state){
                if(state is GameLoaded){
                  final isStarted = state.gameData.matchStatus == MatchStatusEnum.initialMatch;
                  return Stack(
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.height,
                        child: Column(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CrownTitle(text: 'ALLOCATION PANEL'),
                            Container(
                              width: size.width * 0.4,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(AppImages.goldenFrame),
                                ),
                              ),
                              child: Text(
                                'MINI AUCTION LITE',
                                style: GoogleFonts.cinzel(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.borderGold,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.goldenStarLine,
                                  width: 50,
                                ),
                                Text('  ${mode.miniAuctionItem.name} ROOM  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 14, fontWeight: FontWeight.bold)),),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.goldenStarLine,
                                  width: 50,
                                ),
                                Text('WAIT FOR THE USERS TO JOIN THE AUCTION TABLE', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(5, (index){
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                  transform: Matrix4.translationValues(0, 0, 0),
                                  child: _AnimatedCard(
                                    isStarted: isStarted,
                                    hasUser: state.gameData.usersStatusList.length > index,
                                    userName: state.gameData.usersStatusList.length > index
                                        ? state.gameData.usersStatusList[index].userName
                                        : '',
                                    franchiseName: state.gameData.usersStatusList.length > index ? context.read<GameBloc>().getFranchise(state.gameData.usersStatusList, state.gameData.teamList, state.gameData.usersStatusList[index].userId).shortName() : '',
                                    franchiseImage: state.gameData.usersStatusList.length > index ? context.read<GameBloc>().getFranchise(state.gameData.usersStatusList, state.gameData.teamList, state.gameData.usersStatusList[index].userId).image() : '',
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: BackIcon(),
                      ),

                    ],
                  );
                }
                return Text('GameExpireWidget Error');
              }
          ),
        ),
      ),
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final bool isStarted;
  final bool hasUser;
  final String userName;
  final String franchiseName;
  final String franchiseImage;

  const _AnimatedCard({
    required this.isStarted,
    required this.hasUser,
    required this.userName,
    required this.franchiseName,
    required this.franchiseImage,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isStarted) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * math.pi;

        final isFront = angle < math.pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // 👈 perspective (important)
            ..rotateY(angle),
          child: isFront
              ? _buildFront()
              : Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi), // 👈 FIX mirror
            child: _buildBack(),
          ),
        );
      },
    );
  }

  /// FRONT SIDE → USERNAME
  Widget _buildFront() {
    return _cardContent(widget.userName, widget.franchiseName, widget.franchiseImage);
  }

  /// BACK SIDE → FRANCHISE NAME
  Widget _buildBack() {
    return _cardContent(widget.userName, widget.franchiseName, widget.franchiseImage);
  }

  /// COMMON UI
  Widget _cardContent(String userName, String franchiseName, String franchiseImage, ) {
    return Container(
      width: 120,
      height: MediaQuery.sizeOf(context).height * 0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.franchiseGoldenCard),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.hasUser && !widget.isStarted)
            Image.asset(
              AppImages.goldenAvatar,
              width: 80,
              height: 80,
            )
          else if (widget.hasUser && widget.isStarted && franchiseImage.isNotEmpty)
            Image.asset(
              franchiseImage,
              width: 80,
              height: 80,
            )
          else
            const DotCircleLoader(),
          const SizedBox(height: 10),
          if (widget.hasUser && widget.isStarted && franchiseImage.isNotEmpty)
            SizedBox(
              width: 100,
              child: Text(
                franchiseName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.cinzel(
                  color: AppTheme.borderGold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(
            width: 100,
            child: Text(
              userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(
                color: AppTheme.borderGold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
