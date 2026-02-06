import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/websocket_service.dart';
import '../../data/models/game_data_model.dart';
import '../../domain/entities/game_data_entity.dart';
import '../../utils/game_urls.dart';
import '../../domain/usecase/get_game_data_usecase.dart';
part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetGameDataUseCase getGameDataUseCase;
  final WebSocketService webSocketService;
  StreamSubscription? _gameDataSubscription;
  Timer? _timerForUpdateRemainingSecondsToStart;

  GameBloc({
    required this.getGameDataUseCase,
    required this.webSocketService,
  }) : super(GameInitial()) {
    on<FetchGameData>((event, emit) async {
      print("FetchGameData event called");
      emit(GameLoading());

      final result = await getGameDataUseCase(GetGameDataParam(
          userId: event.userId,
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
              emit(GameLoaded(gameData: gameData, remainingSecondsToStart: _calculateRemaining(gameData.gameCreatedAt)));
              /// 🔥 IMPORTANT FIX
              if(_timerForUpdateRemainingSecondsToStart != null){
                _timerForUpdateRemainingSecondsToStart?.cancel();
              }else{
                _timerForUpdateRemainingSecondsToStart =
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
                  final updatedGameData = GameDataModel.fromJson(jsonDecode(message));
                  add(OnGameMessageReceived(updatedGameData));
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

      final remaining = _calculateRemaining(game.gameCreatedAt);

      emit(currentState.copyWith(
        gameData: game,
        remainingSecondsToStart: remaining,
      ));
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

  }

  @override
  Future<void> close() {
    _gameDataSubscription?.cancel();
    webSocketService.disconnect();
    return super.close();
  }


  double _calculateRemaining(double gameCreatedAt) {
    print("gameCreatedAt :: ${gameCreatedAt}");
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    print("nowSeconds :: ${nowSeconds}");

    final elapsed = nowSeconds - gameCreatedAt;
    print("elapsed :: ${elapsed}");
    final startingDuration = 120 - elapsed;
    print("startingDuration :: ${startingDuration}");
    return startingDuration > 0 ? startingDuration : 0;
  }
}