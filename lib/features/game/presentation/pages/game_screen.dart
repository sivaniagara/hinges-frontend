import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/theme/app_theme.dart';
import 'package:hinges_frontend/core/utils/app_ids.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/utils/constant.dart';
import 'package:hinges_frontend/core/utils/dialog_box_and_bottom_sheet_utils.dart';
import 'package:hinges_frontend/features/game/data/models/auction_player_status_model.dart';
import 'package:hinges_frontend/features/game/presentation/pages/result_screen.dart';
import 'package:hinges_frontend/features/game/presentation/pages/strategic_break_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/game_expire_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_auction_status_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_style_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/game_start_duration.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_name_widget.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/widgets/app_background.dart';
import '../../../../core/network/http_service_impl.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/presentation/widgets/gradient_text.dart';
import '../../../home/domain/entities/player_entity.dart';
import '../../../home/domain/entities/user_data_entity.dart';
import '../../../home/presentation/pages/profile_screen.dart';
import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../../mini_auction/presentation/pages/mini_auction_screen.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../../domain/entities/game_data_entity.dart';
import '../../domain/entities/user_status_entity.dart';
import '../bloc/game_bloc.dart';
import 'package:square_progress_indicator/square_progress_indicator.dart';

import '../widgets/accelerated_round_intro.dart';

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
  const GameScreen({super.key, required this.mode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Color> textColorForRedTag = [Colors.white, const Color(0xffFF1D2B)];
  List<Color> textColorForYellowTag = [
    const Color(0xff330000),
    const Color(0xffFF1D2B)
  ];

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
    final size = MediaQuery.sizeOf(context);
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameExitSuccess) {
          context.pushReplacement('/miniAuctionLiteMode');
        } else if (state is GameExitError) {
          showGameInfoDialog(context, message: state.message);
        }
      },
      child: BlocSelector<GameBloc, GameState, MatchStatusEnum?>(
        selector: (state) =>
        state is GameLoaded ? state.gameData.matchStatus : null,
        builder: (context, matchStatus) {
          if (matchStatus == MatchStatusEnum.finished) {
            return const ResultScreen();
          }
          if(matchStatus == MatchStatusEnum.notStarted || matchStatus == MatchStatusEnum.initialMatch){
            return GameExpireWidget(mode: widget.mode);
          }

          return AdaptiveStatusBar(
            color: Theme.of(context).colorScheme.surface,
            child: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        AppImages.cricketStadium,
                      ),
                    fit: BoxFit.fill,
                    opacity: 0.5
                  )
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    firstColumn(),
                    Expanded(
                      child: BlocBuilder<GameBloc, GameState>(
                        builder: (context, state) {
                          if (state is GameError) {
                            return _buildRetryWidget(context, state.message);
                          }

                          if (state is GameInitial ||
                              state is GameLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            );
                          }

                          if (state is! GameLoaded) {
                            return Container();
                          }

                          if (state.isReconnecting) {
                            return _buildRetryWidget(context,
                                "Connection unstable. Trying to reconnect...");
                          }

                          final userState =
                          context.read<HomeBloc>().state as HomeLoaded;
                          GameDataEntity gameData = state.gameData;
                          final playerData = state.gameData
                              .auctionPlayersStatusList[state
                              .gameData.currentAuctionPlayerIndex];
                          print(" playerData : ${playerData.playerAuctionStatus}");

                          return RefreshIndicator(
                            onRefresh: () async {
                              context.read<GameBloc>().add(RefreshGameData());
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                            },
                            color: Colors.amber,
                            backgroundColor: Colors.red.withOpacity(0.8),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      if(state.gameData.breakStatus == BreakStatusEnum.strategicBreak)
                                        StrategicBreakWidget(mode: widget.mode)
                                      else
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            if (state.gameData.matchStatus ==
                                                MatchStatusEnum.notStarted)
                                              gameExpireLoadingWidget(state)
                                            // else if (state.gameData.matchStatus ==
                                            //     MatchStatusEnum.initialMatch)
                                            //   const GameStartDuration()
                                            // else if (state.gameData.breakStatus ==
                                            //       BreakStatusEnum.auctionPlayerBreak)
                                            //     PlayerAuctionStatusWidget(
                                            //         gameData: gameData,
                                            //         playerData: playerData,
                                            //         state: state
                                            //     )
                                              else if (state.gameData.breakStatus ==
                                                    BreakStatusEnum.acceleratedBreak)
                                                  const AcceleratedRoundIntro()
                                                else
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.network(
                                                            width: 100,
                                                            height: 100,
                                                            "${HttpServiceImpl.ipAddress}images/players/${playerData.playerId}.png",
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                Text(playerData.playerName, style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 20, fontWeight: FontWeight.bold)),),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  spacing: 10,
                                                                  children: [
                                                                    PlayerStyleWidget(gameData: gameData),
                                                                    Image.asset(
                                                                        width: 25,
                                                                        height: 25,
                                                                        context
                                                                            .read<
                                                                            GameBloc>()
                                                                            .getPlayerRoleImage(
                                                                            playerData,
                                                                            userState
                                                                                .userData
                                                                                .categoryAndItsItem,
                                                                            userState
                                                                                .userData
                                                                                .players)),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10,),
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Text('BASE PRICE', style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
                                                                        Text(context
                                                                            .read<
                                                                            GameBloc>()
                                                                            .formatPriceShort(state
                                                                            .gameData
                                                                            .auctionPlayersStatusList[state
                                                                            .gameData
                                                                            .currentAuctionPlayerIndex]
                                                                            .basePrice),
                                                                            style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 16, color: AppTheme.borderGold, fontWeight: FontWeight.bold))),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 30,
                                                                      child: VerticalDivider(
                                                                        width: 1,
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Text('RATING', style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
                                                                        Text('${state.gameData.auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex].baseRating}',
                                                                            style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 16, color: AppTheme.borderGold, fontWeight: FontWeight.bold))),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 30,
                                                                      child: VerticalDivider(
                                                                        width: 1,
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Image.asset(
                                                                          width: 30,
                                                                          height: 30,
                                                                            cappedPlayer(playerData, userState.userData.players).$1
                                                                        ),
                                                                        Text(cappedPlayer(playerData, userState.userData.players).$2,
                                                                            style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 16, color: AppTheme.borderGold, fontWeight: FontWeight.bold))),
                                                                      ],
                                                                    ),

                                                                    Text(
                                                                      context
                                                                          .read<
                                                                          GameBloc>()
                                                                          .getPlayerCountryFlag(
                                                                          playerData,
                                                                          userState
                                                                              .userData
                                                                              .categoryAndItsItem,
                                                                          userState
                                                                              .userData
                                                                              .players),
                                                                      style:
                                                                      const TextStyle(
                                                                          fontSize:
                                                                          20),
                                                                    )

                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(width: 1, color: Colors.cyanAccent.shade100.withValues(alpha: 0.6)),
                                                          borderRadius: BorderRadius.circular(20)
                                                        ),
                                                        width: double.infinity,
                                                        height: 100,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            if(playerData.playerAuctionStatus == PlayerAuctionStatusEnum.available || playerData.playerAuctionStatus == PlayerAuctionStatusEnum.notShown)
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text('TIMER', style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image: AssetImage(AppImages.timerCircle)
                                                                        )
                                                                    ),
                                                                    width: 60,
                                                                    height: 60,
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Text('${state.remainingSecondsToExpireAuctionPlayer!.toInt()}', style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))),
                                                                        Text('SEC', style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            else
                                                              Image.asset(
                                                                  playerData.playerAuctionStatus == PlayerAuctionStatusEnum.buy
                                                                      ? AppImages.sold : AppImages.unsold,
                                                                width: 80,
                                                                height: 80,
                                                              ),
                                                            SizedBox(
                                                              height: 50,
                                                              child: VerticalDivider(
                                                                thickness: 0.4,
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                    playerData.basePrice == playerData.basePrice ? 'BASE PRISE' : 'CURRENT BID',
                                                                    style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                        AppImages.shockWaves,
                                                                      width: 50,
                                                                      height: 20,
                                                                    ),
                                                                    Text(
                                                                        context.read<GameBloc>().formatPriceShort(state.gameData.auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex].currentPrice.toDouble()),
                                                                        style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 25, color: AppTheme.borderGold, fontWeight: FontWeight.bold))),
                                                                    Image.asset(
                                                                        AppImages.shockWaves,
                                                                      width: 50,
                                                                      height: 20,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 50,
                                                              child: VerticalDivider(
                                                                thickness: 0.4,
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text('BIDING BY', style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
                                                                if(context.read<GameBloc>().getFranchiseByTeamId(playerData.teamId) != MiniAuctionFranchiseEnum.empty)
                                                                  ...[
                                                                    Image.asset(
                                                                      context.read<GameBloc>().getFranchiseByTeamId(playerData.teamId).image(),
                                                                      width: 50,
                                                                      height: 50,
                                                                    ),
                                                                    Text(context.read<GameBloc>().getFranchiseByTeamId(playerData.teamId).shortName(), style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 12, color: AppTheme.borderGold, fontWeight: FontWeight.bold))),
                                                                  ]
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Column(
                                                  //   children: [
                                                  //     getTag(
                                                  //         title: '${getPlayerRole(gameData).toUpperCase()} SET',
                                                  //         tagImage: AppImages.redTag,
                                                  //         colors: textColorForRedTag,
                                                  //         imageSize: 200
                                                  //     ),
                                                  //     const SizedBox(height: 20),
                                                  //     Row(
                                                  //       mainAxisAlignment:
                                                  //       MainAxisAlignment.spaceAround,
                                                  //       spacing: 10,
                                                  //       children: [
                                                  //         if (state.remainingSecondsToExpireAuctionPlayer !=
                                                  //             null)
                                                  //           TweenAnimationBuilder<double>(
                                                  //             tween: Tween(
                                                  //               begin: 1,
                                                  //               end: state
                                                  //                   .remainingSecondsToExpireAuctionPlayer! /
                                                  //                   10,
                                                  //             ),
                                                  //             duration: Duration(
                                                  //                 seconds: state.remainingSecondsToExpireAuctionPlayer! >
                                                  //                     9
                                                  //                     ? 0
                                                  //                     : 1),
                                                  //             curve: Curves.linear,
                                                  //             builder: (context,
                                                  //                 animatedValue,
                                                  //                 child) {
                                                  //               return SquareProgressIndicator(
                                                  //                 value: animatedValue,
                                                  //                 width: 90,
                                                  //                 height: 90,
                                                  //                 borderRadius: 8,
                                                  //                 startPosition:
                                                  //                 StartPosition
                                                  //                     .topCenter,
                                                  //                 strokeCap:
                                                  //                 StrokeCap.square,
                                                  //                 clockwise: false,
                                                  //                 color: state.remainingSecondsToExpireAuctionPlayer! <
                                                  //                     4
                                                  //                     ? Colors.red
                                                  //                     : Colors.yellow,
                                                  //                 emptyStrokeColor:
                                                  //                 Colors.yellow
                                                  //                     .withValues(
                                                  //                     alpha:
                                                  //                     0.1),
                                                  //                 strokeWidth: 4,
                                                  //                 emptyStrokeWidth: 4,
                                                  //                 strokeAlign:
                                                  //                 SquareStrokeAlign
                                                  //                     .outside,
                                                  //                 child: child,
                                                  //               );
                                                  //             },
                                                  //             child: ClipRRect(
                                                  //               borderRadius:
                                                  //               BorderRadius
                                                  //                   .circular(6),
                                                  //               child: BlocSelector<
                                                  //                   GameBloc,
                                                  //                   GameState,
                                                  //                   String>(
                                                  //                   selector: (state) {
                                                  //                     if (state is! GameLoaded)
                                                  //                       return '';
                                                  //                     return state
                                                  //                         .gameData
                                                  //                         .auctionPlayersStatusList[state
                                                  //                         .gameData
                                                  //                         .currentAuctionPlayerIndex]
                                                  //                         .playerId;
                                                  //                   },
                                                  //                   builder: (context,
                                                  //                       value) {
                                                  //                     return Image
                                                  //                         .network(
                                                  //                       width: 90,
                                                  //                       height: 90,
                                                  //                       "${HttpServiceImpl.ipAddress}images/players/$value.png",
                                                  //                     );
                                                  //                   }),
                                                  //             ),
                                                  //           ),
                                                  //         Column(
                                                  //           crossAxisAlignment:
                                                  //           CrossAxisAlignment
                                                  //               .start,
                                                  //           spacing: 2,
                                                  //           children: [
                                                  //             Row(
                                                  //               spacing: 10,
                                                  //               children: [
                                                  //                 PlayerNameWidget(
                                                  //                     gameData:
                                                  //                     gameData),
                                                  //                 Image.asset(
                                                  //                     width: 25,
                                                  //                     height: 25,
                                                  //                     context
                                                  //                         .read<
                                                  //                         GameBloc>()
                                                  //                         .getPlayerRoleImage(
                                                  //                         playerData,
                                                  //                         userState
                                                  //                             .userData
                                                  //                             .categoryAndItsItem,
                                                  //                         userState
                                                  //                             .userData
                                                  //                             .players)),
                                                  //                 if (isCappedPlayer(
                                                  //                     playerData,
                                                  //                     userState
                                                  //                         .userData
                                                  //                         .players))
                                                  //                   Image.asset(
                                                  //                       width: 25,
                                                  //                       height: 25,
                                                  //                       AppImages.cap),
                                                  //                 Text(
                                                  //                   context
                                                  //                       .read<
                                                  //                       GameBloc>()
                                                  //                       .getPlayerCountryFlag(
                                                  //                       playerData,
                                                  //                       userState
                                                  //                           .userData
                                                  //                           .categoryAndItsItem,
                                                  //                       userState
                                                  //                           .userData
                                                  //                           .players),
                                                  //                   style:
                                                  //                   const TextStyle(
                                                  //                       fontSize:
                                                  //                       20),
                                                  //                 )
                                                  //               ],
                                                  //             ),
                                                  //             PlayerStyleWidget(
                                                  //                 gameData:
                                                  //                 gameData),
                                                  //             const SizedBox(height: 10),
                                                  //             Row(
                                                  //               spacing: 10,
                                                  //               children: [
                                                  //                 Column(
                                                  //                   children: [
                                                  //                     Text(
                                                  //                         'BASE PRICE',
                                                  //                         style: GoogleFonts.jost(
                                                  //                             textStyle: const TextStyle(
                                                  //                                 fontSize:
                                                  //                                 15,
                                                  //                                 color:
                                                  //                                 Colors.white,
                                                  //                                 fontWeight:
                                                  //                                 FontWeight
                                                  //                                     .bold))),
                                                  //                     Text(
                                                  //                       context
                                                  //                           .read<
                                                  //                           GameBloc>()
                                                  //                           .formatPriceShort(state
                                                  //                           .gameData
                                                  //                           .auctionPlayersStatusList[state
                                                  //                           .gameData
                                                  //                           .currentAuctionPlayerIndex]
                                                  //                           .basePrice),
                                                  //                       style:
                                                  //                       const TextStyle(
                                                  //                         fontSize:
                                                  //                         20,
                                                  //                         color: Colors
                                                  //                             .white,
                                                  //                       ),
                                                  //                     ),
                                                  //                   ],
                                                  //                 ),
                                                  //                 Container(
                                                  //                   width: 0.5,
                                                  //                   height: 20,
                                                  //                   color:
                                                  //                   Colors.white,
                                                  //                 ),
                                                  //                 Column(
                                                  //                   children: [
                                                  //                     Text(
                                                  //                         'RATING',
                                                  //                         style: GoogleFonts.jost(
                                                  //                             textStyle: const TextStyle(
                                                  //                                 fontSize:
                                                  //                                 15,
                                                  //                                 color:
                                                  //                                 Colors.white,
                                                  //                                 fontWeight:
                                                  //                                 FontWeight
                                                  //                                     .bold))),
                                                  //                     Text(
                                                  //                       '${state.gameData.auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex].baseRating}',
                                                  //                       style:
                                                  //                       const TextStyle(
                                                  //                         fontSize:
                                                  //                         20,
                                                  //                         color: Colors
                                                  //                             .white,
                                                  //                       ),
                                                  //                     ),
                                                  //                   ],
                                                  //                 ),
                                                  //               ],
                                                  //             )
                                                  //           ],
                                                  //         )
                                                  //       ],
                                                  //     ),
                                                  //   ],
                                                  // ),
                                          ],
                                        ),
                                      SizedBox(
                                        height: 100,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: List.generate(5, (index){
                                          final glow = state
                                              .gameData
                                              .auctionPlayersStatusList[state
                                              .gameData
                                              .currentAuctionPlayerIndex]
                                              .teamId ==
                                              gameData.teamList[index];
                                            return _cardContent(
                                              state.gameData.usersStatusList[index].userName,
                                              context.read<GameBloc>().getFranchise(state.gameData.usersStatusList, state.gameData.teamList, state.gameData.usersStatusList[index].userId).shortName(),
                                              context.read<GameBloc>().getFranchise(state.gameData.usersStatusList, state.gameData.teamList, state.gameData.usersStatusList[index].userId).image(),
                                              glow
                                            );
                                          }),
                                        ),
                                      ),

                                      // Container(
                                      //   width: double.infinity,
                                      //   height: MediaQuery.of(context)
                                      //       .size
                                      //       .height *
                                      //       0.5,
                                      //   decoration: BoxDecoration(
                                      //     image: const DecorationImage(
                                      //       image: AssetImage(
                                      //           AppImages.auctionCard),
                                      //       fit: BoxFit.fill,
                                      //     ),
                                      //     borderRadius:
                                      //     BorderRadius.circular(40),
                                      //   ),
                                      //   child: Stack(
                                      //     children: [
                                      //       if (state.gameData.matchStatus ==
                                      //           MatchStatusEnum.started)
                                      //         Align(
                                      //           alignment:
                                      //           Alignment.topCenter,
                                      //           child: Padding(
                                      //             padding:
                                      //             const EdgeInsets.only(
                                      //                 top: 20),
                                      //             child: BlocSelector<
                                      //                 GameBloc,
                                      //                 GameState,
                                      //                 double>(
                                      //               selector: (state) =>
                                      //               state is GameLoaded
                                      //                   ? state
                                      //                   .gameData
                                      //                   .auctionPlayersStatusList[state
                                      //                   .gameData
                                      //                   .currentAuctionPlayerIndex]
                                      //                   .currentPrice
                                      //                   .toDouble()
                                      //                   : 0.0,
                                      //               builder: (context,
                                      //                   currentPrice) {
                                      //                 return RichText(
                                      //                   textAlign:
                                      //                   TextAlign
                                      //                       .center,
                                      //                   text: TextSpan(
                                      //                     style: Theme.of(
                                      //                         context)
                                      //                         .textTheme
                                      //                         .bodyLarge,
                                      //                     children: [
                                      //                       TextSpan(
                                      //                         text:
                                      //                         'CURRENT BID',
                                      //                         style: GoogleFonts.jost(
                                      //                             textStyle:
                                      //                             const TextStyle(
                                      //                               fontSize:
                                      //                               16,
                                      //                               color: Colors
                                      //                                   .white,
                                      //                               fontWeight:
                                      //                               FontWeight
                                      //                                   .bold,
                                      //                             )),
                                      //                       ),
                                      //                       TextSpan(
                                      //                         text:
                                      //                         '  ${context.read<GameBloc>().formatPriceShort(currentPrice)}',
                                      //                         style:
                                      //                         const TextStyle(
                                      //                           fontSize:
                                      //                           20,
                                      //                         ),
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                 );
                                      //               },
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ...MiniAuctionFranchiseEnum
                                      //           .values
                                      //           .map((franchise) {
                                      //         return BlocSelector<
                                      //             GameBloc,
                                      //             GameState,
                                      //             (bool, bool,
                                      //             UserStatusEntity?)>(
                                      //           selector: (state) {
                                      //             if (state is! GameLoaded)
                                      //               return (false,
                                      //               false, null);
                                      //             final teamId =
                                      //             franchise.teamId();
                                      //             final exists = state
                                      //                 .gameData
                                      //                 .usersStatusList
                                      //                 .any((user) =>
                                      //             user.teamId ==
                                      //                 teamId);
                                      //             final glow = state
                                      //                 .gameData
                                      //                 .auctionPlayersStatusList[state
                                      //                 .gameData
                                      //                 .currentAuctionPlayerIndex]
                                      //                 .teamId ==
                                      //                 teamId;
                                      //             final user = exists
                                      //                 ? state
                                      //                 .gameData
                                      //                 .usersStatusList
                                      //                 .firstWhere((u) =>
                                      //             u.teamId ==
                                      //                 teamId)
                                      //                 : null;
                                      //             return (exists,
                                      //             glow, user);
                                      //           },
                                      //           builder:
                                      //               (context, data) {
                                      //             final (exists, glow,
                                      //             user) = data;
                                      //             if (!exists ||
                                      //                 user == null)
                                      //               return const SizedBox
                                      //                   .shrink();
                                      //
                                      //             Alignment alignment;
                                      //             if (franchise ==
                                      //                 MiniAuctionFranchiseEnum
                                      //                     .csk) {
                                      //               alignment =
                                      //               const Alignment(
                                      //                   -0.7, -0.6);
                                      //             } else if (franchise ==
                                      //                 MiniAuctionFranchiseEnum
                                      //                     .mi) {
                                      //               alignment =
                                      //               const Alignment(
                                      //                   0.7, -0.6);
                                      //             } else if (franchise ==
                                      //                 MiniAuctionFranchiseEnum
                                      //                     .rcb) {
                                      //               alignment =
                                      //               const Alignment(
                                      //                   0.7, 0.7);
                                      //             } else if (franchise ==
                                      //                 MiniAuctionFranchiseEnum
                                      //                     .kkr) {
                                      //               alignment =
                                      //               const Alignment(
                                      //                   -0.7, 0.7);
                                      //             } else {
                                      //               alignment =
                                      //                   Alignment.center;
                                      //             }
                                      //
                                      //             return Align(
                                      //               alignment:
                                      //               alignment,
                                      //               child:
                                      //               getFranchiseLogo(
                                      //                 imagePath:
                                      //                 _getFranchiseLogoPath(
                                      //                     franchise),
                                      //                 user: user,
                                      //                 glow: glow,
                                      //               ),
                                      //             );
                                      //           },
                                      //         );
                                      //       }),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    thirdColumn(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _cardContent(String userName, String franchiseName, String franchiseImage, bool glow) {
    return Column(
      spacing: 10,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: glow
                ? [
              BoxShadow(
                color: AppTheme.borderGold.withOpacity(0.9),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ]
                : [
              BoxShadow(
                color: Colors.transparent,
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Image.asset(
            franchiseImage,
            width: 60,
            height: 60,
          ),
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
        // Text(
        //   userName,
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        //   textAlign: TextAlign.center,
        //   style: GoogleFonts.cinzel(
        //     color: AppTheme.borderGold,
        //     fontSize: 12,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),

      ],
    );
  }

  // Rest of your methods remain the same...
  Widget _miniStat({
    required String title,
    required String value,x
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getFranchiseLogoPath(MiniAuctionFranchiseEnum franchise) {
    switch (franchise) {
      case MiniAuctionFranchiseEnum.csk:
        return AppImages.csk;
      case MiniAuctionFranchiseEnum.mi:
        return AppImages.mi;
      case MiniAuctionFranchiseEnum.kkr:
        return AppImages.kkr;
      case MiniAuctionFranchiseEnum.srh:
        return AppImages.srh;
      case MiniAuctionFranchiseEnum.rcb:
        return AppImages.rcb;
      default:
        return '';
    }
  }

  bool isCappedPlayer(
      AuctionPlayerStatusEntity player, List<PlayerEntity> playerList) {
    PlayerEntity playerEntity =
    playerList.firstWhere((e) => e.playerId == player.playerId);
    return playerEntity.playerCategory == AppIds.indianCappedPlayerId;
  }

  (String, String) cappedPlayer(
      AuctionPlayerStatusEntity player, List<PlayerEntity> playerList) {
    PlayerEntity playerEntity =
    playerList.firstWhere((e) => e.playerId == player.playerId);
    if(playerEntity.playerCategory == AppIds.indianCappedPlayerId){
      return (AppImages.icp, 'ICP');
    }else if(playerEntity.playerCategory == AppIds.indianUnCappedPlayerId){
      return (AppImages.iup, 'IuP');
    }else{
      return (AppImages.fp, 'FP');
    }
  }

  UserStatusEntity getUser(List<UserStatusEntity> userList, String teamId) {
    UserStatusEntity? userStatusEntity;
    for (var user in userList) {
      if (user.teamId == teamId) {
        userStatusEntity = user;
        break;
      }
    }
    return userStatusEntity!;
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
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.jost(
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 24),
            getTag(
              title: 'TRY AGAIN',
              tagImage: AppImages.yellowTag,
              colors: textColorForYellowTag,
              onTap: () {
                final homeState = context.read<HomeBloc>().state;
                if (homeState is HomeLoaded) {
                  context.read<GameBloc>().add(
                    FetchGameData(
                      userId: homeState.userData.userId,
                      userName: homeState.userData.userName,
                      auctionCategoryId:
                      homeState.userData.auctionCategoryItem.first.id,
                      matchType: MatchTypeEnum.normalMatch.value,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget gameExpireLoadingWidget(GameLoaded loadedState) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          TextSpan(
            text: 'Get ready! Match begins in',
            style: GoogleFonts.jost(
                textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
          TextSpan(
            text: '\n${(loadedState).remainingSecondsToStart.round()} seconds...',
            style: const TextStyle(
              fontFamily: 'Zuume',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget getFranchiseLogo({
    required String imagePath,
    required UserStatusEntity user,
    required bool glow,
  }) {
    return GestureDetector(
      onTap: () {
        context.push('/game/mySquad?userId=${user.userId}');
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: glow ? 45 : 40,
              height: glow ? 45 : 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: glow
                      ? [
                    const BoxShadow(
                      color: Colors.yellow,
                      blurRadius: 15,
                      spreadRadius: 6,
                    ),
                  ]
                      : null,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      imagePath,
                    ),
                  )),
            ),
            Text(
                user.userName,
                style: GoogleFonts.jost(
                    textStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))
            )
          ],
        ),
      ),
    );
  }

  Widget firstColumn() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Colors.cyanAccent.shade100.withValues(alpha: 0.4))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          sideMenu(
              image: AppImages.hammer,
              t1: 'AUCTION',
              t2: 'ROOM',
              onTap: (){
              }
          ),
          sideMenu(
              image: AppImages.playerSet,
              t1: 'PLAYER SET',
              onTap: (){

              }
          ),
          sideMenu(
              image: AppImages.bat,
              t1: 'BATSMEN',
              onTap: () {
                final homeLoadedState = context.read<HomeBloc>().state as HomeLoaded;
                context.push('/game/playerList?userId=${homeLoadedState.userData.userId}&playerRole=${AppIds.batsmanId}&playerRoleName=BATSMEN');
              }
          ),
          sideMenu(
              image: AppImages.wicketKeepingGloves,
              t1: 'WICKET-',
              t2: 'KEEPERS',
              onTap: () {
                final homeLoadedState = context.read<HomeBloc>().state as HomeLoaded;
                context.push(
                    '/game/playerList?userId=${homeLoadedState.userData.userId}&playerRole=${AppIds.wicketKeeperId}&playerRoleName=WICKET KEEPER');
              }
          ),
          sideMenu(
              image: AppImages.batBall,
              t1: 'ALL-',
              t2: 'ROUNDERS',
              onTap: () {
                final homeLoadedState = context.read<HomeBloc>().state as HomeLoaded;
                context.push(
                    '/game/playerList?userId=${homeLoadedState.userData.userId}&playerRole=${AppIds.allRounderId}&playerRoleName=ALL ROUNDER');
              }
          ),
          sideMenu(
              image: AppImages.batBall,
              t1: 'BOWLERS',
              onTap: () {
                final homeLoadedState = context.read<HomeBloc>().state as HomeLoaded;
                context.push(
                    '/game/playerList?userId=${homeLoadedState.userData.userId}&playerRole=${AppIds.bowlerId}&playerRoleName=BOWLERS');
              }
          ),
          sideMenu(
              image: AppImages.ruleBookWhite,
              t1: 'RULE BOOK',
              onTap: (){

              }
          ),
          sideMenu(
              image: AppImages.setting,
              t1: 'SETTINGS',
              onTap: (){

              }
          ),
          // BlocSelector<HomeBloc, HomeState, UserDataEntity?>(
          //     selector: (state) => state is HomeLoaded ? state.userData : null,
          //     builder: (context, userData) {
          //       if (userData == null) return const SizedBox.shrink();
          //       return GestureDetector(
          //         onTap: () {
          //           showDialog(
          //             context: context,
          //             builder: (context) => ProfileScreen(userData: userData),
          //           );
          //         },
          //         child: Container(
          //           margin:
          //           const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          //           padding:
          //           const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //           decoration: BoxDecoration(
          //             color: Colors.black,
          //             borderRadius: BorderRadius.circular(8),
          //             border: Border.all(color: Colors.amber, width: 1),
          //           ),
          //           child: Row(
          //             children: [
          //               const Icon(Icons.person, color: Colors.amber, size: 16),
          //               const SizedBox(width: 8),
          //               Text(
          //                 userData.userName.toUpperCase(),
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .bodySmall
          //                     ?.copyWith(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       );
          //     }),
          // Text(
          //   'PLAYER LIST',
          //   style: GoogleFonts.oxanium(
          //       textStyle: const TextStyle(
          //           fontSize: 18,
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold)),
          // ),
          // Column(
          //   spacing: 5,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     playerCategory(
          //         title: 'BATSMAN',
          //         image: AppImages.batsmanIcon,
          //         colors: textColorForRedTag,
          //         playerRoleId: AppIds.batsmanId),
          //     playerCategory(
          //         title: 'WICKET KEEPER',
          //         image: AppImages.wicketKeeperIcon,
          //         colors: textColorForRedTag,
          //         playerRoleId: AppIds.wicketKeeperId),
          //     playerCategory(
          //         title: 'ALL ROUNDER',
          //         image: AppImages.allRounderIcon,
          //         colors: textColorForRedTag,
          //         playerRoleId: AppIds.allRounderId),
          //     playerCategory(
          //         title: 'BOWLER',
          //         image: AppImages.bowlerIcon,
          //         colors: textColorForRedTag,
          //         playerRoleId: AppIds.bowlerId),
          //   ],
          // ),
          // Column(
          //   spacing: 5,
          //   children: [
          //     getTag(
          //         title: 'MY SQUAD',
          //         tagImage: AppImages.redTag,
          //         colors: textColorForRedTag,
          //         onTap: () {
          //           final homeLoadedState =
          //           context.read<HomeBloc>().state as HomeLoaded;
          //           context.push(
          //               '/game/mySquad?userId=${homeLoadedState.userData.userId}');
          //         }),
          //     getTag(
          //       onTap: () {
          //         context.push('/game/pointsTable');
          //       },
          //       title: 'POINTS TABLE',
          //       tagImage: AppImages.redTag,
          //       colors: textColorForRedTag,
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget thirdColumn() {
    final userId =
        (context.read<HomeBloc>().state as HomeLoaded)
            .userData
            .userId;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: Colors.cyanAccent.shade100.withValues(alpha: 0.4))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            spacing: 5,
            children: [
              Text(
                'AUCTIONER',
                maxLines: 1,
                style: GoogleFonts.cinzel(
                  color: AppTheme.borderGold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                  AppImages.auctioner,
                width: 70,
                height: 70,
              )
            ],
          ),
          tileCard(
              image: AppImages.playerRound,
              t1: 'Round 1/5',
              onTap: (){}
          ),
          tileCard(
              image: AppImages.pointsTable,
              t1: 'POINTS TABLE',
              onTap: (){
                context.push('/game/pointsTable');
              }
          ),
          tileCard(
              image: AppImages.mySquad,
              t1: 'MY SQUAD',
              onTap: () {
                context.push('/game/mySquad?userId=$userId');
              },
          ),
          tileCard(
              image: AppImages.purse,
              t1: 'MY PURSE',
              val: '60 CR',
              onTap: (){}
          ),
          BlocSelector<GameBloc, GameState, String>(
            selector: (state) {
              if (state is! GameLoaded) return '';
              final user = state.gameData.usersStatusList
                  .firstWhere((e) => e.userId == userId);
              return context
                  .read<GameBloc>()
                  .formatPriceShort(user.balanceAmount);
            },
            builder: (context, balance) {
              return tileCard(
                  image: AppImages.purse,
                  t1: 'PURSE REMAIN',
                  val: balance,
                  onTap: (){}
              );
            },
          ),
          BlocBuilder<GameBloc, GameState>(
              builder: (context, gameState) {
                if (gameState is GameLoaded) {
                  GameDataEntity gameData = gameState.gameData;
                  final playerData = gameState.gameData.auctionPlayersStatusList[
                  gameState.gameData.currentAuctionPlayerIndex];
                  return BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, homeState) {
                        final gameBloc = context.read<GameBloc>();
                        final currentState = homeState as HomeLoaded;
                        return GestureDetector(
                          onTap: () {
                            if (isThereAmountToBid(currentState.userData.userId)) {
                              if (gameBloc.enableBidButton(
                                  currentState.userData.userId) ||
                                  controlBid(
                                      playerData,
                                      gameBloc.getMySquad(
                                          currentState.userData.userId),
                                      currentState.userData.userId)
                                  || gameData.breakStatus == BreakStatusEnum.strategicBreak
                                  || gameData.breakStatus == BreakStatusEnum.auctionPlayerBreak
                              ) {
                              } else {
                                context.read<GameBloc>().add(
                                    BidAuctionPlayer(currentState.userData.userId));
                              }
                            } else {
                              showGameInfoDialog(context,
                                  message:
                                  "You haven't enough amount to bid the player! ");
                            }
                          },
                          child: Opacity(
                            opacity: (controlBid(
                                playerData,
                                gameBloc.getMySquad(
                                    currentState.userData.userId),
                                currentState.userData.userId) ||
                                gameBloc.enableBidButton(
                                    currentState.userData.userId)
                                || gameData.breakStatus == BreakStatusEnum.strategicBreak
                                || gameData.breakStatus == BreakStatusEnum.auctionPlayerBreak
                            )
                                ? 0.2
                                : 1,
                            child: Image.asset(
                              AppImages.bidButton,
                              width: 80,
                              height: 80,
                            ),
                          ),
                        );
                      });
                }
                return const SizedBox.shrink();
              }),

          // Row(
          //   spacing: 10,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         final homeState = context.read<HomeBloc>().state;
          //         final gameState = context.read<GameBloc>().state;
          //         if (homeState is HomeLoaded && gameState is GameLoaded) {
          //           context.read<GameBloc>().add(
          //             ExitMatch(
          //               userId: homeState.userData.userId,
          //               matchId: gameState.gameData.matchId,
          //             ),
          //           );
          //         }
          //       },
          //       child: Image.asset(
          //         width: 40,
          //         AppImages.exitIcon,
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: () {},
          //       child: Image.asset(
          //         width: 40,
          //         AppImages.settingMenuIcon,
          //       ),
          //     ),
          //   ],
          // ),
          // Column(
          //   spacing: 5,
          //   children: [
          //     Image.asset(
          //         width: MediaQuery.of(context).size.height * 0.25,
          //         AppImages.gameAuctioner),
          //     Column(
          //       children: [
          //         const Text('MY PURSE',
          //             style: TextStyle(color: Colors.white)),
          //         Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 20),
          //           decoration: const BoxDecoration(
          //               image: DecorationImage(
          //                   image: AssetImage(AppImages.yellowTag),
          //                   fit: BoxFit.fill)),
          //           child: GradientText(
          //               title: '60 CR',
          //               colors: textColorForYellowTag,
          //               fontSize: 25),
          //         )
          //       ],
          //     ),
          //     Column(
          //       children: [
          //         const Text('PURSE REM',
          //             style: TextStyle(color: Colors.white)),
          //         BlocSelector<GameBloc, GameState, String>(
          //           selector: (state) {
          //             if (state is! GameLoaded) return '';
          //             final userId =
          //                 (context.read<HomeBloc>().state as HomeLoaded)
          //                     .userData
          //                     .userId;
          //             final user = state.gameData.usersStatusList
          //                 .firstWhere((e) => e.userId == userId);
          //             return context
          //                 .read<GameBloc>()
          //                 .formatPriceShort(user.balanceAmount);
          //           },
          //           builder: (context, balance) {
          //             return Container(
          //               padding: const EdgeInsets.symmetric(horizontal: 20),
          //               decoration: const BoxDecoration(
          //                   image: DecorationImage(
          //                       image: AssetImage(AppImages.redTag),
          //                       fit: BoxFit.fill)),
          //               child: GradientText(
          //                   title: balance,
          //                   colors: textColorForRedTag,
          //                   fontSize: 25),
          //             );
          //           },
          //         ),
          //       ],
          //     ),
          //   ],
          // ),

        ],
      ),
    );
  }

  bool isThereAmountToBid(String userId) {
    final gameBloc = context.read<GameBloc>();
    if (gameBloc.state is GameLoaded) {
      final gameLoadedState = gameBloc.state as GameLoaded;
      UserStatusEntity userStatusEntity = gameLoadedState.gameData.usersStatusList
          .firstWhere((e) => e.userId == userId);
      AuctionPlayerStatusEntity auctionPlayerStatusEntity = gameLoadedState
          .gameData
          .auctionPlayersStatusList[
      gameLoadedState.gameData.currentAuctionPlayerIndex];
      if ((userStatusEntity.balanceAmount -
          auctionPlayerStatusEntity.currentPrice) <
          2500000) return false;
    }
    return true;
  }

  bool controlBid(
      AuctionPlayerStatusEntity currentPlayer,
      Map<int, AuctionPlayerStatusEntity?> mySquad,
      String userId,
      ) {
    bool roleCount(String roleId, int limit) {
      return mySquad.values
          .where((e) =>
      e != null &&
          e.playerRoleId == roleId &&
          e.playerAuctionStatus == PlayerAuctionStatusEnum.buy)
          .toList()
          .length >= limit;
    }

    if (currentPlayer.playerRoleId == AppIds.batsmanId) {
      return roleCount(AppIds.batsmanId, AppConstant.batsmanLimit);
    } else if (currentPlayer.playerRoleId == AppIds.wicketKeeperId) {
      return roleCount(AppIds.wicketKeeperId, AppConstant.wicketKeeperLimit);
    } else if (currentPlayer.playerRoleId == AppIds.allRounderId) {
      return roleCount(AppIds.allRounderId, AppConstant.allRounderLimit);
    } else {
      return roleCount(AppIds.bowlerId, AppConstant.bowlerLimit);
    }
  }

  Widget getTag({
    required String title,
    required String tagImage,
    required List<Color> colors,
    double? imageSize,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: imageSize ?? 130,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(tagImage), fit: BoxFit.fill)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GradientText(title: title, colors: colors, fontSize: 16),
          ),
        ),
      ),
    );
  }

  String getPlayerRole(GameDataEntity gameData) {
    final homeLoaded = context.read<HomeBloc>().state as HomeLoaded;
    final currentPlayerId = gameData
        .auctionPlayersStatusList[gameData.currentAuctionPlayerIndex]
        .playerId;

    final player = homeLoaded.userData.players
        .where((e) => e.playerId == currentPlayerId)
        .toList();

    final playerStyle = homeLoaded.userData.categoryAndItsItem.playerRoleCategoryId
        .where((e) => e.id == player.first.playerRole)
        .toList();
    return playerStyle.first.categoryItemName;
  }

  Widget playerCategory({
    required String title,
    required String playerRoleId,
    required String image,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: () {
        final homeLoadedState = context.read<HomeBloc>().state as HomeLoaded;
        context.push(
            '/game/playerList?userId=${homeLoadedState.userData.userId}&playerRole=$playerRoleId&playerRoleName=$title');
      },
      child: Row(
        spacing: 10,
        children: [
          Image.asset(
            width: 25,
            height: 25,
            image,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.12,
            child: GradientText(
                title: title,
                colors: colors,
                fontSize: 11,
                textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }

  Widget sideMenu({required String image, required String t1, String? t2, required void Function()? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.cyanAccent.shade100.withValues(alpha: 0.4)))
        ),
        width: 150,
          height: 49,
        child: Row(
          spacing: 10,
          children: [
            SizedBox(width: 10,),
            Image.asset(
              width: 30,
                height: 30,
                image
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t1,
                  maxLines: 1,
                  style: GoogleFonts.cinzel(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(t2 != null)
                  Text(
                  t2,
                  maxLines: 1,
                  style: GoogleFonts.cinzel(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget tileCard({required String image, required String t1, String? val, required void Function()? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.cyanAccent.shade100.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(6)
        ),
        width: 165,
        child: Row(
          spacing: 10,
          children: [
            SizedBox(width: 10,),
            Image.asset(
              width: 30,
                height: 30,
                image
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t1,
                  maxLines: 1,
                  style: GoogleFonts.cinzel(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(val != null)
                  Text(
                  val,
                  style: GoogleFonts.cinzel(
                    color: Colors.lightGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

}