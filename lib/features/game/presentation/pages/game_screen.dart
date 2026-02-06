import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/presentation/widgets/gradient_text.dart';
import '../../../home/domain/entities/user_data_entity.dart';
import '../../../home/presentation/pages/profile_dialog.dart';
import '../../domain/entities/game_data_entity.dart';
import '../bloc/game_bloc.dart';


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
                          GameDataEntity? gameData = state is GameLoaded ? state.gameData : null;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [

                                    if(gameData != null)
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.bodyLarge,
                                          children: [
                                            TextSpan(
                                              text: 'Get ready! Match begins in',
                                              style: GoogleFonts.jost(textStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),

                                            ),
                                            TextSpan(
                                              text: '\n${(state as GameLoaded).remainingSecondsToStart.round()} seconds...',
                                              style: TextStyle(
                                                fontFamily: 'Zuume',
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      ...[
                                        getTag(title: 'BATSMAN SET', tagImage: AppImages.redTag, colors: textColorForRedTag),
                                        Row(
                                          children: [
                                            Image.asset(
                                                width: 120,
                                                height: 120,
                                                AppImages.virat
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              spacing: 8,
                                              children: [
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    Text(
                                                      '18  Virat Kohli',
                                                      style: TextStyle(
                                                        fontFamily: 'Zuume',
                                                        fontWeight: FontWeight.w700,
                                                        fontStyle: FontStyle.italic,
                                                        fontSize: 25,
                                                      ),
                                                    ),
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
                                                Text('Right Hand Batsman', style: GoogleFonts.jost(textStyle: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),),
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text('BASE PRICE', style: GoogleFonts.jost(textStyle: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),),
                                                        Text(
                                                          '2 CR',
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
                                                          '10',
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
                                                  text: '  9.25 CR',
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
                                      Positioned(
                                        left: 50,
                                        top: 30,
                                        child: getFranchiseLogo(imagePath: AppImages.csk),
                                      ),
                                      Positioned(
                                        right: 50,
                                        top: 30,
                                        child: getFranchiseLogo(imagePath: AppImages.mi),
                                      ),
                                      Positioned(
                                        right: 50,
                                        bottom: 35,
                                        child: getFranchiseLogo(imagePath: AppImages.rcb),
                                      ),
                                      Positioned(
                                        left: 50,
                                        bottom: 35,
                                        child: getFranchiseLogo(imagePath: AppImages.kkr),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: getFranchiseLogo(imagePath: AppImages.srh)
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

  Widget getFranchiseLogo({required String imagePath}){
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage(
                imagePath,
            ),
        )

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
        Text('PLAYERS LIST', style: GoogleFonts.oxanium(textStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),),
        Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            playerCategory(title: 'BATSMAN', image: AppImages.batsmanIcon, colors: textColorForRedTag, ),
            playerCategory(title: 'WICKET KEEPER', image: AppImages.wicketKeeperIcon, colors: textColorForRedTag),
            playerCategory(title: 'ALL ROUNDER', image: AppImages.allRounderIcon, colors: textColorForRedTag),
            playerCategory(title: 'BOWLER', image: AppImages.bowlerIcon, colors: textColorForRedTag),
          ],
        ),
        Column(
          spacing: 5,
          children: [
            getTag(title: 'MY SQUAD', tagImage: AppImages.redTag, colors: textColorForRedTag, ),
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
                    child: GradientText(title: '25 CR', colors: textColorForRedTag, fontSize: 25),
                  )
                ],
              ),
            ],
          ),
          Container(
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
          )
        ],
      ),
    );
  }

  Widget getTag({
    required String title,
    required String tagImage,
    required List<Color> colors,
  }){
    return Container(
      width: 130,
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
    );
  }

  Widget playerCategory(
  {
    required String title,
    required String image,
    required List<Color> colors,
}
      ){
    return Row(
      spacing: 10,
      children: [
        Image.asset(
          width: 25,
            height: 25,
            image,
          fit: BoxFit.cover,
        ),
        GradientText(title: title, colors: colors, fontSize: 14)
      ],
    );
  }
  
}