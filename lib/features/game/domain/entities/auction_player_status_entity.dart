import 'package:equatable/equatable.dart';

class AuctionPlayerStatusEntity extends Equatable {
  final String playerId;
  final String playerName;
  final String playerRoleId;
  final String teamId;
  final int basePrice;
  final int currentPrice;
  final int priceIncrement;
  final String? userId;
  final String playerAuctionStatus;

  const AuctionPlayerStatusEntity({
    required this.playerId,
    required this.playerName,
    required this.playerRoleId,
    required this.teamId,
    required this.basePrice,
    required this.currentPrice,
    required this.priceIncrement,
    this.userId,
    required this.playerAuctionStatus,
  });

  @override
  List<Object?> get props => [
        playerId,
        playerName,
        playerRoleId,
        teamId,
        basePrice,
        currentPrice,
        priceIncrement,
        userId,
        playerAuctionStatus,
      ];
}
