import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/game/presentation/pages/player_round_starts_in.dart';
import 'package:hinges_frontend/features/home/domain/entities/player_entity.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../home/domain/entities/category_and_items_entity.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../bloc/game_bloc.dart';

class PlayerSetBreakWidget extends StatelessWidget {
  final AuctionPlayerStatusEntity playerData;
  final List<PlayerEntity> playerList;
  final CategoryAndItemsEntity categoryAndItemsEntity;
  const PlayerSetBreakWidget({super.key, required this.playerList, required this.categoryAndItemsEntity, required this.playerData,});

  @override
  Widget build(BuildContext context) {
    if((context.read<GameBloc>().state as GameLoaded).remainingSecondsToExpireBreak! > 5){
      return Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(AppImages.indianBiddingLeague, width: 80, height: 80,),
              Column(
                spacing: 10,
                children: [
                  Text('ROUND', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 30, fontWeight: FontWeight.bold)),),
                  Text('BREAK...!', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 30, fontWeight: FontWeight.bold)),),
                ],
              ),
              Column(
                spacing: 5,
                children: [
                  Text('AUCTION', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
                  Text('RESUME IN', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.cyan)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<GameBloc, GameState>(
                            builder: (context, state){
                              if(state is GameLoaded){
                                return Text('${state.remainingSecondsToExpireBreak?.toInt()}', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 16, fontWeight: FontWeight.bold)));
                              }
                              return SizedBox();
                            }
                        ),
                        Text('Sec', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.goldenStarLine,
                width: 30,
              ),
              Text('  PLAN YOUR AUCTION STRATEGY  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 16, fontWeight: FontWeight.bold)),),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  AppImages.goldenStarLine,
                  width: 30,
                ),
              ),
            ],
          ),
        ],
      );
    }
    return PlayerRoundStartsIn(playerList: playerList, categoryAndItemsEntity: categoryAndItemsEntity, playerData: playerData);
  }
}