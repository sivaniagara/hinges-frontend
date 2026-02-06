part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGameData extends GameEvent {
  final String userId;
  final String auctionCategoryId;

  FetchGameData({required this.userId, required this.auctionCategoryId});

  @override
  List<Object?> get props => [userId, auctionCategoryId];
}

class SendGameMessage extends GameEvent {
  final dynamic message;

  SendGameMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class OnGameMessageReceived extends GameEvent {
  final GameDataEntity gameData;

  OnGameMessageReceived(this.gameData);

  @override
  List<Object?> get props => [gameData];
}

class GameCountdownTick extends GameEvent {}
