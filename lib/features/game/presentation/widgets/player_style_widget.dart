import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_ids.dart';

import '../../../home/presentation/bloc/home_bloc.dart';
import '../../domain/entities/game_data_entity.dart';

class PlayerStyleWidget extends StatelessWidget {
  final GameDataEntity gameData;
  const PlayerStyleWidget({super.key, required this.gameData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoaded) {
          return const SizedBox();
        }

        if (gameData.auctionPlayersStatusList.isEmpty ||
            gameData.currentAuctionPlayerIndex >=
                gameData.auctionPlayersStatusList.length) {
          return const SizedBox();
        }

        final player = gameData.auctionPlayersStatusList[
        gameData.currentAuctionPlayerIndex];

        final playerStyle = state.userData.categoryAndItsItem.playerRoleCategoryId
            .where((e) => e.id == player.playerRole).toList();

        final battingStyle = state.userData.categoryAndItsItem.battingStyleCategoryId
            .where((e) => e.id == player.battingStyle).toList();

        final bowlingStyle = state.userData.categoryAndItsItem.bowlingStyleCategoryId
            .where((e) => e.id == player.bowlingStyle).toList();

        return Text(
          [AppIds.batsmanId, AppIds.wicketKeeperId].contains(playerStyle.first.id) ? battingStyle.first.categoryItemName : bowlingStyle.first.categoryItemName,
          style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}