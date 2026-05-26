import 'package:equatable/equatable.dart';
import 'package:hinges_frontend/features/game/presentation/pages/game_screen.dart';
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

enum BreakStatusEnum {
  strategicBreak,
  acceleratedBreak,
  playerSetBreak,
  auctionPlayerBreak,
  triggerNextPlayer,
  pause
}



class GameDataEntity extends Equatable {
  final String matchId;
  final String auctionCategoryId;
  final MatchStatusEnum matchStatus;
  final MatchTypeEnum matchType;
  final String roomCode;
  final BreakStatusEnum breakStatus;
  final double gameCreatedAt;
  final int round;
  final int gameStartDuration;
  final double? gameStartAt;
  final int currentAuctionPlayerIndex;
  final double? auctionExpiresAt;
  final double? breakExpiresAt;
  final double? serverTime;
  final int highestBid;
  final String? highestBidUserId;
  final List<String> teamList;
  final List<UserStatusEntity> usersStatusList;
  final List<AuctionPlayerStatusEntity> auctionPlayersStatusList;
  final LastMessageEntity lastMessage;

  const GameDataEntity({
    required this.matchId,
    required this.auctionCategoryId,
    required this.matchStatus,
    required this.matchType,
    this.roomCode = '',
    required this.breakStatus,
    required this.gameCreatedAt,
    required this.round,
    required this.gameStartDuration,
    required this.gameStartAt,
    required this.currentAuctionPlayerIndex,
    required this.auctionExpiresAt,
    required this.breakExpiresAt,
    required this.serverTime,
    required this.highestBid,
    this.highestBidUserId,
    required this.teamList,
    required this.usersStatusList,
    required this.auctionPlayersStatusList,
    required this.lastMessage,
  });

  GameDataEntity copyWith({
    String? matchId,
    String? auctionCategoryId,
    MatchStatusEnum? matchStatus,
    MatchTypeEnum? matchType,
    String? roomCode,
    BreakStatusEnum? breakStatus,
    double? gameCreatedAt,
    int? round,
    int? gameStartDuration,
    double? gameStartAt,
    int? currentAuctionPlayerIndex,
    double? auctionExpiresAt,
    double? breakExpiresAt,
    double? serverTime,
    int? highestBid,
    String? highestBidUserId,
    List<String>? teamList,
    List<UserStatusEntity>? usersStatusList,
    List<AuctionPlayerStatusEntity>? auctionPlayersStatusList,
    LastMessageEntity? lastMessage,
  }) {
    return GameDataEntity(
      matchId: matchId ?? this.matchId,
      auctionCategoryId: auctionCategoryId ?? this.auctionCategoryId,
      matchStatus: matchStatus ?? this.matchStatus,
      matchType: matchType ?? this.matchType,
      roomCode: roomCode ?? this.roomCode,
      breakStatus: breakStatus ?? this.breakStatus,
      gameCreatedAt: gameCreatedAt ?? this.gameCreatedAt,
      round: round ?? this.round,
      gameStartDuration: gameStartDuration ?? this.gameStartDuration,
      gameStartAt: gameStartAt ?? this.gameStartAt,
      currentAuctionPlayerIndex: currentAuctionPlayerIndex ?? this.currentAuctionPlayerIndex,
      auctionExpiresAt: auctionExpiresAt ?? this.auctionExpiresAt,
      breakExpiresAt: breakExpiresAt ?? this.breakExpiresAt,
      serverTime: serverTime ?? this.serverTime,
      highestBid: highestBid ?? this.highestBid,
      highestBidUserId: highestBidUserId ?? this.highestBidUserId,
      teamList: teamList ?? this.teamList,
      usersStatusList: usersStatusList ?? this.usersStatusList,
      auctionPlayersStatusList: auctionPlayersStatusList ?? this.auctionPlayersStatusList,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }


  @override
  List<Object?> get props => [
        matchId,
        auctionCategoryId,
        matchStatus,
        matchType,
        roomCode,
        breakStatus,
        gameCreatedAt,
        round,
        gameStartDuration,
        gameStartAt,
        currentAuctionPlayerIndex,
        auctionExpiresAt,
        breakExpiresAt,
        serverTime,
        highestBid,
        highestBidUserId,
        teamList,
        usersStatusList,
        auctionPlayersStatusList,
        lastMessage,
      ];
}

class LastMessageEntity{
  final String userId;
  final String message;
  final bool isShowed;
  const LastMessageEntity({
    required this.userId,
    required this.message,
    required this.isShowed,
  });

  LastMessageEntity copyWith({
    String? userId,
    String? message,
    bool? isShowed,
  }) {
    return LastMessageEntity(
      userId: userId ?? this.userId,
      message: message ?? this.message,
      isShowed: isShowed ?? this.isShowed,
    );
  }
}
