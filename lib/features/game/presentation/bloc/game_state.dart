part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final GameDataEntity gameData;
  final double remainingSecondsToStart;

  GameLoaded({
    required this.gameData,
    required this.remainingSecondsToStart
  });

  GameLoaded copyWith({GameDataEntity? gameData, double? remainingSecondsToStart}){
    return GameLoaded(
        gameData: gameData ?? this.gameData,
        remainingSecondsToStart: remainingSecondsToStart ?? this.remainingSecondsToStart
    );
  }

  @override
  List<Object?> get props => [gameData, remainingSecondsToStart];
}

class GameError extends GameState {
  final String message;

  GameError(this.message);

  @override
  List<Object?> get props => [message];
}
