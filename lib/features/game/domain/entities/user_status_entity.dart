import 'package:equatable/equatable.dart';

enum MatchWinStatusEnum {qualified, disqualified}

class UserStatusEntity extends Equatable {
  final String userId;
  final String userName;
  final String teamId;
  final bool isActive;
  final String lastSeen;
  final int balanceAmount;
  final MatchWinStatusEnum matchWinStatusEnum;
  final int rank;
  final double totalRatings;

  const UserStatusEntity({
    required this.userId,
    required this.userName,
    required this.teamId,
    required this.isActive,
    required this.lastSeen,
    required this.balanceAmount,
    required this.matchWinStatusEnum,
    required this.rank,
    required this.totalRatings,
  });

  @override
  List<Object?> get props => [userId, teamId, isActive, lastSeen, balanceAmount, matchWinStatusEnum, rank, totalRatings];
}
