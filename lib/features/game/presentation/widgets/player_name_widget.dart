import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/presentation/bloc/home_bloc.dart';
import '../../domain/entities/game_data_entity.dart';

class PlayerNameWidget extends StatelessWidget {
  final GameDataEntity gameData;
  const PlayerNameWidget({super.key, required this.gameData});

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


        return Text(
          player.playerName,
          style: const TextStyle(
            fontFamily: 'Zuume',
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            fontSize: 25,
          ),
        );
      },
    );
  }
}
