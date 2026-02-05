import '../../domain/entities/auction_player_status_entity.dart';

class AuctionPlayerStatusModel extends AuctionPlayerStatusEntity {
  const AuctionPlayerStatusModel({
    required super.playerId,
    required super.playerName,
    required super.playerRoleId,
    required super.teamId,
    required super.basePrice,
    required super.currentPrice,
    required super.priceIncrement,
    super.userId,
    required super.playerAuctionStatus,
  });

  factory AuctionPlayerStatusModel.fromJson(Map<String, dynamic> json) {
    return AuctionPlayerStatusModel(
      playerId: json['player_id'] ?? '',
      playerName: json['player_name'] ?? '',
      playerRoleId: json['player_role_id'] ?? '',
      teamId: json['team_id'] ?? '',
      basePrice: json['base_price'] ?? 0,
      currentPrice: json['current_price'] ?? 0,
      priceIncrement: json['price_increment'] ?? 0,
      userId: json['user_id'],
      playerAuctionStatus: json['player_auction_status'] ?? '',
    );
  }
}
