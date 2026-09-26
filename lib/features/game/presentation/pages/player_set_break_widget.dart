import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/so_loud.dart';
//import 'package:hinges_frontend/features/game/presentation/pages/player_round_starts_in.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../home/domain/entities/category_and_items_entity.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../bloc/game_bloc.dart';

class PlayerSetBreakWidget extends StatefulWidget {
  final AuctionPlayerStatusEntity playerData;
  final List<AuctionPlayerStatusEntity> auctionPlayerList;
  final CategoryAndItemsEntity categoryAndItemsEntity;

  const PlayerSetBreakWidget({
    super.key,
    required this.categoryAndItemsEntity,
    required this.playerData,
    required this.auctionPlayerList,
  });

  @override
  State<PlayerSetBreakWidget> createState() =>
      _PlayerSetBreakWidgetState();
}

class _PlayerSetBreakWidgetState
    extends State<PlayerSetBreakWidget> {

 // int? _audioPlayedForRound;
    int? _audioPlayedForRound;
    int? _resumeAudioPlayedForRound;


  Widget _buildFlipContainer({
    required bool showInfo,
    required double width,
    required Widget child,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      transitionBuilder: (child, animation) {
        final rotateAnimation = Tween<double>(
          begin: math.pi / 2,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
        );

        return AnimatedBuilder(
          animation: rotateAnimation,
          child: child,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                rotateAnimation.value,
              ),
              child: child,
            );
          },
        );
      },
      child: Container(
        key: ValueKey(showInfo),
        width: width,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              AppImages.goldenDoubleStartFrame,
            ),
          ),
        ),
       child: child,
      ),
    );
  }
Widget _buildLoadingDot(int index) {
  return _LoadingDot(index: index);
}
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {

        if (state is! GameLoaded) {
          return const SizedBox.shrink();
        }

        final int remaining =
            state.remainingSecondsToExpireBreak?.ceil() ?? 0;

        final int round = state.gameData.round;
       if (remaining >= 29 &&
           _resumeAudioPlayedForRound != round) {

         _resumeAudioPlayedForRound = round;

         WidgetsBinding.instance.addPostFrameCallback((_) {
           if (mounted) {
             playRoundBreakAudio();
           }
         });
       }

        final bool showRoundInfo = remaining <= 15;

      //  final String setName =
      //      context.read<GameBloc>().getPlayerRoleName(
      //        widget.playerData,
      //        widget.categoryAndItemsEntity,
      //      );
      final String setName;

      switch (round) {
        case 1:
          setName = 'BATSMEN';
          break;

        case 2:
          setName = 'WICKET-KEEPERS';
          break;

        case 3:
          setName = 'ALL-ROUNDERS';
          break;

        case 4:
          setName = 'BOWLERS';
          break;

        default:
          setName = '';
      }

        if (showRoundInfo &&
            _audioPlayedForRound != round) {

          _audioPlayedForRound = round;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              playRoundAudio(round);
            }
          });
        }

        final String setIcon;

        switch (round) {
          case 1:
            setIcon = AppImages.bat;
            break;

          case 2:
            setIcon = AppImages.wicketKeepingGloves;
            break;

          case 3:
            setIcon = AppImages.batBall;
            break;

          case 4:
            setIcon = AppImages.ball;
            break;

          default:
            setIcon = AppImages.bat;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /*
            Image.asset(
              AppImages.indianBiddingLeague,
              width: 100,
              height: 100,
            ),
            */
Container(
  width: 160,
  height: 40,
  alignment: Alignment.center,
  decoration: BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.fill,
      image: AssetImage(
        AppImages.goldenDoubleStartFrame,
      ),
    ),
  ),
  child: Text(
    'ROUND $round',
    style: GoogleFonts.rajdhani(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppTheme.borderGold,
    ),
  ),
),
            const SizedBox(height: 15),

          _buildFlipContainer(
            showInfo: showRoundInfo,
            width: 260,
            child: showRoundInfo
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$setName SET',
                        style: GoogleFonts.rajdhani(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Image.asset(
                        setIcon,
                        width: 28,
                        height: 28,
                      ),
                    ],
                  )
               : Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     _buildLoadingDot(0),
                     const SizedBox(width: 5),
                     _buildLoadingDot(1),
                     const SizedBox(width: 5),
                     _buildLoadingDot(2),
                   ],
                 ),
          ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  AppImages.goldenStarLine,
                  width: 50,
                ),

                const SizedBox(width: 10),

               Text(
                 'AUCTION RESUMES IN ',
                 style: GoogleFonts.rajdhani(
                   color: Colors.white,
                   fontSize: 13,
                   fontWeight: FontWeight.bold,
                 ),
               ),

               SizedBox(
                 width: 28,
                 child: Text(
                   '$remaining',
                   textAlign: TextAlign.center,
                   style: GoogleFonts.rajdhani(
                     color: AppTheme.borderGold,
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ),

               Text(
                 ' SECONDS',
                 style: GoogleFonts.rajdhani(
                   color: Colors.white,
                   fontSize: 13,
                   fontWeight: FontWeight.bold,
                 ),
               ),
                const SizedBox(width: 10),

                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(
                    math.pi,
                  ),
                  child: Image.asset(
                    AppImages.goldenStarLine,
                    width: 50,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
class _LoadingDot extends StatefulWidget {
  final int index;

  const _LoadingDot({
    required this.index,
  });

  @override
  State<_LoadingDot> createState() => _LoadingDotState();
}

class _LoadingDotState extends State<_LoadingDot>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.25,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.35,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(
      Duration(milliseconds: widget.index * 180),
      () {
        if (mounted) {
          _controller.repeat(reverse: true);
        }
      },
    );
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppTheme.borderGold,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
