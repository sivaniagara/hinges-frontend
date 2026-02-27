import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/websocket_service.dart';
import '../../../../core/utils/app_ids.dart';
import '../../../../core/utils/app_images.dart';
import '../../../home/domain/entities/category_and_items_entity.dart';
import '../../../home/domain/entities/player_entity.dart';
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
                        gameData.auctionExpiresAt!, gameData.serverTime!, 10),
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
        'team_id': getTeamId(event.userId),
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
        (game.auctionExpiresAt != null && game.serverTime != null)
            ? _calculateRemainingForPlayerAuction(
            game.auctionExpiresAt!, game.serverTime!, 10)
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
      double expireAt,
      double serverTime,
      secondsLimit
      ) {
    final remaining = expireAt - serverTime - 1;
    return remaining > 0 ? remaining.toDouble() : 0.0;
  }

  String getTeamId(String userId) {
    if (state is! GameLoaded) return '';
    int indexOfUser = (state as GameLoaded).gameData.usersStatusList.indexWhere((user) => user.userId == userId);
    String givenTeamId = (state as GameLoaded).gameData.usersStatusList[indexOfUser].teamId;
    return givenTeamId;
  }

  bool enableBidButton(String userId){
    final currentState = state as GameLoaded;
    return currentState.gameData.auctionPlayersStatusList[currentState.gameData.currentAuctionPlayerIndex].teamId == getTeamId(userId);
  }

  Map<int, AuctionPlayerStatusEntity?> getMySquad(String userId){
    final currentState = state as GameLoaded;
    Map<int, AuctionPlayerStatusEntity> mySquad = {};
    String batsmanRoleId = '6881ba0f36213beb0017be9c';
    String bowlerRoleId = '6881e28cc8d219cd96a5c4b2';
    String allRounderRoleId = '6881bba636213beb0017be9e';
    String wicketKeeperRoleId = '6881ba3936213beb0017be9d';
    List<AuctionPlayerStatusEntity> batsmanList = [];
    List<AuctionPlayerStatusEntity> bowlerList = [];
    List<AuctionPlayerStatusEntity> allRounderList = [];
    List<AuctionPlayerStatusEntity> wicketKeeperList = [];
    int batsmanStartingPoint = 1;
    int wicketKeeperStartingPoint = 4;
    int allRounderStartingPoint = 6;
    int bowlerStartingPoint = 10;
    for(int i = 0; i < currentState.gameData.auctionPlayersStatusList.length;i++){
      final player = currentState.gameData.auctionPlayersStatusList[i];
      if(player.teamId == getTeamId(userId)){
        if(player.playerRoleId == batsmanRoleId){
          batsmanList.add(player);
        }else if(player.playerRoleId == bowlerRoleId){
          bowlerList.add(player);
        }else if(player.playerRoleId == allRounderRoleId){
          allRounderList.add(player);
        }else if(player.playerRoleId == wicketKeeperRoleId){
          wicketKeeperList.add(player);
        }
      }
    }
    batsmanList = sortPlayerByStatus(batsmanList);
    bowlerList = sortPlayerByStatus(bowlerList);
    allRounderList = sortPlayerByStatus(allRounderList);
    wicketKeeperList = sortPlayerByStatus(wicketKeeperList);
    for(var player = 0;player < batsmanList.length;player++){
      mySquad[batsmanStartingPoint + player] = batsmanList[player];
    }
    for(var player = 0;player < wicketKeeperList.length;player++){
      mySquad[wicketKeeperStartingPoint + player] = wicketKeeperList[player];
    }
    for(var player = 0;player < allRounderList.length;player++){
      mySquad[allRounderStartingPoint + player] = allRounderList[player];
    }
    for(var player = 0;player < bowlerList.length;player++){
      mySquad[bowlerStartingPoint + player] = bowlerList[player];
    }
    return mySquad;
  }

  String getPlayerCountryFlag(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    String playerCountryId = '';
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    playerCountryId = categoryAndItemsEntity.countryCategoryId.firstWhere((e) => e.id == playerEntity.countryId).id;
    Map<String, String> flagMap = {
      '6880d715f960074f0cf61be7': '\u{1F1EE}\u{1F1F3}', // India 🇮🇳
      '6880d71ef960074f0cf61be8': '\u{1F1E6}\u{1F1FA}', // Australia 🇦🇺
      '6880d725f960074f0cf61be9': '\u{1F1EC}\u{1F1E7}', // England 🇬🇧
      '6880d72bf960074f0cf61bea': '\u{1F1F5}\u{1F1F0}', // Pakistan 🇵🇰
      '6880d734f960074f0cf61beb': '\u{1F1F3}\u{1F1FF}', // New Zealand 🇳🇿
      '6880d73ff960074f0cf61bec': '\u{1F1FF}\u{1F1E6}', // South Africa 🇿🇦
      '6880d748f960074f0cf61bed': '\u{1F1F1}\u{1F1F0}', // Sri Lanka 🇱🇰
      '6880d751f960074f0cf61bee': '\u{1F1F2}\u{1F1FC}', // West Indies (Montserrat 🇲🇸 often used)
      '6880d759f960074f0cf61bef': '\u{1F1E7}\u{1F1E9}', // Bangladesh 🇧🇩
      '6880d760f960074f0cf61bf0': '\u{1F1E6}\u{1F1EB}', // Afghanistan 🇦🇫
      '6880d766f960074f0cf61bf1': '\u{1F1EE}\u{1F1EA}', // Ireland 🇮🇪
      '6880d76df960074f0cf61bf2': '\u{1F1FF}\u{1F1FC}', // Zimbabwe 🇿🇼
    };
    if(flagMap.containsKey(playerCountryId)){
      return flagMap[playerCountryId]!;
    }else{
      return 'N/A';
    }
  }

  String getPlayerRoleImage(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    String playerRoleId = '';
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    playerRoleId = categoryAndItemsEntity.playerRoleCategoryId.firstWhere((e) => e.id == playerEntity.playerRole).id;
    Map<String, String> roleCategory = {
      '6881ba0f36213beb0017be9c': AppImages.batsmanIcon,
      '6881ba3936213beb0017be9d': AppImages.wicketKeeperIcon,
      '6881bba636213beb0017be9e': AppImages.allRounderIcon,
      '6881e28cc8d219cd96a5c4b2': AppImages.bowlerIcon,
    };

    if(roleCategory.containsKey(playerRoleId)){
      return roleCategory[playerRoleId]!;
    }else{
      return 'N/A';
    }
  }


  List<AuctionPlayerStatusEntity> sortPlayerByStatus(List<AuctionPlayerStatusEntity> listOfPlayer){
    listOfPlayer.sort((a, b) {
      if (a.playerAuctionStatus == PlayerAuctionStatusEnum.sold &&
          b.playerAuctionStatus != PlayerAuctionStatusEnum.sold) {
        return -1; // a comes first
      } else if (a.playerAuctionStatus != PlayerAuctionStatusEnum.sold &&
          b.playerAuctionStatus == PlayerAuctionStatusEnum.sold) {
        return 1; // b comes first
      }
      return 0; // keep original order
    });
    return listOfPlayer;
  }

  String getRole(int position){
    if(position >= 1 && position <= 3){
      return 'BAT ${getRoleCount(1, 3, position)}';
    }else if(position >= 4 && position <= 5){
      return 'WK ${getRoleCount(4, 5, position)}';
    }else if(position >= 6 && position <= 9){
     return 'AL ${getRoleCount(6, 9, position)}';
    }else if(position >= 10 && position <= 12){
      return 'BWL ${getRoleCount(10, 12, position)}';
    }else{
      return '';
    }
  }

  String getRoleById(String playerRoleId){
    if(playerRoleId == AppIds.batsmanId){
      return 'BAT';
    }else if(playerRoleId == AppIds.bowlerId){
      return 'BWL';
    }else if(playerRoleId == AppIds.wicketKeeperId){
      return 'WK';
    }else if(playerRoleId == AppIds.allRounderId){
      return 'AL';
    }else{
      return '';
    }
  }

  int getRoleCount(int start, int end, int position){
    if(start == position){
      return 1;
    }else if(end == position){
      return (end + 1) - start;
    }else{
      return ((end + 1) - start) - (end - position);
    }
  }

  double getRating(String userId){
    double totalRating = 0.0;
    Map<int, AuctionPlayerStatusEntity?> squad = getMySquad(userId);
    for(var player in squad.values){
      if(player != null){
        totalRating += player.baseRating;
      }
    }
    return totalRating;
  }
}