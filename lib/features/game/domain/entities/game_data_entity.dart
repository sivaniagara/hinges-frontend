import 'package:equatable/equatable.dart';
import '../../data/models/auction_player_status_model.dart';
import '../../data/models/user_status_model.dart';
import 'user_status_entity.dart';
import 'auction_player_status_entity.dart';

enum MatchStatusEnum {
  notStarted,
  initialMatch,
  started,
  stopped,
  finished,
  paused,
}



class GameDataEntity extends Equatable {
  final String matchId;
  final String auctionCategoryId;
  final MatchStatusEnum matchStatus;
  final double gameCreatedAt;
  final int gameStartDuration;
  final double? gameStartAt;
  final int currentAuctionPlayerIndex;
  final double? auctionExpiresAt;
  final int highestBid;
  final String? highestBidUserId;
  final List<String> teamList;
  final List<UserStatusEntity> usersStatusList;
  final List<AuctionPlayerStatusEntity> auctionPlayersStatusList;

  const GameDataEntity({
    required this.matchId,
    required this.auctionCategoryId,
    required this.matchStatus,
    required this.gameCreatedAt,
    required this.gameStartDuration,
    this.gameStartAt,
    required this.currentAuctionPlayerIndex,
    this.auctionExpiresAt,
    required this.highestBid,
    this.highestBidUserId,
    required this.teamList,
    required this.usersStatusList,
    required this.auctionPlayersStatusList,
  });


  @override
  List<Object?> get props => [
        matchId,
        auctionCategoryId,
        matchStatus,
        gameCreatedAt,
        gameStartDuration,
        gameStartAt,
        currentAuctionPlayerIndex,
        auctionExpiresAt,
        highestBid,
        highestBidUserId,
        teamList,
        usersStatusList,
        auctionPlayersStatusList,
      ];
}
