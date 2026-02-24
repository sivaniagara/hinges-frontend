import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_ids.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/utils/constant.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_style_widget.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/game_start_duration.dart';
import 'package:hinges_frontend/features/game/presentation/widgets/player_name_widget.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/network/http_service_impl.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/presentation/widgets/gradient_text.dart';
import '../../../home/domain/entities/user_data_entity.dart';
import '../../../home/presentation/pages/profile_dialog.dart';
import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../../domain/entities/game_data_entity.dart';
import '../../domain/entities/user_status_entity.dart';
import '../bloc/game_bloc.dart';
import 'package:square_progress_indicator/square_progress_indicator.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Color> textColorForRedTag = [Colors.white, Color(0xffFF1D2B)];
  List<Color> textColorForYellowTag = [Color(0xff330000), Color(0xffFF1D2B)];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF800000), // Center deep red
                Color(0xFFA7100E), // Outer darker red
              ],
              radius: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 8),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                firstColumn(),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFFBB1311), // Outer darker red
                          Color(0xFF670201)
                        ],
                        radius: 0.7,
                      ),
                      // borderRadius: BorderRadius.circular(90),
                    ),
                    child: BlocBuilder<GameBloc, GameState>(
                        builder: (context, state){
                          if(state is! GameLoaded){
                            return Container();
                          }
                          GameDataEntity gameData = state.gameData;
                          final playerData = state.gameData
                              .auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    if(state.gameData.matchStatus == MatchStatusEnum.notStarted)
                                      gameExpireLoadingWidget(state)
                                    else if(state.gameData.matchStatus == MatchStatusEnum.initialMatch)
                                      GameStartDuration()
                                    else
                                      ...[
                                        getTag(title: '${getPlayerRole(gameData).toUpperCase()} SET', tagImage: AppImages.redTag, colors: textColorForRedTag, imageSize: 200),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          spacing: 10,
                                          children: [
                                            if(state.remainingSecondsToExpireAuctionPlayer!= null)
                                              TweenAnimationBuilder<double>(
                                              tween: Tween(
                                                begin: 1,
                                                end: state.remainingSecondsToExpireAuctionPlayer! / 10,
                                              ),
                                              duration: Duration(seconds: state.remainingSecondsToExpireAuctionPlayer! > 9 ? 0 : 1),
                                              curve: Curves.linear,
                                              builder: (context, animatedValue, child) {
                                                return SquareProgressIndicator(
                                                  value: animatedValue,
                                                  width: 90,
                                                  height: 90,
                                                  borderRadius: 8,
                                                  startPosition: StartPosition.topCenter,
                                                  strokeCap: StrokeCap.square,
                                                  clockwise: false,
                                                  color: state.remainingSecondsToExpireAuctionPlayer! < 4 ? Colors.red : Colors.yellow,
                                                  emptyStrokeColor: Colors.yellow.withValues(alpha: 0.1),
                                                  strokeWidth: 4,
                                                  emptyStrokeWidth: 4,
                                                  strokeAlign: SquareStrokeAlign.outside,
                                                  child: child,
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: BlocSelector<GameBloc, GameState, String>(
                                                    selector: (state){
                                                      if (state is! GameLoaded) return '';
                                                      return state.gameData
                                                          .auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex]
                                                          .playerId;
                                                    },
                                                    builder: (context, value){
                                                      return Image.network(
                                                        width: 90,
                                                        height: 90,
                                                        "${HttpServiceImpl.ipAddress}images/players/$value.png",
                                                      );
                                                    }
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              spacing: 8,
                                              children: [
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    PlayerNameWidget(gameData: gameData),
                                                    Image.asset(
                                                        width: 30,
                                                        height: 30,
                                                        AppImages.bat
                                                    ),
                                                    Image.asset(
                                                        width: 30,
                                                        height: 30,
                                                        AppImages.cap
                                                    ),
                                                    Image.asset(
                                                        width: 30,
                                                        height: 30,
                                                        AppImages.indiaFlag
                                                    ),
                                                  ],
                                                ),
                                                PlayerStyleWidget(gameData: gameData),
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text('BASE PRICE', style: GoogleFonts.jost(textStyle: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),),
                                                        Text(
                                                          '${state.gameData
                                                              .auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex]
                                                              .basePrice} L',
                                                          style: TextStyle(
                                                            fontFamily: 'Zuume',
                                                            fontWeight: FontWeight.w700,
                                                            fontStyle: FontStyle.italic,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 0.5,
                                                      height: 30,
                                                      color: Colors.white,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text('RATING', style: GoogleFonts.jost(textStyle: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),),
                                                        Text(
                                                          '${state.gameData
                                                              .auctionPlayersStatusList[state.gameData.currentAuctionPlayerIndex]
                                                              .baseRating}',
                                                          style: TextStyle(
                                                            fontFamily: 'Zuume',
                                                            fontWeight: FontWeight.w700,
                                                            fontStyle: FontStyle.italic,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ]
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.5,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(AppImages.auctionCard), // Placeholder for wood texture
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Stack(
                                  children: [
                                    ...[
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              style: Theme.of(context).textTheme.bodyLarge,
                                              children: [
                                                TextSpan(
                                                  text: 'CURRENT BID',
                                                  style: GoogleFonts.jost(textStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),

                                                ),
                                                TextSpan(
                                                  text: '  ${playerData.currentPrice/10000000 } CR',
                                                  style: TextStyle(
                                                    fontFamily: 'Zuume',
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if(gameData.usersStatusList.any((user) => user.teamId == MiniAuctionFranchiseEnum.csk.teamId()))
                                        Positioned(
                                          left: 50,
                                          top: 50,
                                          child: getFranchiseLogo(
                                              imagePath: AppImages.csk,
                                              user: getUser(gameData.usersStatusList, MiniAuctionFranchiseEnum.csk.teamId()),
                                            glow: playerData.teamId == MiniAuctionFranchiseEnum.csk.teamId()
                                          ),
                                        ),
                                      if(gameData.usersStatusList.any((user) => user.teamId == MiniAuctionFranchiseEnum.mi.teamId()))
                                        Positioned(
                                          right: 50,
                                          top: 50,
                                          child: getFranchiseLogo(
                                              imagePath: AppImages.mi,
                                              user: getUser(gameData.usersStatusList, MiniAuctionFranchiseEnum.mi.teamId()),
                                              glow: playerData.teamId == MiniAuctionFranchiseEnum.mi.teamId()
                                          ),
                                        ),
                                      if(gameData.usersStatusList.any((user) => user.teamId == MiniAuctionFranchiseEnum.rcb.teamId()))
                                        Positioned(
                                          right: 50,
                                          bottom: 35,
                                          child: getFranchiseLogo(
                                              imagePath: AppImages.rcb,
                                              user: getUser(gameData.usersStatusList,
                                                  MiniAuctionFranchiseEnum.rcb.teamId()),
                                              glow: playerData.teamId == MiniAuctionFranchiseEnum.rcb.teamId()
                                          ),
                                        ),
                                      if(gameData.usersStatusList.any((user) => user.teamId == MiniAuctionFranchiseEnum.kkr.teamId()))
                                        Positioned(
                                          left: 50,
                                          bottom: 35,
                                          child: getFranchiseLogo(
                                              imagePath: AppImages.kkr,
                                              user: getUser(gameData.usersStatusList, MiniAuctionFranchiseEnum.kkr.teamId()),
                                              glow: playerData.teamId == MiniAuctionFranchiseEnum.kkr.teamId()
                                          ),
                                        ),
                                      if(gameData.usersStatusList.any((user) => user.teamId == MiniAuctionFranchiseEnum.srh.teamId()))
                                        Align(
                                            alignment: Alignment.center,
                                            child: getFranchiseLogo(
                                                imagePath: AppImages.srh,
                                                user: getUser(gameData.usersStatusList, MiniAuctionFranchiseEnum.srh.teamId()),
                                                glow: playerData.teamId == MiniAuctionFranchiseEnum.srh.teamId()
                                            )
                                        ),
                                    ]
                                  ],
                                ),
                              )
                            ],
                          );
                    }),
                  ),
                ),
                thirdColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  UserStatusEntity getUser(List<UserStatusEntity> userList, String teamId){
    UserStatusEntity? user;
    for(var user in userList){
      if(user.teamId == teamId){
        user = user;
        break;
      }
    }
    return user!;
  }

  bool findOutWhoCurrentlyBuy(AuctionPlayerStatusEntity playerData, List<UserStatusEntity> userList, String teamId){
    return playerData.teamId == teamId;
  }

  Widget gameExpireLoadingWidget(GameLoaded loadedState){
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          TextSpan(
            text: 'Get ready! Match begins in',
            style: GoogleFonts.jost(textStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),

          ),
          TextSpan(
            text: '\n${(loadedState).remainingSecondsToStart.round()} seconds...',
            style: TextStyle(
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
  }){
    return GestureDetector(
      onTap: (){
        final homeLoadedState = context.read<HomeBloc>().state as HomeLoaded;
        context.push('/game/mySquad?userId=${user.userId}');
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: glow ? 45 : 40,
              height: glow ? 45 : 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                  boxShadow: glow ? [
                    BoxShadow(
                      color: Colors.yellow,
                      blurRadius: 15,
                      spreadRadius: 6,
                    ),
                  ] : null,
                  image: DecorationImage(
                  fit: BoxFit.fill,
                    image: AssetImage(
                        imagePath,
                    ),
                )

              ),
            ),
            Text(user.userName, style: GoogleFonts.jost(textStyle: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)))
          ],
        ),
      ),
    );
  }

  Widget firstColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<HomeBloc, HomeState>(
            builder: (context,state){
              final UserDataEntity userData = (state as HomeLoaded).userData;
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ProfileDialog(userData: userData,),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        userData.userName.toUpperCase() ?? "USER NAME",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
        Text('PLAYER LIST', style: GoogleFonts.oxanium(textStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),),
        Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            playerCategory(title: 'BATSMAN', image: AppImages.batsmanIcon, colors: textColorForRedTag, playerRoleId: AppIds.batsmanId),
            playerCategory(title: 'WICKET KEEPER', image: AppImages.wicketKeeperIcon, colors: textColorForRedTag, playerRoleId: AppIds.wicketKeeperId),
            playerCategory(title: 'ALL ROUNDER', image: AppImages.allRounderIcon, colors: textColorForRedTag, playerRoleId: AppIds.allRounderId),
            playerCategory(title: 'BOWLER', image: AppImages.bowlerIcon, colors: textColorForRedTag, playerRoleId: AppIds.bowlerId),
          ],
        ),
        Column(
          spacing: 5,
          children: [
            getTag(
              title: 'MY SQUAD',
              tagImage: AppImages.redTag, colors: textColorForRedTag,
              onTap: (){
                final homeLoadedState = context.read<HomeBloc>().state as HomeLoaded;
                context.push('/game/mySquad?userId=${homeLoadedState.userData.userId}');
              }
            ),
            getTag(title: 'POINTS TABLE', tagImage: AppImages.redTag, colors: textColorForRedTag, ),
          ],
        ),
        SizedBox(height: 1,)
      ],
    );
  }

  Widget thirdColumn(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: (){
                  context.pushReplacement('/miniAuctionLiteMode');
                },
                child: Image.asset(
                    width: 40,
                    AppImages.exitIcon
                ),
              ),
              GestureDetector(
                onTap: (){
                  // context.pushReplacement('/home');
                },
                child: Image.asset(
                    width: 40,
                    AppImages.settingMenuIcon
                ),
              ),
            ],
          ),
          Column(
            spacing: 5,
            children: [
              Image.asset(
                  width: MediaQuery.of(context).size.height * 0.25,
                  AppImages.gameAuctioner
              ),
              Column(
                children: [
                  Text('MY PURSE', style: TextStyle(color: Colors.white),),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppImages.yellowTag),
                            fit: BoxFit.fill
                        )
                    ),
                    child: GradientText(title: '60 CR', colors: textColorForYellowTag, fontSize: 25),
                  )
                ],
              ),
              Column(
                children: [
                  Text('PURSE REM', style: TextStyle(color: Colors.white),),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppImages.redTag),
                            fit: BoxFit.fill
                        )
                    ),
                    child: GradientText(title: '${getRemainingAmount()} CR', colors: textColorForRedTag, fontSize: 25),
                  )
                ],
              ),
            ],
          ),
          BlocBuilder<GameBloc, GameState>(
              builder: (context, gameState){
                if(gameState is GameLoaded){
                  GameDataEntity gameData = gameState.gameData;
                  final playerData = gameState.gameData
                      .auctionPlayersStatusList[gameState.gameData.currentAuctionPlayerIndex];
                  return BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, homeState){
                        final gameBloc = context.read<GameBloc>();
                        final currentState = context.read<HomeBloc>().state as HomeLoaded;
                        if(gameData.matchStatus != MatchStatusEnum.started || controlBid(playerData, gameBloc.getMySquad(currentState.userData.userId))){
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                          );
                        }
                        return GestureDetector(
                          onTap: (){
                            if(!gameBloc.enableBidButton((homeState).userData.userId)){
                              context.read<GameBloc>().add(BidAuctionPlayer(currentState.userData.userId));
                            }

                          },
                          child: Opacity(
                            opacity: gameBloc.enableBidButton((homeState as HomeLoaded).userData.userId) ?  0.2 : 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: RadialGradient(
                                    colors: [
                                      Color(0xFF800000), // Center deep red
                                      Color(0xFFA7100E), // Outer darker red
                                    ],
                                    radius: 1.0,
                                  ),
                                  border: Border.all(color: Colors.yellow, width: 2, strokeAlign: BorderSide.strokeAlignOutside)
                              ),
                              child: Center(
                                child: GradientText(title: 'BID', colors: textColorForRedTag),
                              ),
                            ),
                          ),
                        );
                      }
                  );

                }
                return Container();
              }
          )
        ],
      ),
    );
  }

  String getRemainingAmount(){
    if(context.read<GameBloc>().state is! GameLoaded){
      return '';
    }else{
      UserStatusEntity user = (context.read<GameBloc>().state as GameLoaded).gameData.usersStatusList.firstWhere((e) => e.userId == (context.read<HomeBloc>() as HomeLoaded).userData.userId);
      return (user.balanceAmount/10000000).toStringAsFixed(2);
    }


  }

  bool controlBid(AuctionPlayerStatusEntity currentPlayer, Map<int, AuctionPlayerStatusEntity?> mySquad){
    bool roleCount(String roleId, int limit){
      return mySquad.values.where((e) => e != null && e.playerRoleId == roleId).toList().length >= limit;
    }
    if(currentPlayer.playerRoleId == AppIds.batsmanId){
      return roleCount(AppIds.batsmanId, AppConstant.batsmanLimit);
    }else if(currentPlayer.playerRoleId == AppIds.wicketKeeperId){
      return roleCount(AppIds.wicketKeeperId, AppConstant.wicketKeeperLimit);
    }else if(currentPlayer.playerRoleId == AppIds.allRounderId){
      return roleCount(AppIds.allRounderId, AppConstant.allRounderLimit);
    }else{
      return roleCount(AppIds.bowlerId, AppConstant.bowlerLimit);
    }
  }

  Widget getTag({
    required String title,
    required String tagImage,
    required List<Color> colors,
    double? imageSize,
    void Function()? onTap,
  }){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: imageSize ?? 130,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(tagImage),
                fit: BoxFit.fill
            )
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GradientText(title: title, colors: colors, fontSize: 16),
          ),
        ),
      ),
    );
  }

  String getPlayerRole(GameDataEntity gameData){
    final homeLoaded = context.read<HomeBloc>().state as HomeLoaded;
    final currentPlayerId =
        gameData.auctionPlayersStatusList[
        gameData.currentAuctionPlayerIndex].playerId;

    final player = homeLoaded.userData.players
        .where((e) => e.playerId == currentPlayerId)
        .toList();

    final playerStyle = homeLoaded.userData.categoryAndItsItem.playerRoleCategoryId
        .where((e) => e.id == player.first.playerRole).toList();
    return playerStyle.first.categoryItemName;
  }

  Widget playerCategory(
  {
    required String title,
    required String playerRoleId,
    required String image,
    required List<Color> colors,
}
      ){
    return GestureDetector(
      onTap: (){
        final homeLoadedState = context.read<HomeBloc>().state as HomeLoaded;
        context.push(
            '/game/playerList?userId=${homeLoadedState.userData.userId}&playerRole=$playerRoleId&playerRoleName=$title'
        );      },
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
              child: GradientText(title: title, colors: colors, fontSize: 11, textAlign: TextAlign.center,)
          )
        ],
      ),
    );
  }
  
}
