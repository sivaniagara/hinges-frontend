import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/websocket_service.dart';
import '../../data/models/game_data_model.dart';
import '../../utils/game_urls.dart';
import '../../domain/usecase/get_game_data_usecase.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetGameDataUseCase getGameDataUseCase;
  final WebSocketService webSocketService;
  StreamSubscription? _gameDataSubscription;

  GameBloc({
    required this.getGameDataUseCase,
    required this.webSocketService,
  }) : super(GameInitial()) {
    on<FetchGameData>((event, emit) async {
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
              emit(GameLoaded(gameData));

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
      emit(GameLoaded(event.gameData));
    });
  }

  @override
  Future<void> close() {
    _gameDataSubscription?.cancel();
    webSocketService.disconnect();
    return super.close();
  }
}