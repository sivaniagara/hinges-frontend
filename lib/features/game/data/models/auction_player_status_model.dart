import '../../domain/entities/auction_player_status_entity.dart';

class AuctionPlayerStatusModel extends AuctionPlayerStatusEntity {
  const AuctionPlayerStatusModel({
    required super.playerId,
    required super.playerName,
    required super.playerRoleId,
    required super.teamId,
    required super.basePrice,
    required super.currentPrice,
    required super.baseRating,
    required super.priceIncrement,
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
      baseRating: json['base_rating'] ?? 0,
      priceIncrement: json['price_increment'] ?? 0,
      playerAuctionStatus: getAuctionPlayerStatus(json['player_auction_status']),
    );
  }

  static PlayerAuctionStatusEnum getAuctionPlayerStatus(String playerStatus) {
    if(playerStatus == 'sold'){
      return PlayerAuctionStatusEnum.sold;
    }else if(playerStatus == 'buy'){
      return PlayerAuctionStatusEnum.buy;
    }else if(playerStatus == 'not_sold'){
      return PlayerAuctionStatusEnum.notSold;
    }else if(playerStatus == 'not_shown'){
      return PlayerAuctionStatusEnum.notShown;
    }else{
      return PlayerAuctionStatusEnum.available;
    }
  }

  factory AuctionPlayerStatusModel.fromEntity(AuctionPlayerStatusEntity entity) {
    return AuctionPlayerStatusModel(
        playerId: entity.playerId,
        playerName: entity.playerName,
        playerRoleId: entity.playerRoleId,
        teamId: entity.teamId,
        basePrice: entity.basePrice,
        currentPrice: entity.currentPrice,
        baseRating: entity.baseRating,
        priceIncrement: entity.priceIncrement,
        playerAuctionStatus: entity.playerAuctionStatus,
    );
  }

  AuctionPlayerStatusEntity toEntity() {
    return AuctionPlayerStatusEntity(
        playerId: playerId,
        playerName: playerName,
        playerRoleId: playerRoleId,
        teamId: teamId,
        basePrice: basePrice,
        currentPrice: currentPrice,
        baseRating: baseRating,
        priceIncrement: priceIncrement,
        playerAuctionStatus: playerAuctionStatus,
    );
  }

}
