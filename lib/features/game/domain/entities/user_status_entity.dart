import 'package:equatable/equatable.dart';

class UserStatusEntity extends Equatable {
  final String userId;
  final String teamId;
  final bool isActive;
  final String lastSeen;
  final int balanceAmount;

  const UserStatusEntity({
    required this.userId,
    required this.teamId,
    required this.isActive,
    required this.lastSeen,
    required this.balanceAmount,
  });

  @override
  List<Object?> get props => [userId, teamId, isActive, lastSeen, balanceAmount];
}
