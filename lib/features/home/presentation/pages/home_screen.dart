import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/home/presentation/widgets/top_user_bar.dart';
import 'package:hinges_frontend/features/login/presentation/widgets/shared_decorations.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';

import '../../../login/presentation/bloc/user_auth_bloc.dart';
import '../../domain/entities/user_data_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/app_background.dart';

enum AuctionModeEnum{miniAuctionLite, miniAuctionPro, megaAuctionLite, megaAuctionPro}
class AuctionItem {
  final String image;
  final String route;
  final bool locked;
  final AuctionModeEnum auctionModeEnum;

  const AuctionItem({
    required this.image,
    required this.route,
    required this.locked,
    required this.auctionModeEnum,
  });
}

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
    }else if (authState is GoogleAuthenticated) {
      uid = authState.user.uid;
    }else if (authState is GuestAuthenticated) {
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
    final size = MediaQuery.of(context).size;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeLoading || state is HomeInitial;
        final userData =
        state is HomeLoaded ? state.userData : null;

        final auctionItems = [
          AuctionItem(
              image: AppImages.miniAuctionLite,
              route: "/miniAuctionLite",
              locked: false,
              auctionModeEnum: AuctionModeEnum.miniAuctionLite
          ),
          AuctionItem(
              image: AppImages.miniAuctionPro,
              route: "",
              locked: true,
              auctionModeEnum: AuctionModeEnum.miniAuctionPro
          ),
          AuctionItem(
              image: AppImages.megaAuctionLite,
              route: "",
              locked: true,
              auctionModeEnum: AuctionModeEnum.megaAuctionLite
          ),
          AuctionItem(
              image: AppImages.megaAuctionPro,
              route: "",
              locked: true,
              auctionModeEnum: AuctionModeEnum.megaAuctionPro
          ),
        ];

        return AdaptiveStatusBar(
          color: Theme.of(context).colorScheme.surface,
          child: AppBackground(
            child: Stack(
              children: [
                /// ✅ YOUR ORIGINAL UI (UNCHANGED)
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Column(
                    children: [
                      _buildTopBar(
                        context: context,
                        loading: isLoading,
                        userData: userData,
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Row(
                                  spacing: 10,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppImages.indianBiddingLeague,
                                      height: size.height * 0.15,
                                    ),
                                    Text(
                                      'INDIAN BIDDING LEAGUE',
                                      style: GoogleFonts.cinzel(
                                        fontSize: size.height * 0.07,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.borderGold,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  AppImages.goldenCrownLine,
                                  width: 200,
                                  height: 30,
                                ),
                                const StarLine(fontSize: 16),
                              ],
                            ),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: auctionItems.map((item) {
                                return AuctionCard(
                                  image: item.image,
                                  locked: item.locked,
                                  onTap: () {
                                    if (!item.locked &&
                                        item.route.isNotEmpty) {
                                      context.push(item.route, extra:  item);
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            BottomButton(
                              icon: AppImages.ruleBookMenuIcon,
                              title: "RULE BOOK",
                              onTap: () {
                                context.push('/ruleBook');
                              },
                            ),
                            BottomButton(
                              icon: AppImages.exitMenuIcon,
                              title: "EXIT",
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// ✅ LOADING OVERLAY
                if (state is HomeLoading || state is HomeInitial)
                  const Positioned.fill(child: GameLoadingOverlay()),

                /// ❌ ERROR OVERLAY
                if (state is HomeError)
                  Positioned.fill(
                    child: GameErrorOverlay(
                      message: state.message,
                      onRetry: () {
                        final authState =
                            context.read<UserAuthBloc>().state;

                        String uid = '';
                        if (authState is EmailAuthenticated) {
                          uid = authState.user.uid;
                        } else if (authState is GoogleAuthenticated) {
                          uid = authState.user.uid;
                        } else if (authState is GuestAuthenticated) {
                          uid = authState.user.uid;
                        }

                        context
                            .read<HomeBloc>()
                            .add(FetchUserData(uid));
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ================= TOP BAR =================
  Widget _buildTopBar({
    required BuildContext context,
    required bool loading,
    UserDataEntity? userData,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TopUserBar(loading: loading, userData: userData),
          /// ACTION BUTTONS
          Row(
            spacing: 20,
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: [
              TopActionButton(
                icon: AppImages.rewardMenuIcon,
                title: 'REWARDS',
                onTap: (){

                },
                iconSize: 40,
              ),
              TopActionButton(
                icon: AppImages.shopMenuIcon,
                title: 'SHOP',
                onTap:  () {
                  context.push('/shop');
                },
                iconSize: 40,
              ),
              TopActionButton(
                icon: AppImages.mailMenuIcon,
                title: 'MAIL',
                onTap: () {},
                iconSize: 40,
              ),
              TopActionButton(
                icon: AppImages.settingsMenuIcon,
                title: 'SETTINGS',
                onTap: () {
                  context.push('/settings');
                },
                iconSize: 40,
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// ================= AUCTION CARD =================
class AuctionCard extends StatelessWidget {
  final String image;
  final bool locked;
  final VoidCallback onTap;

  const AuctionCard({
    required this.image,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: locked ? null : onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            image,
            height: size.height * 0.4,
          ),

          if (locked)
            const Positioned(top: 0, right: 5, child: LockIcon()),

          Positioned(
            bottom: 0,
            child: InfoIcon(
              isLocked: locked,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= LOCK ICON =================
class LockIcon extends StatelessWidget {
  const LockIcon();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black54.withValues(alpha: 0.2),
      child: Icon(Icons.lock, color: Colors.amber),
    );
  }
}

/// ================= INFO ICON =================
class InfoIcon extends StatelessWidget {
  final bool isLocked;
  final void Function()? onTap;

  const InfoIcon({
    required this.isLocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.black54.withValues(alpha: 0.2),
        child: Icon(
            Icons.info_outline,
            color: AppTheme.borderGold,
          size: 18,
        ),
      ),
    );
  }
}

/// ================= TOP BUTTON =================
class TopActionButton extends StatelessWidget {
  final String icon;
  final String title;
  final double iconSize;
  final VoidCallback? onTap;

  const TopActionButton({
    required this.icon,
    required this.title,
    required this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(icon, width: iconSize),
          Text(
            title,
            style: GoogleFonts.cinzel(
              color: AppTheme.borderGold,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

/// ================= BOTTOM BUTTON =================
class BottomButton extends StatelessWidget {
  final String icon;
  final String title;
  final void Function()? onTap;

  const BottomButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(icon, width: 40),
          const SizedBox(width: 5),
          Text(
            title,
            style: GoogleFonts.roboto(
              color: AppTheme.borderGold,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= LOADING OVERLAY =================
class GameLoadingOverlay extends StatelessWidget {
  const GameLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      ),
    );
  }
}

/// ================= ERROR OVERLAY =================
class GameErrorOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const GameErrorOverlay({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: Colors.red, size: 60),
              const SizedBox(height: 10),
              Text(
                "CONNECTION LOST",
                style: TextStyle(
                  color: AppTheme.borderGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text("RETRY"),
              )
            ],
          ),
        ),
      ),
    );
  }
}