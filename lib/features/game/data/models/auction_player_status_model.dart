import '../../domain/entities/auction_player_status_entity.dart';

class AuctionPlayerStatusModel extends AuctionPlayerStatusEntity {
  const AuctionPlayerStatusModel({
    required super.playerId,
    required super.playerName,
    required super.playerRole,
    required super.teamId,
    required super.imageId,
    required super.basePrice,
    required super.currentPrice,
    required super.baseRating,
    required super.priceIncrement,
    required super.playerAuctionStatus,
    required super.playerCategory,
    required super.battingStyle,
    required super.bowlingStyle,
    required super.countryId,
  });

  factory AuctionPlayerStatusModel.fromJson(Map<String, dynamic> json) {
    return AuctionPlayerStatusModel(
      playerId: json['player_id'] ?? '',
      playerName: json['player_name'] ?? '',
      playerRole: json['player_role_id'] ?? '',
      teamId: json['team_id'] ?? '',
      imageId: json['image_id'] ?? 0,
      basePrice: json['base_price'] ?? 0,
      currentPrice: json['current_price'] ?? 0,
      baseRating: json['base_rating'] ?? 0,
      priceIncrement: json['price_increment'] ?? 0,
      playerAuctionStatus: getAuctionPlayerStatus(json['player_auction_status']),
      playerCategory: json['player_category'] ?? '',
      battingStyle: json['batting_style'] ?? '',
      bowlingStyle: json['bowling_style'] ?? '',
      countryId: json['country_id'] ?? '',
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
        playerRole: entity.playerRole,
        teamId: entity.teamId,
        imageId: entity.imageId,
        basePrice: entity.basePrice,
        currentPrice: entity.currentPrice,
        baseRating: entity.baseRating,
        priceIncrement: entity.priceIncrement,
        playerAuctionStatus: entity.playerAuctionStatus,
        playerCategory: entity.playerCategory,
        battingStyle: entity.battingStyle,
        bowlingStyle: entity.bowlingStyle,
        countryId: entity.countryId,
    );
  }

  AuctionPlayerStatusEntity toEntity() {
    return AuctionPlayerStatusEntity(
        playerId: playerId,
        playerName: playerName,
        playerRole: playerRole,
        teamId: teamId,
        imageId: imageId,
        basePrice: basePrice,
        currentPrice: currentPrice,
        baseRating: baseRating,
        priceIncrement: priceIncrement,
        playerAuctionStatus: playerAuctionStatus,
        playerCategory: playerCategory,
        battingStyle: battingStyle,
        bowlingStyle: bowlingStyle,
        countryId: countryId,
    );
  }

}
