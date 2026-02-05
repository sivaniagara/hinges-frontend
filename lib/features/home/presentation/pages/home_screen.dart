import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/presentation/widgets/dialog_details.dart';
import 'package:hinges_frontend/core/presentation/widgets/shimmer_widget.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/pages/rule_book_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/setting_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/shop_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/widgets/auction_card_shimmer.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/utils/app_images.dart';
import '../../../login/presentation/bloc/user_auth_bloc.dart';
import '../../domain/entities/user_data_entity.dart';
import 'profile_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<UserAuthBloc>().state;
    String uid = '';
    if (authState is EmailAuthenticated) {
      uid = authState.user.uid;
    }
    context.read<HomeBloc>().add(FetchUserData(uid));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final bool isLoading = state is HomeLoading || state is HomeInitial;
        final UserDataEntity? userData = state is HomeLoaded ? state.userData : null;

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
              child: Column(
                children: [
                  _buildTopBar(
                    context: context,
                    loading: isLoading,
                    userData: userData,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _AuctionCard(
                          title: "MINI AUCTION",
                          isLocked: false,
                          onTap: () {
                            context.push('/miniAuction');
                          },
                          infoTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const DialogDetails(
                                points: [
                                  'ONLY 5 SLOTS TO BE FILLED WITH YOUR REMAINING PURSE',
                                  'PRIZE DISTRIBUTION IS BASED ON THE HIGHEST RATING ORDER',
                                  'FOR FURTHER INFORMATION PLEASE READ THE RULE BOOK'
                                ],
                              ),
                            );
                          },
                          loading: isLoading,
                        ),
                        _AuctionCard(
                          title: "MEGA AUCTION",
                          isLocked: true,
                          loading: isLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar({
    required BuildContext context,
    required bool loading,
    UserDataEntity? userData,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Stack(
        children: [
          // Profile Section
          Positioned(
            left: 0,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ProfileDialog(userData: userData!,),
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
                    if (loading)
                      const ShimmerWidget(width: 50, height: 10)
                    else
                      Text(
                        userData?.userName.toUpperCase() ?? "USER NAME",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: IntrinsicWidth(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: const BoxDecoration(
                  color: Color(0xff2F0907),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 35,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 30,
                                  bottom: 5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.amber, width: 1.5),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        if (loading)
                                          const ShimmerWidget(width: 30, height: 10)
                                        else
                                          Text(
                                            userData?.coinWon.toString() ?? "0",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.add_circle, color: Colors.green, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  child: Image.asset(
                                    width: 45,
                                    height: 40,
                                    AppImages.coinsMenuIcon,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            'Coins',
                            style: GoogleFonts.jockeyOne(
                              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          )
                        ],
                      ),
                      _TopActionButton(
                        icon: AppImages.shopMenuIcon,
                        title: 'Shop',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ShopDialog(),
                          );
                        },
                      ),
                      _TopActionButton(
                        icon: AppImages.freeCoinMenuIcon,
                        title: 'Free Coins',
                        onTap: () {},
                      ),
                      _TopActionButton(
                        icon: AppImages.settingsMenuIcon,
                        title: 'Setting',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SettingDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: _TopActionButton(
              icon: AppImages.ruleBookMenuIcon,
              title: 'Rule Book',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const RuleBookDialog(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  final void Function()? onTap;
  final String icon;
  final String title;
  const _TopActionButton({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(width: 35, icon),
          Text(
            title,
            style: GoogleFonts.jockeyOne(
              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
        ],
      ),
    );
  }
}

class _AuctionCard extends StatelessWidget {
  final String title;
  final bool isLocked;
  final void Function()? onTap;
  final void Function()? infoTap;
  final bool loading;

  const _AuctionCard({
    required this.title,
    required this.isLocked,
    required this.loading,
    this.onTap,
    this.infoTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (loading) return const AuctionCardShimmer();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Wood Frame Background
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: screenWidth * 0.4,
                height: screenHeight * 0.6,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(AppImages.auctionCard),
                    fit: BoxFit.fitWidth,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: isLocked
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock, color: Color(0xFFFFD700), size: 50),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                color: const Color(0xFFFFD700),
                                child: const Text(
                                  "LOCKED",
                                  style: TextStyle(
                                    color: Color(0xFF4A0000),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              // Header Tag
              if (!isLocked)
                Positioned(
                  top: screenHeight * 0.12,
                  child: Image.asset(
                    AppImages.auctionerBox,
                    height: screenHeight * 0.25,
                  ),
                ),
              Positioned(
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isLocked ? const Color(0xFFFFD700) : const Color(0xFFD32F2F),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.oxanium(
                      textStyle: TextStyle(
                        color: isLocked ? const Color(0xFF4A0000) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              if (!isLocked)
                Positioned(
                  bottom: screenHeight * 0.1,
                  child: Image.asset(
                    AppImages.biddingPeople,
                    height: screenHeight * 0.15,
                  ),
                )
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Info Button
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: infoTap,
            child: Container(
              margin: const EdgeInsets.only(left: 240),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline, color: Colors.white, size: 20),
            ),
          ),
        )
      ],
    );
  }
}
