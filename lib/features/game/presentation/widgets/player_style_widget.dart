import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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

        final currentPlayerId =
            gameData.auctionPlayersStatusList[
            gameData.currentAuctionPlayerIndex].playerId;

        final player = state.userData.players
            .where((e) => e.playerId == currentPlayerId)
            .toList();

        if (player.isEmpty) {
          return const Text(
            'Unknown Player',
            style: TextStyle(color: Colors.white),
          );
        }

        final playerStyle = state.userData.categoryAndItsItem.playerRoleCategoryId
            .where((e) => e.id == player.first.playerRole).toList();

        final battingStyle = state.userData.categoryAndItsItem.battingStyleCategoryId
            .where((e) => e.id == player.first.battingStyle).toList();

        final bowlingStyle = state.userData.categoryAndItsItem.bowlingStyleCategoryId
            .where((e) => e.id == player.first.bowlingStyle).toList();

        final batsmanId = '6881ba0f36213beb0017be9c';
        final wicketKeeperId = '6881ba3936213beb0017be9d';
        print('playerStyle : ${playerStyle.first.id} | battingStyle : ${battingStyle.first.categoryItemName} | bowlingStyle : ${bowlingStyle.first.categoryItemName}');

        return Text(
          [batsmanId, wicketKeeperId].contains(playerStyle.first.id) ? battingStyle.first.categoryItemName : bowlingStyle.first.categoryItemName,
          style: GoogleFonts.jost(textStyle: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        );
      },
    );;
  }
}
