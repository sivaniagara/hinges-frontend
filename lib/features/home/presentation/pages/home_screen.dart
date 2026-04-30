import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/login/presentation/widgets/shared_decorations.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/presentation/widgets/shimmer_widget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';

import '../../../login/presentation/bloc/user_auth_bloc.dart';
import '../../domain/entities/user_data_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/app_background.dart';
import '../widgets/auction_card_shimmer.dart';

import '../widgets/currency_bar.dart';
import 'profile_dialog.dart';
import 'setting_dialog.dart';
import 'shop_dialog.dart';

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
          {
            "image": AppImages.miniAuctionLite,
            "locked": false,
            "route": "/miniAuction",
          },
          {
            "image": AppImages.miniAuctionPro,
            "locked": true,
          },
          {
            "image": AppImages.megaAuctionLite,
            "locked": true,
          },
          {
            "image": AppImages.megaAuctionPro,
            "locked": true,
          },
        ];

        return AdaptiveStatusBar(
          color: Theme.of(context).colorScheme.surface,
          child: AppBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  _buildTopBar(
                    context: context,
                    loading: isLoading,
                    userData: userData,
                  ),

                  /// MAIN CONTENT
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// TITLE
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
                            StarLine(fontSize: 16,),
                          ],
                        ),

                        /// AUCTION CARDS
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: auctionItems.map((item) {
                            return _AuctionCard(
                              image: item["image"] as String,
                              locked: item["locked"] as bool,
                              onTap: () {
                                if (!(item["locked"] as bool) &&
                                    item["route"] != null) {
                                  context.push(
                                      item["route"] as String);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  /// BOTTOM BAR
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        _BottomButton(
                          icon: AppImages.ruleBookMenuIcon,
                          title: "RULE BOOK",
                        ),
                        _BottomButton(
                          icon: AppImages.exitMenuIcon,
                          title: "EXIT",
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
          Row(
            spacing: 20,
            children: [
              GestureDetector(
                onTap: () {
                  if (userData != null) {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          ProfileDialog(userData: userData),
                    );
                  }
                },
                child: _ProfileCard(
                  loading: loading,
                  name: userData?.userName ?? "USER",
                ),
              ),
              CurrencyBar(
                icon: AppImages.coinMenuIcon,
                value: userData?.coinWon ?? 0,
                onAddTap: () {
                  // handle coin add
                },
              ),
              CurrencyBar(
                icon: AppImages.diamondMenuIcon,
                value: userData?.coinWon ?? 0,
                onAddTap: () {
                  // handle diamond add
                },
              ),
            ],
          ),
          /// ACTION BUTTONS
          Row(
            spacing: 20,
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: [
              _TopActionButton(
                icon: AppImages.rewardMenuIcon,
                title: 'REWARDS',
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const ShopDialog(),
                ),
                iconSize: 30,
              ),
              _TopActionButton(
                icon: AppImages.shopMenuIcon,
                title: 'SHOP',
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const ShopDialog(),
                ),
                iconSize: 38,
              ),
              _TopActionButton(
                icon: AppImages.mailMenuIcon,
                title: 'MAIL',
                onTap: () {},
                iconSize: 38,
              ),
              _TopActionButton(
                icon: AppImages.settingsMenuIcon,
                title: 'SETTINGS',
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const SettingDialog(),
                ),
                iconSize: 30,
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// ================= AUCTION CARD =================
class _AuctionCard extends StatelessWidget {
  final String image;
  final bool locked;
  final VoidCallback onTap;

  const _AuctionCard({
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
            const Positioned(top: 0, right: 5, child: _LockIcon()),

          Positioned(
            bottom: 0,
            child: _InfoIcon(
              isLocked: locked,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= LOCK ICON =================
class _LockIcon extends StatelessWidget {
  const _LockIcon();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black54.withValues(alpha: 0.2),
      child: Icon(Icons.lock, color: Colors.amber),
    );
  }
}

/// ================= INFO ICON =================
class _InfoIcon extends StatelessWidget {
  final bool isLocked;

  const _InfoIcon({required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF08142E),
          builder: (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isLocked
                  ? "This mode is locked."
                  : "Tap to start auction.",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
      child: CircleAvatar(
        backgroundColor: Colors.black54.withValues(alpha: 0.2),
        child: Icon(Icons.info_outline, color: Colors.white),
      ),
    );
  }
}

/// ================= PROFILE =================
class _ProfileCard extends StatelessWidget {
  final bool loading;
  final String name;

  const _ProfileCard({
    required this.loading,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.amber),
          const SizedBox(width: 6),
          Text(
            loading ? "..." : name.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// ================= TOP BUTTON =================
class _TopActionButton extends StatelessWidget {
  final String icon;
  final String title;
  final double iconSize;
  final VoidCallback? onTap;

  const _TopActionButton({
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
class _BottomButton extends StatelessWidget {
  final String icon;
  final String title;

  const _BottomButton({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderGold),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 25),
          const SizedBox(width: 5),
          Text(
            title,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}