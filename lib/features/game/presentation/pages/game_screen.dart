import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/game/presentation/pages/player_round_starts_in.dart';
import 'package:hinges_frontend/features/game/presentation/pages/player_set_break_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/emoji_button.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/quick_reaction_button.dart';
import 'package:square_progress_indicator/square_progress_indicator.dart';

import 'package:hinges_frontend/core/theme/app_theme.dart';
import 'package:hinges_frontend/core/utils/app_ids.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/utils/constant.dart';
import 'package:hinges_frontend/core/utils/dialog_box_and_bottom_sheet_utils.dart';
import 'package:hinges_frontend/core/network/http_service_impl.dart';
import 'package:hinges_frontend/core/presentation/widgets/adaptive_status_bar.dart';
import 'package:hinges_frontend/core/presentation/widgets/gradient_text.dart';
import 'package:hinges_frontend/features/game/data/models/auction_player_status_model.dart';
import 'package:hinges_frontend/features/game/presentation/pages/result_screen.dart';
import 'package:hinges_frontend/features/game/presentation/pages/strategic_break_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/game_expire_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_auction_status_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_style_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/game_start_duration.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_name_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/accelerated_round_intro.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/widgets/app_background.dart';
import 'package:hinges_frontend/features/home/domain/entities/player_entity.dart';
import 'package:hinges_frontend/features/home/domain/entities/user_data_entity.dart';
import 'package:hinges_frontend/features/home/presentation/pages/profile_screen.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/pages/mini_auction_screen.dart';
import 'package:hinges_frontend/features/game/domain/entities/auction_player_status_entity.dart';
import 'package:hinges_frontend/features/game/domain/entities/game_data_entity.dart';
import 'package:hinges_frontend/features/game/domain/entities/user_status_entity.dart';
import '../bloc/game_bloc.dart';
import '../widgets/chat_buddle.dart';

enum MatchTypeEnum { normalMatch, roomMatch }

extension MatchTypeExtension on MatchTypeEnum {
  String get value {
    switch (this) {
      case MatchTypeEnum.normalMatch:
        return "normal_match";
      case MatchTypeEnum.roomMatch:
        return "room_match";
    }
  }
}

class GameScreen extends StatefulWidget {
  final MiniAuctionLiteMode mode;
  final String auctionCategoryId;
  const GameScreen({super.key, required this.mode, required this.auctionCategoryId});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const List<Color> _redTagColors = [Colors.white, Color(0xffFF1D2B)];
  static const List<Color> _yellowTagColors = [Color(0xff330000), Color(0xffFF1D2B)];

