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
                    remainingSecondsToExpireAuctionPlayer: _calculateRemaining(gameData.gameCreatedAt, 10)
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
      for(var user in event.gameData.usersStatusList){
        print('user => ${user.userId}');
      }

      emit(currentState.copyWith(
        gameData: game,
        remainingSecondsToStart: game.matchStatus == MatchStatusEnum.notStarted ? _calculateRemaining(game.gameCreatedAt, 120) : null,
        remainingSecondsToExpireAuctionPlayer: game.auctionExpiresAt != null ? _calculateRemaining(game.auctionExpiresAt!, 10) : null
      ));

      if(game.matchStatus == MatchStatusEnum.started){
        if(_timerForAuctionPlayer != null){
          _timerForAuctionPlayer?.cancel();
        }
        _timerForAuctionPlayer = Timer.periodic(
            const Duration(seconds: 1),
                (_){
              print('seconds...');
              add(AuctionPlayerTick());
            });
      }
    });

    on<GameCountdownTick>((event, emit){
      if(state is! GameLoaded) return null;
      final currentState = state as GameLoaded;
      print("currentState.remainingSecondsToStart :: ${currentState.remainingSecondsToStart}");
      if (currentState.remainingSecondsToStart > 0) {
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
      if (currentState.remainingSecondsToExpireAuctionPlayer > 0) {
        emit(
          currentState.copyWith(
            remainingSecondsToExpireAuctionPlayer: currentState.remainingSecondsToExpireAuctionPlayer - 1,
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


  double _calculateRemaining(double gameCreatedAt, secondsLimit) {
    print("gameCreatedAt :: ${gameCreatedAt}");
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    print("nowSeconds :: ${nowSeconds}");

    final elapsed = nowSeconds - gameCreatedAt;
    print("elapsed :: ${elapsed}");
    final startingDuration = secondsLimit - elapsed;
    print("startingDuration :: ${startingDuration}");
    return startingDuration > 0 ? startingDuration : 0;
  }
}