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

class PlayerRoundStartsIn extends StatelessWidget {
  final AuctionPlayerStatusEntity playerData;
  final List<PlayerEntity> playerList;
  final CategoryAndItemsEntity categoryAndItemsEntity;
  const PlayerRoundStartsIn({super.key, required this.playerList, required this.categoryAndItemsEntity, required this.playerData,});

  @override
  Widget build(BuildContext context) {
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
            style: GoogleFonts.cinzel(
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                context.read<GameBloc>().getPlayerRoleName(
                  playerData,
                  categoryAndItemsEntity,
                  playerList,
                ),
                style: GoogleFonts.cinzel(
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
                  categoryAndItemsEntity,
                  playerList,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.goldenStarLine,
              width: 50,
            ),
            Text('  STARTS IN', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),),
            BlocBuilder<GameBloc, GameState>(
                builder: (context, state){
                  if(state is GameLoaded){
                    return Text('  ${(state.remainingSecondsToExpireBreak?.toInt())}  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 30, fontWeight: FontWeight.bold)));
                  }
                  return SizedBox();
                }
            ),
            Text('..!  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),),
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
    );

  }
}