  static const _teamGlowDuration = Duration(milliseconds: 300);
  static const _reconnectDelay = Duration(milliseconds: 500);
  static const _playerImageSize = 90.0;
  final List<GlobalKey> _teamKeys = List.generate(5, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: _handleGameStateListener,
      child: BlocSelector<GameBloc, GameState, MatchStatusEnum?>(
        selector: (state) => state is GameLoaded ? state.gameData.matchStatus : null,
        builder: (context, matchStatus) {
          if (matchStatus == MatchStatusEnum.finished) {
            return ResultScreen(auctionCategoryId: widget.auctionCategoryId,);
          }
          if (matchStatus == MatchStatusEnum.notStarted || matchStatus == MatchStatusEnum.initialMatch) {
            return GameExpireWidget(mode: widget.mode);
          }
          return _buildGameScaffold();
        },
      ),
    );
  }

  void _handleGameStateListener(BuildContext context, GameState state) {
    if (state is GameExitSuccess) {
      context.pushReplacement('/home');
    } else if (state is GameExitError) {
      showGameInfoDialog(context, message: state.message);
    }else if (state is GameLoaded) {
      if(!state.gameData.lastMessage.isShowed){
        final userIndex = state.gameData.usersStatusList.indexWhere((e)=> e.userId == state.gameData.lastMessage.userId);
        showChatPopup(_teamKeys[userIndex], state.gameData.lastMessage.message);
      }
    }
  }

  Widget _buildGameScaffold() {
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.cricketStadium),
              fit: BoxFit.fill,
              opacity: 0.5,
            ),
          ),
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildFirstColumn(),
              Expanded(child: _buildMainContent()),
              _buildThirdColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameError) {
          return _buildRetryWidget(context, state.message);
        }
        if (state is GameInitial || state is GameLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }
        if (state is! GameLoaded) {
          return Container();
        }
        if (state.isReconnecting) {
          return _buildRetryWidget(context, "Connection unstable. Trying to reconnect...");
        }
        return _buildGameContent(state);
      },
    );
  }

  Widget _buildGameContent(GameLoaded state) {
    final homeState = context.read<HomeBloc>().state as HomeLoaded;
    final gameData = state.gameData;
    final playerData = gameData.auctionPlayersStatusList[gameData.currentAuctionPlayerIndex];

    return RefreshIndicator(
      onRefresh: () async {
        context.read<GameBloc>().add(RefreshGameData());
        await Future.delayed(_reconnectDelay);
      },
      color: Colors.amber,
      backgroundColor: Colors.red.withOpacity(0.8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (gameData.breakStatus == BreakStatusEnum.strategicBreak && state.remainingSecondsToExpireBreak! > 5)
                    StrategicBreakWidget(mode: widget.mode)
                  else if (gameData.breakStatus == BreakStatusEnum.strategicBreak && state.remainingSecondsToExpireBreak! <= 5)
                    PlayerRoundStartsIn(playerList: homeState.userData.players, categoryAndItemsEntity: homeState.userData.categoryAndItsItem, auctionPlayerList: gameData.auctionPlayersStatusList,)
                  else if (gameData.breakStatus == BreakStatusEnum.acceleratedBreak)
                      AcceleratedRoundIntro()
                    else if (gameData.breakStatus == BreakStatusEnum.playerSetBreak)
                        PlayerSetBreakWidget(playerList: homeState.userData.players, categoryAndItemsEntity: homeState.userData.categoryAndItsItem, playerData: playerData, auctionPlayerList: gameData.auctionPlayersStatusList,)
                      else
                        _buildPlayerAuctionContent(state, homeState, gameData, playerData),
                  _buildTeamRow(state, gameData),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerAuctionContent(GameLoaded state, HomeLoaded homeState, GameDataEntity gameData, dynamic playerData) {
    if (gameData.matchStatus == MatchStatusEnum.notStarted) {
      return _buildGameExpireLoading(state);
    }
    if (gameData.breakStatus == BreakStatusEnum.acceleratedBreak) {
      return const AcceleratedRoundIntro();
    }
    return _buildPlayerDetails(state, homeState, gameData, playerData);
  }

  Widget _buildPlayerDetails(GameLoaded state, HomeLoaded homeState, GameDataEntity gameData, dynamic playerData) {
    return Column(
      children: [
        Row(
          children: [
            _buildPlayerImage(playerData.playerId),
            Expanded(child: _buildPlayerInfo(state, homeState, gameData, playerData)),
          ],
        ),
        _buildPlayerStats(state, playerData),
      ],
    );
  }

  Widget _buildPlayerImage(String playerId) {
    return Image.network(
      width: 100,
      height: 100,
      "${HttpServiceImpl.ipAddress}images/players/$playerId.png",
    );
  }

  Widget _buildPlayerInfo(GameLoaded state, HomeLoaded homeState, GameDataEntity gameData, dynamic playerData) {
    return Column(
      children: [
        Text(
          playerData.playerName,
          style: GoogleFonts.cinzel(
            textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            PlayerStyleWidget(gameData: gameData),
            Image.asset(
              width: 25,
              height: 25,
              context.read<GameBloc>().getPlayerRoleImage(
                playerData,
                homeState.userData.categoryAndItsItem,
                homeState.userData.players,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildPlayerStatsRow(state, playerData),
      ],
    );
  }

  Widget _buildPlayerStatsRow(GameLoaded state, dynamic playerData) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn('BASE PRICE', context.read<GameBloc>().formatPriceShort(state.gameData.auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex].basePrice)),
        _buildVerticalDivider(),
        _buildStatColumn('RATING', state.gameData.auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex].baseRating.toString()),
        _buildVerticalDivider(),
        _buildCappedPlayerInfo(playerData),
        _buildPlayerFlag(playerData),
      ],
    );
  }

  Widget _buildStatColumn(String label, dynamic value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
        Text(
          value is double ? context.read<GameBloc>().formatPriceShort(value) : value.toString(),
          style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 16, color: AppTheme.borderGold, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return const SizedBox(height: 30, child: VerticalDivider(width: 1));
  }

  Widget _buildCappedPlayerInfo(dynamic playerData) {
    final homeState = context.read<HomeBloc>().state as HomeLoaded;
    final cappedInfo = _getCappedPlayerInfo(playerData, homeState.userData.players);
    return Column(
      children: [
        Image.asset(width: 30, height: 30, cappedInfo.$1),
        Text(cappedInfo.$2, style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 16, color: AppTheme.borderGold, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildPlayerFlag(dynamic playerData) {
    final homeState = context.read<HomeBloc>().state as HomeLoaded;
    return Text(
      context.read<GameBloc>().getPlayerCountryFlag(
        playerData,
        homeState.userData.categoryAndItsItem,
        homeState.userData.players,
      ),
      style: const TextStyle(fontSize: 20),
    );
  }

  Widget _buildPlayerStats(GameLoaded state, dynamic playerData) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.cyanAccent.shade100.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (playerData.playerAuctionStatus == PlayerAuctionStatusEnum.available ||
              playerData.playerAuctionStatus == PlayerAuctionStatusEnum.notShown)
            _buildTimer(state)
          else
            _buildStatusImage(playerData.playerAuctionStatus),
          _buildVerticalDividerWithThickness(),
          _buildCurrentBid(state),
          _buildVerticalDividerWithThickness(),
          _buildBiddingBy(playerData),
        ],
      ),
    );
  }

  Widget _buildTimer(GameLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('TIMER', style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
        Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(AppImages.timerCircle))),
          width: 60,
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${state.remainingSecondsToExpireAuctionPlayer!.toInt()}',
                  style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))),
              Text('SEC', style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusImage(PlayerAuctionStatusEnum status) {
    return Image.asset(
      status == PlayerAuctionStatusEnum.buy ? AppImages.sold : AppImages.unsold,
      width: 80,
      height: 80,
    );
  }

  Widget _buildVerticalDividerWithThickness() {
    return SizedBox(height: 50, child: VerticalDivider(thickness: 0.4));
  }

  Widget _buildCurrentBid(GameLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('CURRENT PRICE',
            style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
        Row(
          children: [
            Image.asset(AppImages.shockWaves, width: 50, height: 20),
            Text(
              context.read<GameBloc>().formatPriceShort(
                  state.gameData.auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex].currentPrice.toDouble()
              ),
              style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 25, color: AppTheme.borderGold, fontWeight: FontWeight.bold)),
            ),
            Image.asset(AppImages.shockWaves, width: 50, height: 20),
          ],
        )
      ],
    );
  }

  Widget _buildBiddingBy(dynamic playerData) {
    final franchise = context.read<GameBloc>().getFranchiseByTeamId(playerData.teamId);
    if (franchise == MiniAuctionFranchiseEnum.empty) return const SizedBox.shrink();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('BIDING BY', style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
        Image.asset(franchise.image(), width: 50, height: 50),
        Text(franchise.shortName(), style: GoogleFonts.cinzel(textStyle: const TextStyle(fontSize: 12, color: AppTheme.borderGold, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildTeamRow(GameLoaded state, GameDataEntity gameData) {
    final homeLoaded = context.read<HomeBloc>().state as HomeLoaded;
    List<UserStatusEntity> otherUser = [];
    List<UserStatusEntity> currentUser = [];
    List<String> otherTeam = [];
    List<String> currentTeam = [];
    for(var user = 0; user < gameData.usersStatusList.length;user++){
      if(gameData.usersStatusList[user].userId != homeLoaded.userData.userId){
        otherUser.add(gameData.usersStatusList[user]);
        otherTeam.add(gameData.teamList[user]);
      }else{
        currentUser.add(gameData.usersStatusList[user]);
        currentTeam.add(gameData.teamList[user]);
      }
    }
    List<UserStatusEntity> userList = [...otherUser, ...currentUser];
    List<String> teamList = [...otherTeam, ...currentTeam];

    return Column(
      children: [
        GestureDetector(
          child: SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                final glow = gameData.auctionPlayersStatusList[gameData.currentAuctionPlayerIndex].teamId == teamList[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        // print("userList[index].userId : ${userList[index].userId}");
                        context.push('/game/mySquad?userId=${userList[index].userId}');
                      },
                      child: _buildTeamCard(
                          userList[index].userName,
                          context.read<GameBloc>().getFranchise(userList, teamList, userList[index].userId).shortName(),
                          context.read<GameBloc>().getFranchise(userList, teamList, userList[index].userId).image(),
                          glow,
                          userList[index].userId,
                          _teamKeys[gameData.usersStatusList.indexWhere((e) => e.userId == userList[index].userId)]
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamCard(
      String userName,
      String franchiseName,
      String franchiseImage,
      bool glow,
      String userId,
      GlobalKey key,
      ) {
    return Container(
      key: key, // 👈 IMPORTANT
      child: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: _teamGlowDuration,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: glow
                      ? [
                    BoxShadow(
                      color: AppTheme.borderGold.withOpacity(0.9),
                      blurRadius: 20,
                      spreadRadius: 4,
                    )
                  ]
                      : [],
                ),
                child: Image.asset(franchiseImage, width: 60, height: 60),
              ),
              Text(
                franchiseName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.cinzel(
                  color: AppTheme.borderGold,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showChatPopup(GlobalKey key, String message) {
    context.read<GameBloc>().add(MessageShowed());
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: position.dx + size.width / 2 - 40,
          top: position.dy - 50,
          child: Material(
            color: Colors.transparent,
            child: ChatBubble(
              message: message,
              onDone: () => entry.remove(),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
  }

  Widget _buildRetryWidget(BuildContext context, String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.amber, size: 60),
            const SizedBox(height: 16),
            Text(
              "CONNECTION LOST",
              style: GoogleFonts.oxanium(
                textStyle: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.jost(textStyle: const TextStyle(fontSize: 14, color: Colors.white70)),
            ),
            const SizedBox(height: 24),
            _buildTag(title: 'TRY AGAIN', tagImage: AppImages.yellowTag, colors: _yellowTagColors, onTap: _handleRetry),
          ],
        ),
      ),
    );
  }

  void _handleRetry() {
    final homeState = context.read<HomeBloc>().state;
    if (homeState is HomeLoaded) {
      context.read<GameBloc>().add(
        FetchGameData(
          userId: homeState.userData.userId,
          userName: homeState.userData.userName,
          auctionCategoryId: homeState.userData.auctionCategoryItem.first.id,
          matchType: MatchTypeEnum.normalMatch.value,
        ),
      );
    }
  }

  Widget _buildGameExpireLoading(GameLoaded loadedState) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          TextSpan(
            text: 'Get ready! Match begins in',
            style: GoogleFonts.jost(textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          TextSpan(
            text: '\n${loadedState.remainingSecondsToStart.round()} seconds...',
            style: const TextStyle(fontFamily: 'Zuume', fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstColumn() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Colors.cyanAccent.shade100.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSideMenu(image: AppImages.hammer, t1: 'CLASSIC', t2: 'ROOM'),
          Row(
            children: [
              const SizedBox(width: 10),
              Image.asset(width: 20, height: 20, AppImages.playerSet),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('PLATER SET', maxLines: 1, style: GoogleFonts.cinzel(color: AppTheme.borderGold, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          // _buildSideMenu(image: AppImages.playerSet, t1: 'PLAYER SET'),
          _buildSideMenu(image: AppImages.bat, t1: 'BATSMEN', onTap: () => _navigateToPlayerList(AppIds.batsmanId, 'BATSMEN')),
          _buildSideMenu(image: AppImages.wicketKeepingGloves, t1: 'WICKET-', t2: 'KEEPERS',
              onTap: () => _navigateToPlayerList(AppIds.wicketKeeperId, 'WICKET KEEPER')),
          _buildSideMenu(image: AppImages.batBall, t1: 'ALL-', t2: 'ROUNDERS',
              onTap: () => _navigateToPlayerList(AppIds.allRounderId, 'ALL ROUNDER')),
          _buildSideMenu(image: AppImages.ball, t1: 'BOWLERS',
              onTap: () => _navigateToPlayerList(AppIds.bowlerId, 'BOWLERS')),
          _buildSideMenu(image: AppImages.ruleBookWhite, t1: 'RULE BOOK'),
          SizedBox(
            width: 150,
            child: Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    width: 60,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Colors.cyan.shade100.withValues(alpha: 0.8))
                    ),
                    child: Column(
                      spacing: 5,
                      children: [
                        Image.asset(width: 20, height: 20, AppImages.setting),
                        Text('SETTINGS', maxLines: 1, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final homeState = context.read<HomeBloc>().state;
                    final gameState = context.read<GameBloc>().state;
                    if (homeState is HomeLoaded && gameState is GameLoaded) {
                      context.read<GameBloc>().add(
                        ExitMatch(
                          userId: homeState.userData.userId,
                          matchId: gameState.gameData.matchId,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 60,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Colors.cyan.shade100.withValues(alpha: 0.8))
                    ),
                    child: Column(
                      spacing: 5,
                      children: [
                        Image.asset(width: 20, height: 20, AppImages.exit),
                        Text('EXIT', maxLines: 1, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2,)
        ],
      ),
    );
  }

  void _navigateToPlayerList(String playerRoleId, String roleName) {
    final homeLoadedState = context.read<HomeBloc>().state as HomeLoaded;
    context.push('/game/playerList?userId=${homeLoadedState.userData.userId}&playerRole=$playerRoleId&playerRoleName=$roleName');
  }

  Widget _buildSideMenu({required String image, required String t1, String? t2, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.cyanAccent.shade100.withValues(alpha: 0.4)))),
        width: 150,
        height: 49,
        child: Row(
          spacing: 10,
          children: [
            const SizedBox(width: 10),
            Image.asset(width: 30, height: 30, image),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t1, maxLines: 1, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                if (t2 != null) Text(t2, maxLines: 1, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdColumn() {
    final userId = (context.read<HomeBloc>().state as HomeLoaded).userData.userId;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Colors.cyanAccent.shade100.withValues(alpha: 0.4)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAuctionerSection(),
          BlocBuilder<GameBloc, GameState>(
              builder: (context, state){
               if(state is GameLoaded){
                 return  _buildTileCard(image: AppImages.playerRound, t1: 'Round ${state.gameData.round}/5');
                }
               return  _buildTileCard(image: AppImages.playerRound, t1: 'Round 0/5');
              }
          ),
          _buildTileCard(image: AppImages.pointsTable, t1: 'POINTS TABLE', onTap: () => context.push('/game/pointsTable')),
          _buildTileCard(image: AppImages.mySquad, t1: 'MY SQUAD', onTap: () => context.push('/game/mySquad?userId=$userId')),
          _buildRemainingPurseCard(userId),
          //emoji
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EmojiButton(),
              QuickReactionButton(),
            ],
          ),
          _buildBidButton(),
        ],
      ),
    );
  }

  Widget _buildAuctionerSection() {
    return const _GlowAuctioneer();
  }

  Widget _buildRemainingPurseCard(String userId) {
    return BlocSelector<GameBloc, GameState, String>(
      selector: (state) {
        if (state is! GameLoaded) return '';
        final user = state.gameData.usersStatusList.firstWhere((e) => e.userId == userId);
        return context.read<GameBloc>().formatPriceShort(user.balanceAmount);
      },
      builder: (context, balance) => _buildTileCard(image: AppImages.purseRem, t1: 'MY PURSE', val: '$balance / 60 CR'),
    );
  }

  Widget _buildBidButton() {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, gameState) {
        if (gameState is! GameLoaded) return const SizedBox.shrink();

        final gameData = gameState.gameData;
        final playerData = gameState.gameData.auctionPlayersStatusList[gameState.gameData.currentAuctionPlayerIndex];

        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, homeState) {
            final gameBloc = context.read<GameBloc>();
            final currentState = homeState as HomeLoaded;
            final isBidDisabled = _shouldDisableBid(currentState.userData.userId, gameBloc, playerData, gameData);

            return GestureDetector(
              onTap: _isThereAmountToBid(currentState.userData.userId) && !isBidDisabled
                  ? () => context.read<GameBloc>().add(BidAuctionPlayer(currentState.userData.userId))
                  : null,
              child: Opacity(
                opacity: isBidDisabled ? 0.2 : 1,
                child: Image.asset(AppImages.bidButton, width: 80, height: 80),
              ),
            );
          },
        );
      },
    );
  }

  bool _shouldDisableBid(String userId, GameBloc gameBloc, dynamic playerData, GameDataEntity gameData) {
    return controlBid(
      playerData,
      gameBloc.getMySquad(userId),
      userId,
    ) || gameBloc.enableBidButton(userId)
        || gameData.breakStatus == BreakStatusEnum.strategicBreak
        || gameData.breakStatus == BreakStatusEnum.auctionPlayerBreak;
  }

  Widget _buildTileCard({required String image, required String t1, String? val, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.cyanAccent.shade100.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(6),
        ),
        width: 165,
        child: Row(
          spacing: 10,
          children: [
            const SizedBox(width: 10),
            Image.asset(width: 30, height: 30, image),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t1, maxLines: 1, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                if (val != null) Text(val, style: GoogleFonts.cinzel(color: Colors.lightGreen, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag({required String title, required String tagImage, required List<Color> colors, double? imageSize, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: imageSize ?? 130,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(tagImage), fit: BoxFit.fill)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GradientText(title: title, colors: colors, fontSize: 16),
          ),
        ),
      ),
    );
  }

  bool _isThereAmountToBid(String userId) {
    final gameBloc = context.read<GameBloc>();
    if (gameBloc.state is! GameLoaded) return false;

    final gameLoadedState = gameBloc.state as GameLoaded;
    final userStatusEntity = gameLoadedState.gameData.usersStatusList.firstWhere((e) => e.userId == userId);
    final auctionPlayerStatusEntity = gameLoadedState.gameData.auctionPlayersStatusList[gameLoadedState.gameData.currentAuctionPlayerIndex];

    return (userStatusEntity.balanceAmount - auctionPlayerStatusEntity.currentPrice) >= 2500000;
  }

  bool controlBid(AuctionPlayerStatusEntity currentPlayer, Map<int, AuctionPlayerStatusEntity?> mySquad, String userId) {
    bool roleCount(String roleId, int limit) {
      return mySquad.values.where((e) =>
      e != null && e.playerRoleId == roleId && e.playerAuctionStatus == PlayerAuctionStatusEnum.buy
      ).length >= limit;
    }

    switch (currentPlayer.playerRoleId) {
      case AppIds.batsmanId:
        return roleCount(AppIds.batsmanId, AppConstant.batsmanLimit);
      case AppIds.wicketKeeperId:
        return roleCount(AppIds.wicketKeeperId, AppConstant.wicketKeeperLimit);
      case AppIds.allRounderId:
        return roleCount(AppIds.allRounderId, AppConstant.allRounderLimit);
      default:
        return roleCount(AppIds.bowlerId, AppConstant.bowlerLimit);
    }
  }

  (String, String) _getCappedPlayerInfo(AuctionPlayerStatusEntity player, List<PlayerEntity> playerList) {
    final playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    switch (playerEntity.playerCategory) {
      case AppIds.indianCappedPlayerId:
        return (AppImages.icp, 'ICP');
      case AppIds.indianUnCappedPlayerId:
        return (AppImages.iup, 'IuP');
      default:
        return (AppImages.fp, 'FP');
    }
  }
}

class _GlowAuctioneer extends StatefulWidget {
  const _GlowAuctioneer();

  @override
  State<_GlowAuctioneer> createState() => _GlowAuctioneerState();
}

class _GlowAuctioneerState extends State<_GlowAuctioneer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glow = Tween<double>(begin: 4, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        return Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                blurRadius: _glow.value,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: ClipOval(
        child: Image.asset(
          AppImages.welcomeAuctioner,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}