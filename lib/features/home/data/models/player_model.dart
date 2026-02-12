import '../../domain/entities/player_entity.dart';

class PlayerModel extends PlayerEntity {
  const PlayerModel({
    required super.playerId,
    required super.playerName,
    required super.countryId,
    required super.teamId,
    required super.playerRole,
    required super.battingStyle,
    required super.bowlingStyle,
    required super.playerCategory,
    required super.basePrice,
    required super.baseRating,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      playerId: json['player_id'] ?? '',
      playerName: json['player_name'] ?? '',
      countryId: json['country_id'] ?? '',
      teamId: json['team_id'] ?? '',
      playerRole: json['player_role'] ?? '',
      battingStyle: json['batting_style'] ?? '',
      bowlingStyle: json['bowling_style'] ?? '',
      playerCategory: json['player_category'] ?? '',
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0.0,
      baseRating: (json['base_rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
