import '../../domain/entities/user_status_entity.dart';

class UserStatusModel extends UserStatusEntity {
  const UserStatusModel({
    required super.userId,
    required super.userName,
    required super.teamId,
    required super.activeStatus,
    required super.lastSeen,
    required super.balanceAmount,
    required super.matchWinStatusEnum,
    required super.rank,
    required super.totalRatings,
  });

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {

    UserActiveStatusEnum getActiveStatus(String activeStatus){
      if(activeStatus == 'exit_match'){
        return UserActiveStatusEnum.exitMatch;
      }else if(activeStatus == 'join_match'){
        return UserActiveStatusEnum.joinMatch;
      }else{
        return UserActiveStatusEnum.connectionLoss;
      }
    }
    return UserStatusModel(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      teamId: json['team_id'] ?? '',
      activeStatus: getActiveStatus(json['active_status']),
      lastSeen: json['last_seen'] ?? '',
      balanceAmount: json['balance_amount'] ?? 0,
      matchWinStatusEnum: json['match_win_status'] == 'qualified' ? MatchWinStatusEnum.qualified : MatchWinStatusEnum.disqualified,
      rank: json['rank'] ?? 0,
      totalRatings: json['totalRatings'] ?? 0.0,
    );
  }

  factory UserStatusModel.fromEntity(UserStatusEntity entity){
    return UserStatusModel(
        userId: entity.userId,
        userName: entity.userName,
        teamId: entity.teamId,
        activeStatus: entity.activeStatus,
        lastSeen: entity.lastSeen,
        balanceAmount: entity.balanceAmount,
        matchWinStatusEnum: entity.matchWinStatusEnum,
        rank: entity.rank,
        totalRatings: entity.totalRatings,
    );
  }

  UserStatusEntity toEntity(){
    return UserStatusEntity(
        userId: userId,
        userName: userName,
        teamId: teamId,
        activeStatus: activeStatus,
        lastSeen: lastSeen,
        balanceAmount: balanceAmount,
        matchWinStatusEnum: matchWinStatusEnum,
        rank: rank,
        totalRatings: totalRatings,
    );
  }
}
