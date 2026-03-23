import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_name_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_style_widget.dart';

import '../../../../core/network/http_service_impl.dart';
import '../../../../core/utils/app_ids.dart';
import '../../../../core/utils/app_images.dart';
import '../../../home/domain/entities/player_entity.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../../domain/entities/game_data_entity.dart';
import '../bloc/game_bloc.dart';

class PlayerAuctionStatusWidget extends StatelessWidget {
  final GameDataEntity gameData;
  final AuctionPlayerStatusEntity playerData;
  final GameLoaded state;
  const PlayerAuctionStatusWidget({super.key, required this.gameData, required this.playerData, required this.state});

  @override
  Widget build(BuildContext context) {
    final userState = context.read<HomeBloc>().state as HomeLoaded;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Row (Name + icons)
            Row(
              children: [
                PlayerNameWidget(gameData: gameData),
              ],
            ),

            const SizedBox(height: 2),

            /// 🔹 Style
            PlayerStyleWidget(gameData: gameData),

            const SizedBox(height: 4),

            /// 🔹 Price + Rating (ultra compact)
            Row(
              children: [
                _miniStat(
                  title: 'BASE',
                  value:
                  context.read<GameBloc>().formatPriceShort(playerData.basePrice),
                ),
                const SizedBox(width: 8),
                _miniStat(
                  title: 'RTG',
                  value:
                  '${playerData.baseRating}',
                ),
              ],
            ),
          ],
        ),
        Column(
          spacing: 10,
          children: [
            Row(children: [
              Image.asset(
                context.read<GameBloc>().getPlayerRoleImage(
                    playerData,
                    userState.userData.categoryAndItsItem,
                    userState.userData.players),
                width: 18,
                height: 18,
              ),

              if (isCappedPlayer(playerData, userState.userData.players))
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Image.asset(
                    AppImages.cap,
                    width: 16,
                    height: 16,
                  ),
                ),

              const SizedBox(width: 4),

              Text(
                context.read<GameBloc>().getPlayerCountryFlag(
                    playerData,
                    userState.userData.categoryAndItsItem,
                    userState.userData.players),
                style: const TextStyle(fontSize: 14),
              ),
            ],),
            BlocSelector<GameBloc, GameState, String>(
              selector: (state) {
                if (state is! GameLoaded) return '';
                return state.gameData
                    .auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex]
                    .playerId;
              },
              builder: (context, playerId) {
                return Image.network(
                  "${HttpServiceImpl.ipAddress}images/players/$playerId.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, size: 70),
                );
              },
            ),
            if(playerData.playerAuctionStatus == PlayerAuctionStatusEnum.buy)
              Text('Sold', style: TextStyle(fontSize: 25, color: Colors.lightGreenAccent, fontWeight: FontWeight.bold),)
            else
              Text('Un Sold', style: TextStyle(fontSize: 25, color: Colors.red.withValues(alpha: 1), fontWeight: FontWeight.bold),),

          ],
        ),
        if(playerData.playerAuctionStatus == PlayerAuctionStatusEnum.buy)
          Column(
            spacing: 10,
            children: [
              Text(
                context.read<GameBloc>().findTheUserWhoBuyThePlayer(
                    state.gameData.usersStatusList,
                    state.gameData.teamList,
                    playerData.teamId
                ).userName,
                style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),),
              Image.asset(
                context.read<GameBloc>().getFranchise(
                    state.gameData.usersStatusList,
                    state.gameData.teamList,
                    context.read<GameBloc>().findTheUserWhoBuyThePlayer(
                        state.gameData.usersStatusList,
                        state.gameData.teamList,
                        playerData.teamId
                    ).userId
                ).image(),
                width: 60,
                height: 60,
              ),
              Text(context.read<GameBloc>().getFranchise(
                  state.gameData.usersStatusList,
                  state.gameData.teamList,
                  context.read<GameBloc>().findTheUserWhoBuyThePlayer(
                      state.gameData.usersStatusList,
                      state.gameData.teamList,
                      playerData.teamId
                  ).userId
              ).name,
                style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),)
            ],
          ),
      ],
    );
  }

  Widget _miniStat({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  bool isCappedPlayer(AuctionPlayerStatusEntity player, List<PlayerEntity> playerList){
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    return playerEntity.playerCategory == AppIds.cappedPlayerId;
  }
}
