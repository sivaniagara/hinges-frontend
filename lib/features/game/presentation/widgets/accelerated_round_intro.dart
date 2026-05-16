import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../bloc/game_bloc.dart';

class AcceleratedRoundIntro extends StatelessWidget {
  const AcceleratedRoundIntro({super.key});

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
          width: 250,
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
                'ACCELERATED SET',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Image.asset(
                  width: 50,
                  AppImages.acceleratedRound,
              )
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