import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/presentation/widgets/adaptive_status_bar.dart';
import 'package:hinges_frontend/core/presentation/widgets/dot_circular_loader.dart';
import 'package:hinges_frontend/features/game/domain/entities/game_data_entity.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/pacman_count_down.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/pie_count_down_timer.dart';

import '../../../../core/presentation/widgets/back_icon.dart';
import '../../../../core/presentation/widgets/gradient_text.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/so_loud.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/widgets/app_background.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../../mini_auction/presentation/pages/mini_auction_screen.dart';
import '../../domain/entities/user_status_entity.dart';
import '../bloc/game_bloc.dart';
import '../pages/game_screen.dart';
import 'exit_dialog.dart';

class GameExpireWidget extends StatelessWidget {
  final MiniAuctionLiteMode mode;

  const GameExpireWidget({super.key, required this.mode});

  static const List<Color> _yellowTagColors = [Color(0xff330000), Color(0xffFF1D2B)];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: AppBackground(
        animateContent: false,
        child: BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) {
            if (current is GameLoaded &&
                current.remainingSecondsToStart == 0 &&
                current.gameData.usersStatusList.length != 5) {
              if (previous is GameLoaded) {
                return previous.remainingSecondsToStart > 0;
              }
              return true;
            }
            return false;
          },
          listener: (context, state) {
            _showMatchExpiredDialog(context);
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocBuilder<GameBloc, GameState>(
                builder: (context, state){
                  if (state is GameError) {
                    return _buildRetryWidget(context, state.message);
                  }
                  if (state is GameInitial || state is GameLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  }
                  if (state is! GameLoaded) {
                    return Container();
                  }
                  if (state.isReconnecting) {
                    return _buildRetryWidget(context, "Connection unstable. Trying to reconnect...");
                  }

                  final isStarted = state.gameData.matchStatus == MatchStatusEnum.initialMatch;
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<GameBloc>().add(RefreshGameData());
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    color: Colors.amber,
                    backgroundColor: Colors.red.withOpacity(0.8),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: size.height),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    PieCountdownTimer(remainingSeconds: state.remainingSecondsToStart.toInt(), totalSeconds: 120,),
                                    // PacmanCountdown(remaining: state.remainingSecondsToStart.toInt(), total: 120),
                                  ],
                                ),
                              ),
                            ),

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
                                      style: GoogleFonts.rajdhani(
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
                                      Text('  ${mode.miniAuctionItem.name.toUpperCase()} ROOM  ', style: GoogleFonts.rajdhani(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 14, fontWeight: FontWeight.bold)),),
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
                                          userName: (state.gameData.usersStatusList.length > index && state.gameData.usersStatusList[index].activeStatus != UserActiveStatusEnum.exitMatch)
                                              ? state.gameData.usersStatusList[index].userName
                                              : '',
                                          franchiseName: state.gameData.usersStatusList.length > index ? context.read<GameBloc>().getFranchise(state.gameData.usersStatusList, state.gameData.teamList, state.gameData.usersStatusList[index].userId).shortName() : '',
                                          franchiseImage: state.gameData.usersStatusList.length > index ? context.read<GameBloc>().getFranchise(state.gameData.usersStatusList, state.gameData.teamList, state.gameData.usersStatusList[index].userId).image() : '',
                                          userActiveStatusEnum: state.gameData.usersStatusList.length > index ? state.gameData.usersStatusList[index].activeStatus : UserActiveStatusEnum.joinMatch,
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    spacing: 20,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImages.goldenStarLine,
                                        width: 50,
                                      ),
                                      Text('WAIT FOR THE OTHER USERS TO JOIN THE AUCTION ROOM', style: GoogleFonts.rajdhani(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
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
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: BackIcon(
                                onTap: () {
                                  showExitDialog(context);
                                },                        ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetryWidget(BuildContext context, String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.amber, size: 60),
            const SizedBox(height: 16),
            Text(
              "CONNECTION LOST",
              style: GoogleFonts.oxanium(
                textStyle: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.jost(textStyle: const TextStyle(fontSize: 14, color: Colors.white70)),
            ),
            const SizedBox(height: 24),
            _buildTag(
                title: 'TRY AGAIN',
                tagImage: AppImages.yellowTag,
                colors: _yellowTagColors,
                onTap: () => _handleRetry(context)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag({required String title, required String tagImage, required List<Color> colors, double? imageSize, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: imageSize ?? 130,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(tagImage), fit: BoxFit.fill)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GradientText(title: title, colors: colors, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _handleRetry(BuildContext context) {
    final homeState = context.read<HomeBloc>().state;
    if (homeState is HomeLoaded) {
      context.read<GameBloc>().add(
        FetchGameData(
          userId: homeState.userData.userId,
          userName: homeState.userData.userName,
          auctionCategoryId: homeState.userData.auctionCategoryItem.first.id,
          matchType: MatchTypeEnum.normalMatch.value,
        ),
      );
    }
  }


  void showExitDialog(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    final homeBloc = context.read<HomeBloc>();
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: gameBloc),
            BlocProvider.value(value: homeBloc),
          ],
          child: Dialog(
            backgroundColor: AppTheme.navyBlue,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: ExitDialog(),
          ),
        );
      },
    );
  }

  void _showMatchExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.navyBlue,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              /// 🔸 GOLDEN FRAME CONTAINER
              Container(
                width: 500,
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.dialogFrame),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  spacing: 20,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GoldenTitle(title: 'MATCH EXPIRED GO TO HOME', fontSize: 18,),
                    GestureDetector(
                      onTap: () {
                        playTap();
                        context.go('/home');
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage(
                                  AppImages.dialogFrame,
                                ),
                                fit: BoxFit.fill
                            ),
                            color: const Color(0xff000F3A)
                        ),
                        child: Center(
                          child: Text(
                              'HOME',
                              style: GoogleFonts.rajdhani(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}

class _AnimatedCard extends StatefulWidget {
  final bool isStarted;
  final bool hasUser;
  final String userName;
  final String franchiseName;
  final String franchiseImage;
  final UserActiveStatusEnum userActiveStatusEnum;

  const _AnimatedCard({
    required this.isStarted,
    required this.hasUser,
    required this.userName,
    required this.franchiseName,
    required this.franchiseImage,
    required this.userActiveStatusEnum,
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
          if (widget.hasUser && !widget.isStarted && widget.userActiveStatusEnum != UserActiveStatusEnum.exitMatch)
            Image.asset(
              AppImages.goldenAvatar,
              width: 80,
              height: 80,
            )
          else if (widget.hasUser && widget.isStarted && franchiseImage.isNotEmpty && widget.userActiveStatusEnum != UserActiveStatusEnum.exitMatch)
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
                style: GoogleFonts.rajdhani(
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
              style: GoogleFonts.rajdhani(
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
