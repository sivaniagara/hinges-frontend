import 'package:equatable/equatable.dart';

enum MatchWinStatusEnum {qualified, disqualified}
enum UserActiveStatusEnum {exitMatch, joinMatch, connectionLoss}

class UserStatusEntity extends Equatable {
  final String userId;
  final String userName;
  final String teamId;
  final UserActiveStatusEnum activeStatus;
  final String lastSeen;
  final int balanceAmount;
  final MatchWinStatusEnum matchWinStatusEnum;
  final int rank;
  final double totalRatings;

  const UserStatusEntity({
    required this.userId,
    required this.userName,
    required this.teamId,
    required this.activeStatus,
    required this.lastSeen,
    required this.balanceAmount,
    required this.matchWinStatusEnum,
    required this.rank,
    required this.totalRatings,
  });

  @override
  List<Object?> get props => [userId, teamId, activeStatus, lastSeen, balanceAmount, matchWinStatusEnum, rank, totalRatings];
}
