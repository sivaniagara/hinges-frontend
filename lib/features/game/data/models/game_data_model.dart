import '../../domain/entities/game_data_entity.dart';
import '../../domain/entities/user_status_entity.dart';
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
    required super.auctionExpiresAt,
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

  factory GameDataModel.fromJson(Map<String, dynamic> json) {

    return GameDataModel(
      matchId: json['match_id'] ?? '',
      auctionCategoryId: json['auction_category_id'] ?? '',
      matchStatus: getMatchStatus(json['match_status']),
      gameCreatedAt: json['match_created_at'],
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

  factory GameDataModel.fromEntity(GameDataEntity entity) {
    return GameDataModel(
        matchId: entity.matchId,
        auctionCategoryId: entity.auctionCategoryId,
        matchStatus: entity.matchStatus,
        gameCreatedAt: entity.gameCreatedAt,
        gameStartDuration: entity.gameStartDuration,
        currentAuctionPlayerIndex: entity.currentAuctionPlayerIndex,
        auctionExpiresAt: entity.auctionExpiresAt,
        highestBid: entity.highestBid,
        teamList: entity.teamList,
        usersStatusList: entity.usersStatusList.map((e) => UserStatusModel.fromEntity(e)).toList(),
        auctionPlayersStatusList: entity.auctionPlayersStatusList.map((e) => AuctionPlayerStatusModel.fromEntity(e)).toList()
    );
  }


  GameDataModel dataFromWebSocket(Map<String, dynamic> json) {
    try{
      // Update auction players
      if(json.containsKey('auction_players_status_list')){
        for (int i = 0; i < auctionPlayersStatusList.length; i++) {
          for (var player in json['auction_players_status_list']) {
            if (auctionPlayersStatusList[i].playerId == player["player_id"]) {
              auctionPlayersStatusList[i] = AuctionPlayerStatusModel.fromJson(player);
            }
          }
        }
      }


      // Update users
      if(json.containsKey('users_status_list')){
        for (int i = 0; i < usersStatusList.length; i++) {
          for (var user in json['users_status_list']) {
            if (usersStatusList[i].userId == user["user_id"]) {
              usersStatusList[i] = UserStatusModel.fromJson(user);
            }
          }
        }
      }
      if(json.containsKey('users_status_list')){
        for(var user = 0;user < json['users_status_list'].length;user++){
          if(usersStatusList.length < user + 1){
            usersStatusList.add(UserStatusModel.fromJson(json['users_status_list'][user]));
          }
        }
      }


      return GameDataModel(
        matchId: json['match_id'] ?? matchId,
        auctionCategoryId: json['auction_category_id'] ?? auctionCategoryId,
        matchStatus: json['match_status'] != null ? getMatchStatus(json['match_status']) : matchStatus,
        gameCreatedAt: json['match_created_at'] ?? gameCreatedAt,
        gameStartDuration: json['game_start_duration'] ?? gameStartDuration,
        currentAuctionPlayerIndex: json['current_auction_player_index'] ?? currentAuctionPlayerIndex,
        auctionExpiresAt: json['auction_expires_at'] ?? auctionExpiresAt,
        highestBid: json['highest_bid'] ?? highestBid,
        teamList: json['team_list'] != null ? List<String>.from(json['team_list']) : teamList,
        usersStatusList: usersStatusList.map((e) => UserStatusModel.fromEntity(e)).toList(),
        auctionPlayersStatusList: auctionPlayersStatusList.map((e) => AuctionPlayerStatusModel.fromEntity(e)).toList(),
      );
    }catch(e, stackTrace){
      print('dataFromWebSocket error : ${e.toString()}');
      print('dataFromWebSocket stackTrace : ${stackTrace}');
      rethrow;
    }

  }
}
