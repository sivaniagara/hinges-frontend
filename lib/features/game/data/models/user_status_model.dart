import '../../domain/entities/user_status_entity.dart';

class UserStatusModel extends UserStatusEntity {
  const UserStatusModel({
    required super.userId,
    required super.teamId,
    required super.isActive,
    required super.lastSeen,
    required super.balanceAmount,
  });

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    return UserStatusModel(
      userId: json['user_id'] ?? '',
      teamId: json['team_id'] ?? '',
      isActive: json['is_active'] ?? false,
      lastSeen: json['last_seen'] ?? '',
      balanceAmount: json['balance_amount'] ?? 0,
    );
  }
}
