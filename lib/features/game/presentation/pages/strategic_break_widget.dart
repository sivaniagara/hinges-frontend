import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../mini_auction/presentation/pages/mini_auction_screen.dart';

class StrategicBreakWidget extends StatelessWidget {
  final MiniAuctionLiteMode mode;
  const StrategicBreakWidget({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.goldenStarLine,
                      width: 30,
                    ),
                    Text('  WELCOME TO  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
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
                Container(
                  width: 160,
                  height: 40,
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
                      fontSize: 12,
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
                      width: 30,
                    ),
                    Text('  ${mode.miniAuctionItem.name} ROOM  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
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
            ),
            Column(
              spacing: 5,
              children: [
                Text('AUCTION', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
                Text('STARTS IN', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
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
            if((context.read<GameBloc>().state as GameLoaded).remainingSecondsToExpireBreak! > 50)
              Text('  PLAN YOUR AUCTION STRATEGY  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 16, fontWeight: FontWeight.bold)),)
            else
              Text('  USE YOUR PURSE AMOUNT WISELY  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 16, fontWeight: FontWeight.bold)),),
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
}
