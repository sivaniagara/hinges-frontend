import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../login/presentation/bloc/user_auth_bloc.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../../domain/entities/user_data_entity.dart';
import '../widgets/app_background.dart';

class ProfileScreen extends StatelessWidget {
  final UserDataEntity userData;
  const ProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: AppBackground(
        animateContent: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Stack(
                  children: [
                    Center(
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.goldenStarLine,
                            width: 50,
                          ),
                          const GoldenTitle(
                            title: 'USER PROFILE',
                            fontSize: 32,
                          ),
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Image.asset(
                              AppImages.goldenStarLine,
                              width: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Image.asset(AppImages.homeMenuIcon, width: 60),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width * 0.86,
                height: size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.goldenChamberFrame),
                      fit: BoxFit.fill
                  )
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      AppImages.goldenAvatar,
                      width: size.height * 0.2,
                      height: size.height * 0.2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          userData.userName,
                          style: GoogleFonts.cinzel(
                            color: AppTheme.borderGold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 280,
                          height: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(AppImages.goldenChamberFrame),
                                  fit: BoxFit.fill
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                  AppImages.coinsIcon,
                                width: 30,
                              ),
                              Text(
                                "AVAILABLE COINS",
                                style: GoogleFonts.cinzel(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData.coinWon.toString(),
                                style: GoogleFonts.cinzel(
                                  color: AppTheme.borderGold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            FaIcon(FontAwesomeIcons.google, color: AppTheme.borderGold, size: 15,),
                            Text(
                              "LOGGED IN WITH GOOGLE",
                              style: GoogleFonts.cinzel(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        context.read<UserAuthBloc>().add(SignOutRequested());
                        context.go('/login');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                            AppImages.logoutFrame,
                          width: 120,
                        ),
                      ),
                    )

                  ],
                ),
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoldenChamberCard(image: AppImages.playedIcon, title: 'AUCTION PLAYED', value: userData.gamePlayed.toString()),
                  GoldenChamberCard(image: AppImages.qualifiedIcon, title: 'QUALIFIED', value: userData.qualified.toString()),
                  GoldenChamberCard(image: AppImages.unqualifiedIcon, title: 'DISQUALIFIED', value: userData.disqualified.toString()),
                ],
              ),
              Text(
                "ACHIEVEMENTS",
                style: GoogleFonts.cinzel(
                  color: AppTheme.borderGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoldenChamberCard(image: AppImages.firstPrize, title: 'FIRST PRIZE', value: userData.firstPrice.toString()),
                  GoldenChamberCard(image: AppImages.secondPrize, title: 'SECOND PRIZE', value: userData.secondPrice.toString()),
                  GoldenChamberCard(image: AppImages.thirdPrize, title: 'THIRD PRIZE', value: userData.thirdPrice.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoldenChamberCard extends StatelessWidget {
  final String image;
  final String title;
  final String value;
  const GoldenChamberCard({super.key, required this.image, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.28,
      height: 70,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.goldenChamberFrame),
              fit: BoxFit.fill
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            image,
            width: 50,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.cinzel(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.cinzel(
                  color: AppTheme.borderGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                AppImages.highlightValue,
                width: 100,
                height: 12,
                fit: BoxFit.fitHeight,
              )
            ],
          ),
        ],
      ),
    );
  }
}

