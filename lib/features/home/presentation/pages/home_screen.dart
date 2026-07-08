import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_sounds.dart';
import 'package:hinges_frontend/features/home/presentation/widgets/top_user_bar.dart';
import 'package:hinges_frontend/features/login/presentation/widgets/shared_decorations.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../ads/bloc/ad_bloc.dart';
import '../../../ads/bloc/ad_event.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';

import '../../../../core/utils/audio_manager.dart';
import '../../../../core/utils/so_loud.dart';
import '../../../login/presentation/bloc/user_auth_bloc.dart';
import '../../domain/entities/user_data_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/app_background.dart';
import '../widgets/currency_burst_overlay.dart';

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
  /// Marks the CurrencyBar's on-screen position so the coin-burst
  /// animation knows exactly where to fly the coins to.
  final GlobalKey _currencyBarKey = GlobalKey();

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
                                Column(
                                  spacing: 2,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppImages.indianBiddingLeague,
                                      height: size.height * 0.15,
                                    ),
                                    StarLine(content: 'CHOOSE YOUR ARENA', fontSize: 18,),
                                    Image.asset(
                                      AppImages.goldenCrownLine,
                                      width: 200,
                                      height: 20,
                                    ),
                                  ],
                                ),
                                // Image.asset(
                                //   AppImages.goldenCrownLine,
                                //   width: 200,
                                //   height: 30,
                                // ),
                                // const StarLine(fontSize: 16),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: auctionItems.map((item) {
                                return AuctionCard(
                                  image: item.image,
                                  locked: item.locked,
                                  onTap: () {
                                    playTap();
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
                                playTap();
                                context.push('/ruleBook');
                              },
                            ),
                            BottomButton(
                              icon: AppImages.exitMenuIcon,
                              title: "EXIT",
                              onTap: () {
                                playTap();
                              },
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

  /// ================= REWARDS =================
  void _onRewardsTap(BuildContext context) {
    final adBloc = context.read<AdBloc>();
    final homeBloc = context.read<HomeBloc>();
    final homeState = homeBloc.state;

    if (homeState is! HomeLoaded) {
      return;
    }

    final userId = homeState.userData.userId;

    if (!adBloc.adService.isRewardedReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad is still loading, try again in a moment.'),
        ),
      );
      // Make sure a load is in flight so it's ready next tap.
      adBloc.add(LoadRewardedAd());
      return;
    }

    adBloc.add(
      ShowRewardedAd(
        onRewardEarned: () {
          // Increase user coins after ad is watched
          homeBloc.add(IncreaseUserCoins(userId: userId, coins: 200));

          // Fly coins from the middle of the screen into the CurrencyBar.
          // Guard with `mounted` since this callback fires asynchronously
          // (after the user finishes watching the ad), so the HomeScreen
          // could theoretically be gone by the time it runs.

        },
        onAdClosed: () {
          print("show animation..");
          if (!mounted) return;
          final size = MediaQuery.of(context).size;
          CoinBurstOverlay.show(
            context,
            targetKey: _currencyBarKey,
            startPosition: Offset(size.width / 2, size.height / 2),
            coinAsset: AppImages.coinMenuIcon,
            coinCount: 12,
          );
          // Optional: anything you want to run once the ad is dismissed.
        },
      ),
    );
  }

  /// ================= REWARDS DIALOG =================
  void _showRewardsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      // NOTE: renamed the builder's parameter to `dialogContext` so it
      // doesn't shadow the outer (HomeScreen State) `context`. The old
      // code reused the name `context` here, then passed *that* shadowed
      // dialog context into `_onRewardsTap`, which stores it and uses it
      // later inside `onRewardEarned` — by which point the dialog (and
      // its context) had already been popped/deactivated. That silently
      // broke `MediaQuery.of(context)` / `Overlay.of(context)` inside
      // CoinBurstOverlay.show, so the coin count still updated (no
      // context needed for that) but the flying-coin animation never
      // appeared.
      builder: (dialogContext) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.goldenDialogFrame),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      playTap();
                      Navigator.pop(dialogContext);
                    },
                    child: Image.asset(AppImages.cancelIcon, width: 35),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      'EARN REWARDS',
                      style: GoogleFonts.rajdhani(
                        color: AppTheme.borderGold,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Image.asset(
                      AppImages.watchAds,
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.coinMenuIcon, width: 30),
                        const SizedBox(width: 10),
                        Text(
                          '200 COINS',
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        playTap();
                        // Pop the dialog using ITS OWN context...
                        Navigator.pop(dialogContext);
                        // ...then continue using the stable outer
                        // (HomeScreen State) context, which stays valid
                        // for as long as the screen itself is mounted.
                        _onRewardsTap(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF004D00), // Very dark green
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.borderGold,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_arrow,
                                color: Colors.yellow, size: 28),
                            const SizedBox(width: 10),
                            Text(
                              'WATCH AD',
                              style: GoogleFonts.rajdhani(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
          TopUserBar(
            loading: loading,
            userData: userData,
            currencyBarKey: _currencyBarKey,
            onAddTap: () {
              playTap();
              context.push('/shop');
            },
          ),
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
                  playTap();
                  _showRewardsDialog(context);
                },
                iconSize: 40,
              ),
              TopActionButton(
                icon: AppImages.shopMenuIcon,
                title: 'SHOP',
                onTap:  () {
                  playTap();
                  context.push('/shop');
                },
                iconSize: 40,
              ),
              TopActionButton(
                icon: AppImages.settingsMenuIcon,
                title: 'SETTINGS',
                onTap: () {
                  playTap();
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
            style: GoogleFonts.rajdhani(
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
          Image.asset(icon, width: 50),
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