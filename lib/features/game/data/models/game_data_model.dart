import '../../domain/entities/game_data_entity.dart';
import '../../domain/entities/user_status_entity.dart';
import 'user_status_model.dart';
import 'auction_player_status_model.dart';

class GameDataModel extends GameDataEntity {
  const GameDataModel({
    required super.matchId,
    required super.auctionCategoryId,
    required super.matchStatus,
    required super.breakStatus,
    required super.gameCreatedAt,
    required super.gameStartDuration,
    super.gameStartAt,
    required super.currentAuctionPlayerIndex,
    required super.auctionExpiresAt,
    required super.breakExpiresAt,
    required super.serverTime,
    required super.highestBid,
    super.highestBidUserId,
    required super.teamList,
    required List<UserStatusModel> super.usersStatusList,
    required List<AuctionPlayerStatusModel> super.auctionPlayersStatusList,
  });

  static MatchStatusEnum getMatchStatus(String matchStatus) {
    if(matchStatus == 'not_started'){
      return MatchStatusEnum.notStarted;
    }else if(matchStatus == 'initial_match'){
      return MatchStatusEnum.initialMatch;
    }else if(matchStatus == 'started'){
      return MatchStatusEnum.started;
    }else if(matchStatus == 'stopped'){
      return MatchStatusEnum.stopped;
    }else if(matchStatus == 'paused'){
      return MatchStatusEnum.paused;
    }else{
      return MatchStatusEnum.finished;
    }
  }

  static BreakStatusEnum getBreakStatus(String breakStatus) {
    if(breakStatus == 'player_set_break'){
      return BreakStatusEnum.playerSetBreak;
    }else if(breakStatus == 'auction_player_break'){
      return BreakStatusEnum.auctionPlayerBreak;
    }else if(breakStatus == 'trigger_next_player'){
      return BreakStatusEnum.triggerNextPlayer;
    }else{
      return BreakStatusEnum.pause;
    }
  }

  factory GameDataModel.fromJson(Map<String, dynamic> json) {

    return GameDataModel(
      matchId: json['match_id'] ?? '',
      auctionCategoryId: json['auction_category_id'] ?? '',
      matchStatus: getMatchStatus(json['match_status']),
      breakStatus: getBreakStatus(json['break_status']),
      gameCreatedAt: json['match_created_at'],
      gameStartDuration: json['game_start_duration'] ?? 0,
      gameStartAt: json['game_start_at'],
      currentAuctionPlayerIndex: json['current_auction_player_index'] ?? 0,
      auctionExpiresAt: json['auction_expires_at'],
      breakExpiresAt: json['break_expires_at'],
      serverTime: json['server_time'],
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

  factory GameDataModel.fromEntity(GameDataEntity entity) {
    return GameDataModel(
        matchId: entity.matchId,
        auctionCategoryId: entity.auctionCategoryId,
        matchStatus: entity.matchStatus,
        breakStatus: entity.breakStatus,
        gameCreatedAt: entity.gameCreatedAt,
        gameStartDuration: entity.gameStartDuration,
        currentAuctionPlayerIndex: entity.currentAuctionPlayerIndex,
        auctionExpiresAt: entity.auctionExpiresAt,
        breakExpiresAt: entity.breakExpiresAt,
        serverTime: entity.serverTime,
        highestBid: entity.highestBid,
        teamList: entity.teamList,
        usersStatusList: entity.usersStatusList.map((e) => UserStatusModel.fromEntity(e)).toList(),
        auctionPlayersStatusList: entity.auctionPlayersStatusList.map((e) => AuctionPlayerStatusModel.fromEntity(e)).toList()
    );
  }


  GameDataModel dataFromWebSocket(Map<String, dynamic> json) {

    List<AuctionPlayerStatusModel> updatedPlayers =
    List.from(auctionPlayersStatusList);

    if (json.containsKey('auction_players_status_list')) {
      for (var player in json['auction_players_status_list']) {
        int index = updatedPlayers.indexWhere(
                (e) => e.playerId == player["player_id"]);

        if (index != -1) {
          updatedPlayers[index] = AuctionPlayerStatusModel.fromJson(player);
        }
      }
    }

    List<UserStatusModel> updatedUsers =
    List.from(usersStatusList);

    if (json.containsKey('users_status_list')) {
      for (var user in json['users_status_list']) {
        int index = updatedUsers.indexWhere(
                (e) => e.userId == user["user_id"]);

        if (index != -1) {
          updatedUsers[index] = UserStatusModel.fromJson(user);
        } else {
          updatedUsers.add(UserStatusModel.fromJson(user));
        }
      }
    }

    return GameDataModel(
      matchId: json['match_id'] ?? matchId,
      auctionCategoryId: json['auction_category_id'] ?? auctionCategoryId,
      matchStatus: json['match_status'] != null
          ? getMatchStatus(json['match_status'])
          : matchStatus,
      breakStatus: json['break_status'] != null
          ? getBreakStatus(json['break_status'])
          : breakStatus,
      gameCreatedAt: json['match_created_at'] ?? gameCreatedAt,
      gameStartDuration: json['game_start_duration'] ?? gameStartDuration,
      currentAuctionPlayerIndex:
      json['current_auction_player_index'] ?? currentAuctionPlayerIndex,
      auctionExpiresAt: json['auction_expires_at'] ?? auctionExpiresAt,
      breakExpiresAt: json['break_expires_at'] ?? breakExpiresAt,
      serverTime: json['server_time'] ?? serverTime,
      highestBid: json['highest_bid'] ?? highestBid,
      teamList:
      json['team_list'] != null ? List<String>.from(json['team_list']) : teamList,
      usersStatusList: updatedUsers,
      auctionPlayersStatusList: updatedPlayers,
    );
  }}
