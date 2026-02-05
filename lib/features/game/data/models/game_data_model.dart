import '../../domain/entities/game_data_entity.dart';
import 'user_status_model.dart';
import 'auction_player_status_model.dart';

class GameDataModel extends GameDataEntity {
  const GameDataModel({
    required super.matchId,
    required super.auctionCategoryId,
    required super.matchStatus,
    required super.gameCreatedAt,
    required super.gameStartDuration,
    super.gameStartAt,
    required super.currentAuctionPlayerIndex,
    super.auctionExpiresAt,
    required super.highestBid,
    super.highestBidUserId,
    required super.teamList,
    required List<UserStatusModel> super.usersStatusList,
    required List<AuctionPlayerStatusModel> super.auctionPlayersStatusList,
  });

  factory GameDataModel.fromJson(Map<String, dynamic> json) {
    return GameDataModel(
      matchId: json['match_id'] ?? '',
      auctionCategoryId: json['auction_category_id'] ?? '',
      matchStatus: json['match_status'] ?? '',
      gameCreatedAt: json['match_created_at'] ?? '',
      gameStartDuration: json['game_start_duration'] ?? 0,
      gameStartAt: json['game_start_at'],
      currentAuctionPlayerIndex: json['current_auction_player_index'] ?? 0,
      auctionExpiresAt: json['auction_expires_at'],
      highestBid: json['highest_bid'] ?? 0,
      highestBidUserId: json['highest_bid_user_id'],
      teamList: List<String>.from(json['team_list'] ?? []),
      usersStatusList: (json['users_status_list'] as List? ?? [])
          .map((i) => UserStatusModel.fromJson(i))
          .toList(),
      auctionPlayersStatusList: (json['auction_players_status_list'] as List? ?? [])
          .map((i) => AuctionPlayerStatusModel.fromJson(i))
          .toList(),
    );
  }
}
