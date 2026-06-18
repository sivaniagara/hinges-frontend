import 'package:equatable/equatable.dart';

enum PlayerAuctionStatusEnum {
  sold,
  notSold,
  buy,
  notShown,
  available,
}

class AuctionPlayerStatusEntity extends Equatable {
  final String playerId;
  final String playerName;
  final String playerRole;
  final String playerCategory;
  final String battingStyle;
  final String bowlingStyle;
  final String countryId;
  final String teamId;
  final int imageId;
  final int basePrice;
  final int currentPrice;
  final double baseRating;
  final int priceIncrement;
  final PlayerAuctionStatusEnum playerAuctionStatus;

  const AuctionPlayerStatusEntity({
    required this.playerId,
    required this.playerName,
    required this.playerRole,
    required this.teamId,
    required this.imageId,
    required this.basePrice,
    required this.currentPrice,
    required this.baseRating,
    required this.priceIncrement,
    required this.playerAuctionStatus,
    required this.playerCategory,
    required this.battingStyle,
    required this.bowlingStyle,
    required this.countryId,
  });

  Map<String, dynamic> toJson(){
    return {
      "playerId" : playerId,
      "playerName" : playerName,
      "playerRoleId" : playerRole,
      "playerCategory" : playerCategory,
      "battingStyle" : battingStyle,
      "bowlingStyle" : bowlingStyle,
      "countryId" : countryId,
      "teamId" : teamId,
      "imageId" : imageId,
      "basePrice" : basePrice,
      "currentPrice" : currentPrice,
      "baseRating" : baseRating,
      "priceIncrement" : priceIncrement,
      "playerAuctionStatus" : playerAuctionStatus,
    };
  }

  @override
  List<Object?> get props => [
        playerId,
        playerName,
        playerRole,
        teamId,
        imageId,
        basePrice,
        currentPrice,
        baseRating,
        priceIncrement,
        playerAuctionStatus,
        playerCategory,
        battingStyle,
        bowlingStyle,
        countryId,
      ];
}
