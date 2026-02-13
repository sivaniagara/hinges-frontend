import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/websocket_service.dart';
import '../../data/models/game_data_model.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../../domain/entities/game_data_entity.dart';
import '../../utils/game_urls.dart';
import '../../domain/usecase/get_game_data_usecase.dart';
part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetGameDataUseCase getGameDataUseCase;
  final WebSocketService webSocketService;
  StreamSubscription? _gameDataSubscription;
  Timer? _timerForExpireMatchDuration;
  Timer? _timerForAuctionPlayer;

  GameBloc({
    required this.getGameDataUseCase,
    required this.webSocketService,
  }) : super(GameInitial()) {
    on<FetchGameData>((event, emit) async {
      print("FetchGameData event called");
      emit(GameLoading());

      final result = await getGameDataUseCase(GetGameDataParam(
          userId: event.userId,
          userName: event.userName,
          auctionCategoryId: event.auctionCategoryId
      ));

      await result.fold(
            (failure) async => emit(GameError(failure.message)),
            (gameData) async {
          // Connect to WebSocket after successfully fetching game data
          final wsUrl = GameUrls.connectMatch.replaceFirst(':matchId', gameData.matchId);
          final wsResult = await webSocketService.connect(wsUrl);

          wsResult.fold(
                (failure) => emit(GameError('Failed to connect to game server: ${failure.message}')),
                (_) {
              emit(
                  GameLoaded(
                      gameData: gameData,
                      remainingSecondsToStart: _calculateRemaining(gameData.gameCreatedAt, 120),
                    remainingSecondsToExpireAuctionPlayer: gameData.auctionExpiresAt == null ? null : _calculateRemainingForPlayerAuction(gameData.auctionExpiresAt!, 10)
                  )
              );
              /// 🔥 IMPORTANT FIX
              if(_timerForExpireMatchDuration != null){
                _timerForExpireMatchDuration?.cancel();
              }else{
                _timerForExpireMatchDuration =
                    Timer.periodic(
                      const Duration(seconds: 1),
                          (_) {
                        add(GameCountdownTick());   // ✅ THIS IS THE FIX
                      },
                    );
              }

              // Start listening for WebSocket messages
              _gameDataSubscription?.cancel();
              _gameDataSubscription = webSocketService.stream.listen((message) {
                try {
                  if(state is! GameLoaded) return;
                  final currentState = state as GameLoaded;
                  GameDataModel oldGameModel = GameDataModel.fromEntity(currentState.gameData);
                  print("message => ${message}");
                  add(OnGameMessageReceived(oldGameModel.dataFromWebSocket(message)));
                } catch (e) {
                  print("Error parsing WebSocket message: $e");
                }
              });
            },
          );
        },
      );
    });

    on<SendGameMessage>((event, emit) {
      webSocketService.send(event.message);
    });

    on<OnGameMessageReceived>((event, emit) {
      if(state is! GameLoaded) return null;
      final currentState = state as GameLoaded;
      final game = event.gameData;
      print("game.auctionExpiresAt => ${game.auctionExpiresAt}");
      emit(currentState.copyWith(
        gameData: game,
        remainingSecondsToStart: game.matchStatus == MatchStatusEnum.notStarted ? _calculateRemaining(game.gameCreatedAt, 120) : null,
        remainingSecondsToExpireAuctionPlayer: game.auctionExpiresAt != null ? _calculateRemainingForPlayerAuction(game.auctionExpiresAt!, 10) : null
      ));

      if(game.matchStatus == MatchStatusEnum.started){
        _timerForAuctionPlayer?.cancel();
        _timerForAuctionPlayer = Timer.periodic(
            const Duration(seconds: 1),
                (_){
              add(AuctionPlayerTick());
            });
      }
    });

    on<GameCountdownTick>((event, emit){
      if(state is! GameLoaded) return null;
      final currentState = state as GameLoaded;
      if(currentState.gameData.matchStatus == MatchStatusEnum.notStarted){
        print("currentState.remainingSecondsToStart :: ${currentState.remainingSecondsToStart}");
        emit(
          currentState.copyWith(
            remainingSecondsToStart: currentState.remainingSecondsToStart - 1,
          ),
        );
      }
    });

    on<AuctionPlayerTick>((event, emit){
      if(state is! GameLoaded) return null;
      final currentState = state as GameLoaded;
      print("currentState.remainingSecondsToExpireAuctionPlayer :: ${currentState.remainingSecondsToExpireAuctionPlayer}");
      if (currentState.remainingSecondsToExpireAuctionPlayer != null && currentState.remainingSecondsToExpireAuctionPlayer! > 0) {
        emit(
          currentState.copyWith(
            remainingSecondsToExpireAuctionPlayer: currentState.remainingSecondsToExpireAuctionPlayer! - 1,
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _gameDataSubscription?.cancel();
    webSocketService.disconnect();
    return super.close();
  }


  double _calculateRemaining(double startAt, secondsLimit) {
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final elapsed = nowSeconds - startAt;
    final startingDuration = secondsLimit - elapsed;
    return startingDuration > 0 ? startingDuration : 0;
  }

  double _calculateRemainingForPlayerAuction(double expireAt, secondsLimit) {
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final remaining = expireAt - nowSeconds;
    return remaining > 0 ? remaining.toDouble() : 0.0;
  }
}