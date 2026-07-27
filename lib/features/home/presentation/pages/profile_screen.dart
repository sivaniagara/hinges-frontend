import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_sounds.dart';
import '../../../../core/utils/audio_manager.dart';
import '../../../../core/utils/so_loud.dart';
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
                        onTap: () {
                          playTap();
                          context.pop();
                        },
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
                    color: AppTheme.navyBlue,
                    borderRadius: BorderRadius.circular(12),
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
                      AppImages.user,
                      width: size.height * 0.2,
                      height: size.height * 0.2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: userData.userName,
                                style: GoogleFonts.rajdhani(
                                  color: AppTheme.borderGold,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '  IBL ID : ',
                                style: GoogleFonts.rajdhani(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: userData.userId.split('').take(6).join('').toUpperCase(),
                                style: GoogleFonts.rajdhani(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
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
                                style: GoogleFonts.rajdhani(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData.coinWon.toString(),
                                style: GoogleFonts.rajdhani(
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
                              style: GoogleFonts.rajdhani(
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
                        showLogoutDialog(context);
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
                  GoldenChamberCard(image: AppImages.playedIcon, title: 'AUCTION PLAYED', value: userData.gamePlayed.toString(), color: Color(0xff284441),),
                  GoldenChamberCard(image: AppImages.qualifiedIcon, title: 'QUALIFIED', value: userData.qualified.toString(), color: Color(0xff284441),),
                  GoldenChamberCard(image: AppImages.unqualifiedIcon, title: 'DISQUALIFIED', value: userData.disqualified.toString(), color: Color(0xff284441),),
                ],
              ),
              StarLine(content: 'ACHIEVEMENTS', fontSize: 14, ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoldenChamberCard(image: AppImages.firstPrize, title: 'FIRST PRIZE', value: userData.firstPrice.toString(), color: AppTheme.navyBlue,),
                  GoldenChamberCard(image: AppImages.secondPrize, title: 'SECOND PRIZE', value: userData.secondPrice.toString(), color: AppTheme.navyBlue,),
                  GoldenChamberCard(image: AppImages.thirdPrize, title: 'THIRD PRIZE', value: userData.thirdPrice.toString(), color: AppTheme.navyBlue,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.navyBlue,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: GoldenLogOutDialog(),
        );
      },
    );
  }
}

class GoldenLogOutDialog extends StatelessWidget {
  const GoldenLogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔸 GOLDEN FRAME CONTAINER
        Container(
          width: 500,
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.dialogFrame), // your generated frame
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoldenTitle(title: 'ARE YOU SURE YOU WANT TO LOGOUT', fontSize: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      playTap();
                      context.read<UserAuthBloc>().add(SignOutRequested());
                      context.go('/login');
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage(
                                AppImages.dialogFrame,
                            ),
                          fit: BoxFit.fill
                        ),
                        color: Color(0xff000F3A)
                      ),
                      child: Center(
                        child: Text(
                          'YES',
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          )
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      playTap();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(
                                AppImages.dialogFrame,
                              ),
                              fit: BoxFit.fill
                          ),
                          color: Color(0xff370000)
                      ),
                      child: Center(
                        child: Text(
                            'NO',
                            style: GoogleFonts.rajdhani(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// 🔴 CLOSE BUTTON (TOP RIGHT)
        Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
            onTap: () {
              playTap();
              Navigator.pop(context);
            },
            child: Image.asset(
                AppImages.cancel,
              width: 40,
            ),
          ),
        ),
      ],
    );
  }
}

class GoldenChamberCard extends StatelessWidget {
  final String image;
  final String title;
  final String value;
  final Color color;
  const GoldenChamberCard({super.key, required this.image, required this.title, required this.value, required this.color});

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
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
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
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.rajdhani(
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
      ),
    );
  }
}

