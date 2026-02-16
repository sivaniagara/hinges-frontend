import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
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

  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  bool _isReconnecting = false;

  GameBloc({
    required this.getGameDataUseCase,
    required this.webSocketService,
  }) : super(GameInitial()) {

    // ================= FETCH GAME =================
    on<FetchGameData>((event, emit) async {
      try {
        print("FetchGameData event called");
        emit(GameLoading());

        final result = await getGameDataUseCase(
          GetGameDataParam(
            userId: event.userId,
            userName: event.userName,
            auctionCategoryId: event.auctionCategoryId,
          ),
        );

        await result.fold(
              (failure) async => emit(GameError(failure.message)),
              (gameData) async {
            final wsUrl = GameUrls.connectMatch
                .replaceFirst(':matchId', gameData.matchId);

            final wsResult = await webSocketService.connect(wsUrl);

            wsResult.fold(
                  (failure) =>
                  emit(GameError('Failed to connect: ${failure.message}')),
                  (_) {
                    print("websocket connected.....");
                _reconnectAttempts = 0;

                emit(
                  GameLoaded(
                    gameData: gameData,
                    remainingSecondsToStart:
                    _calculateRemaining(gameData.gameCreatedAt, 120),
                    remainingSecondsToExpireAuctionPlayer:
                    gameData.auctionExpiresAt == null
                        ? null
                        : _calculateRemainingForPlayerAuction(
                        gameData.auctionExpiresAt!, 10),
                    isReconnecting: false,
                  ),
                );

                _startMatchCountdown();
                _listenToSocket();
              },
            );
          },
        );
      } catch (e) {
        print('Error: $e');
        emit(GameError(e.toString()));
      }
    });

    // ================= SOCKET DISCONNECT =================
    on<GameSocketDisconnected>((event, emit) async {
      if (_isReconnecting) return;
      if (state is! GameLoaded) return;

      _isReconnecting = true;

      if (_reconnectAttempts >= _maxReconnectAttempts) {
        emit(GameError("Connection lost. Please restart the match."));
        return;
      }

      _reconnectAttempts++;

      final currentState = state as GameLoaded;

      emit(currentState.copyWith(isReconnecting: true));

      final delaySeconds = 2 * _reconnectAttempts; // exponential backoff
      print("Reconnecting in $delaySeconds seconds...");

      await Future.delayed(Duration(seconds: delaySeconds));

      final wsUrl = GameUrls.connectMatch
          .replaceFirst(':matchId', currentState.gameData.matchId);

      final result = await webSocketService.connect(wsUrl);

      result.fold(
            (failure) {
          print("Reconnect failed");
          _isReconnecting = false;
          add(GameSocketDisconnected());
        },
            (_) {
          print("Reconnected successfully");
          _reconnectAttempts = 0;
          _isReconnecting = false;

          emit(currentState.copyWith(isReconnecting: false));

          _listenToSocket();
        },
      );
    });

    on<BidAuctionPlayer>((event, emit){
      Map<String, dynamic> dataToSend = {
        'user_id': event.userId,
        'payload_code': 200
      };
      add(SendGameMessage(dataToSend));
    });

    // ================= SEND MESSAGE =================
    on<SendGameMessage>((event, emit) {
      webSocketService.send(event.message);
    });

    // ================= RECEIVE MESSAGE =================
    on<OnGameMessageReceived>((event, emit) {
      if (state is! GameLoaded) return;

      final currentState = state as GameLoaded;
      final game = event.gameData;

      emit(currentState.copyWith(
        gameData: game,
        remainingSecondsToStart:
        game.matchStatus == MatchStatusEnum.notStarted
            ? _calculateRemaining(game.gameCreatedAt, 120)
            : null,
        remainingSecondsToExpireAuctionPlayer:
        game.auctionExpiresAt != null
            ? _calculateRemainingForPlayerAuction(
            game.auctionExpiresAt!, 10)
            : null,
      ));

      if (game.matchStatus == MatchStatusEnum.started) {
        _startAuctionTimer();
      }
    });

    // ================= MATCH COUNTDOWN =================
    on<GameCountdownTick>((event, emit) {
      if (state is! GameLoaded) return;

      final currentState = state as GameLoaded;

      if (currentState.gameData.matchStatus ==
          MatchStatusEnum.notStarted) {
        final newValue =
            (currentState.remainingSecondsToStart ?? 0) - 1;

        emit(currentState.copyWith(
          remainingSecondsToStart: newValue > 0 ? newValue : 0,
        ));
      }
    });

    // ================= AUCTION TIMER =================
    on<AuctionPlayerTick>((event, emit) {
      if (state is! GameLoaded) return;

      final currentState = state as GameLoaded;

      final remaining =
          currentState.remainingSecondsToExpireAuctionPlayer;
      print("remaining :: ${currentState.remainingSecondsToExpireAuctionPlayer}");

      if (remaining != null && remaining > 0) {
        emit(currentState.copyWith(
          remainingSecondsToExpireAuctionPlayer: remaining - 1,
        ));
      }
    });
  }

  // ================= SOCKET LISTENER =================
  void _listenToSocket() {
    _gameDataSubscription?.cancel();

    _gameDataSubscription = webSocketService.stream.listen(
          (message) {
            print("message => $message");
        if (state is! GameLoaded) return;

        final currentState = state as GameLoaded;

        final oldModel =
        GameDataModel.fromEntity(currentState.gameData);

        add(OnGameMessageReceived(
            oldModel.dataFromWebSocket(message)));
      },
      onDone: () {
        print("Socket closed");
        add(GameSocketDisconnected());
      },
      onError: (error) {
        print("Socket error: $error");
        add(GameSocketDisconnected());
      },
      cancelOnError: true,
    );
  }

  void _startMatchCountdown() {
    _timerForExpireMatchDuration?.cancel();

    _timerForExpireMatchDuration = Timer.periodic(
      const Duration(seconds: 1),
          (_) => add(GameCountdownTick()),
    );
  }

  void _startAuctionTimer() {
    _timerForAuctionPlayer?.cancel();

    _timerForAuctionPlayer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => add(AuctionPlayerTick()),
    );
  }

  @override
  Future<void> close() {
    _gameDataSubscription?.cancel();
    _timerForExpireMatchDuration?.cancel();
    _timerForAuctionPlayer?.cancel();
    webSocketService.disconnect();
    return super.close();
  }

  double _calculateRemaining(double startAt, secondsLimit) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final elapsed = now - startAt;
    final remaining = secondsLimit - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  double _calculateRemainingForPlayerAuction(
      double expireAt, secondsLimit) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final remaining = expireAt - now;
    return remaining > 0 ? remaining.toDouble() : 0.0;
  }
}
