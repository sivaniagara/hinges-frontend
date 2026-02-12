import '../../domain/entities/user_status_entity.dart';

class UserStatusModel extends UserStatusEntity {
  const UserStatusModel({
    required super.userId,
    required super.userName,
    required super.teamId,
    required super.isActive,
    required super.lastSeen,
    required super.balanceAmount,
  });

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    return UserStatusModel(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      teamId: json['team_id'] ?? '',
      isActive: json['is_active'] ?? false,
      lastSeen: json['last_seen'] ?? '',
      balanceAmount: json['balance_amount'] ?? 0,
    );
  }

  factory UserStatusModel.fromEntity(UserStatusEntity entity){
    return UserStatusModel(
        userId: entity.userId,
        userName: entity.userName,
        teamId: entity.teamId,
        isActive: entity.isActive,
        lastSeen: entity.lastSeen,
        balanceAmount: entity.balanceAmount
    );
  }

  UserStatusEntity toEntity(){
    return UserStatusEntity(
        userId: userId,
        userName: userName,
        teamId: teamId,
        isActive: isActive,
        lastSeen: lastSeen,
        balanceAmount: balanceAmount
    );
  }
}
