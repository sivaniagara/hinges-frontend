import 'package:equatable/equatable.dart';
import '../../domain/entities/game_data_entity.dart';

abstract class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final GameDataEntity gameData;

  GameLoaded(this.gameData);

  @override
  List<Object?> get props => [gameData];
}

class GameError extends GameState {
  final String message;

  GameError(this.message);

  @override
  List<Object?> get props => [message];
}
