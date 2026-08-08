import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/home/domain/entities/player_entity.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../home/domain/entities/category_and_items_entity.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../bloc/game_bloc.dart';
import '../widgets/pie_count_down_timer.dart';

class PlayerRoundStartsIn extends StatelessWidget {
  final List<AuctionPlayerStatusEntity> auctionPlayerList;
  final CategoryAndItemsEntity categoryAndItemsEntity;
  const PlayerRoundStartsIn({super.key, required this.categoryAndItemsEntity, required this.auctionPlayerList,});

  @override
  Widget build(BuildContext context) {
    final playerData = auctionPlayerList.firstWhere((p) => p.playerAuctionStatus == PlayerAuctionStatusEnum.notShown);
    return Column(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: 160,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(AppImages.chamberBox),
            ),
          ),
          child: Text(
            'Round ${(context.read<GameBloc>().state as GameLoaded).gameData.round}',
            style: GoogleFonts.rajdhani(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppTheme.borderGold,
            ),
          ),
        ),
        Container(
          width: 260,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(AppImages.chamberBox),
            ),
          ),
          child: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.read<GameBloc>().getPlayerRoleName(
                  playerData,
                  categoryAndItemsEntity,
                ),
                style: GoogleFonts.rajdhani(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Image.asset(
                width: 25,
                height: 25,
                context.read<GameBloc>().getPlayerRoleImage(
                  playerData,
                  categoryAndItemsEntity
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameLoaded){
              return SizedBox(
                width: 40,
                height: 40,
                child: PieCountdownTimer(
                  remainingSeconds: state.remainingSecondsToExpireBreak!.toInt(),
                  totalSeconds: 5,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}