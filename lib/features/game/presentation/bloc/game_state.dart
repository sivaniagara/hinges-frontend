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
  final double? remainingSecondsToExpireAuctionPlayer;
  final bool isReconnecting;

  GameLoaded({
    required this.gameData,
    required this.remainingSecondsToStart,
    required this.remainingSecondsToExpireAuctionPlayer,
    this.isReconnecting = false,   // ✅ default false
  });

  GameLoaded copyWith({
    GameDataEntity? gameData,
    double? remainingSecondsToStart,
    double? remainingSecondsToExpireAuctionPlayer,
    bool? isReconnecting,
  }) {
    return GameLoaded(
      gameData: gameData ?? this.gameData,
      remainingSecondsToStart:
      remainingSecondsToStart ?? this.remainingSecondsToStart,
      remainingSecondsToExpireAuctionPlayer:
      remainingSecondsToExpireAuctionPlayer ??
          this.remainingSecondsToExpireAuctionPlayer,
      isReconnecting: isReconnecting ?? this.isReconnecting,
    );
  }

  @override
  List<Object?> get props => [
    gameData,
    remainingSecondsToStart,
    remainingSecondsToExpireAuctionPlayer,
    isReconnecting,   // ✅ important
  ];
}


class GameError extends GameState {
  final String message;

  GameError(this.message);

  @override
  List<Object?> get props => [message];
}
