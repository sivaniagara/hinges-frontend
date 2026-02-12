import 'package:equatable/equatable.dart';

class PlayerEntity extends Equatable {
  final String playerId;
  final String playerName;
  final String countryId;
  final String teamId;
  final String playerRole;
  final String battingStyle;
  final String bowlingStyle;
  final String playerCategory;
  final double basePrice;
  final double baseRating;

  const PlayerEntity({
    required this.playerId,
    required this.playerName,
    required this.countryId,
    required this.teamId,
    required this.playerRole,
    required this.battingStyle,
    required this.bowlingStyle,
    required this.playerCategory,
    required this.basePrice,
    required this.baseRating,
  });

  @override
  List<Object?> get props => [
        playerId,
        playerName,
        countryId,
        teamId,
        playerRole,
        battingStyle,
        bowlingStyle,
        playerCategory,
        basePrice,
        baseRating,
      ];
}
