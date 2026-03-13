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
  final String playerRoleId;
  final String teamId;
  final int basePrice;
  final int currentPrice;
  final double baseRating;
  final int priceIncrement;
  final PlayerAuctionStatusEnum playerAuctionStatus;

  const AuctionPlayerStatusEntity({
    required this.playerId,
    required this.playerName,
    required this.playerRoleId,
    required this.teamId,
    required this.basePrice,
    required this.currentPrice,
    required this.baseRating,
    required this.priceIncrement,
    required this.playerAuctionStatus,
  });

  Map<String, dynamic> toJson(){
    return {
      "playerId" : playerId,
      "playerName" : playerName,
      "playerRoleId" : playerRoleId,
      "teamId" : teamId,
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
        playerRoleId,
        teamId,
        basePrice,
        currentPrice,
        baseRating,
        priceIncrement,
        playerAuctionStatus,
      ];
}
