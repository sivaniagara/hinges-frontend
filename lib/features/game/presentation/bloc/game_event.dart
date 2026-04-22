part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGameData extends GameEvent {
  final String userId;
  final String userName;
  final String auctionCategoryId;
  final String matchType;

  FetchGameData({
    required this.userId,
    required this.userName,
    required this.auctionCategoryId,
    required this.matchType,
  });

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

class BidAuctionPlayer extends GameEvent {
  final String userId;

  BidAuctionPlayer(this.userId);

  @override
  List<Object?> get props => [userId];
}


class GameCountdownTick extends GameEvent {}
class AuctionPlayerTick extends GameEvent {}
class BreakTick extends GameEvent {}

class GameSocketDisconnected extends GameEvent {}

class ReconnectSocket extends GameEvent {}

class ExitMatch extends GameEvent {
  final String userId;
  final String matchId;

  ExitMatch({required this.userId, required this.matchId});

  @override
  List<Object?> get props => [userId, matchId];
}

class RefreshGameData extends GameEvent {}
