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
import 'package:hinges_frontend/features/home/presentation/widgets/particle_background.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/utils/app_images.dart';
import '../../../login/presentation/bloc/user_auth_bloc.dart';
import '../../domain/entities/user_data_entity.dart';
import '../widgets/glow_wrapper.dart';
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
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF020617)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  ParticleBackground(),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTopBar(
                        context: context,
                        loading: isLoading,
                        userData: userData,
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AttentionWrapper(
                                      child: PremiumAuctionCard(
                                        title: "MINI AUCTION",
                                        isLocked: false,
                                        loading: isLoading,
                                        image: AppImages.miniAuction,
                                        onTap: () {
                                          context.push('/miniAuction');
                                        },
                                        infoTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => const DialogDetails(
                                              points: [
                                                'ONLY 5 SLOTS TO BE FILLED',
                                                'PRIZE BASED ON RANK',
                                                'READ RULE BOOK FOR DETAILS'
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Opacity(
                                      opacity: 0.6,
                                      child: PremiumAuctionCard(
                                        title: "MEGA AUCTION",
                                        isLocked: false,
                                        loading: isLoading,
                                        image: AppImages.megaAuction,
                                        onTap: () {
                                          context.push('/miniAuction');
                                        },
                                        infoTap: () {
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        showDialog(
                                          context: context,
                                          builder: (context) => const RuleBookDialog(),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(width: 60, AppImages.ruleBookMenuIcon),
                                            Text(
                                              'Rule Book',
                                              style: GoogleFonts.jockeyOne(
                                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        showDialog(
                                          context: context,
                                          builder: (context) => const SettingDialog(),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Image.asset(width: 60, AppImages.settingsMenuIcon),
                                            Text(
                                              'Settings',
                                              style: GoogleFonts.jockeyOne(
                                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
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
      child: Row(
        children: [
          GestureDetector(
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // 🔥 Glow Background
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF1E293B),
                                  Color(0xFF0F172A),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                              border: Border.all(color: Colors.amber, width: 1.5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (loading)
                                  const ShimmerWidget(width: 40, height: 12)
                                else
                                  Text(
                                    userData?.coinWon.toString() ?? "0",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                const SizedBox(width: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.greenAccent.withOpacity(0.6),
                                        blurRadius: 8,
                                      )
                                    ],
                                  ),
                                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),

                          // 🪙 Coin Icon (floating)
                          Positioned(
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.7),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: Image.asset(
                                AppImages.coinsMenuIcon,
                                width: 42,
                                height: 42,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
              ],
            ),
          )

        ],
      ),
    );
  }
}

class PremiumAuctionCard extends StatefulWidget {
  final String title;
  final bool isLocked;
  final bool loading;
  final String? image;
  final VoidCallback? onTap;
  final VoidCallback? infoTap;

  const PremiumAuctionCard({
    super.key,
    required this.title,
    required this.isLocked,
    required this.loading,
    required this.image,
    this.onTap,
    this.infoTap,
  });

  @override
  State<PremiumAuctionCard> createState() => _PremiumAuctionCardState();
}

class _PremiumAuctionCardState extends State<PremiumAuctionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> floatAnim;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
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
    final size = MediaQuery.of(context).size;

    if (widget.loading) return const AuctionCardShimmer();

    return Column(
      children: [
        Text(
          widget.title,
          style: GoogleFonts.oxanium(
            color: widget.isLocked ? Colors.amber : Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        GestureDetector(
          onTap: widget.onTap,
          child: Image.asset(
            widget.image!,
            width: size.width * 0.35,
            height: size.height * 0.45,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 10),
      ],
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
        spacing: 5,
        children: [
          Image.asset(width: 40, icon),
          Text(
            title,
            style: GoogleFonts.jockeyOne(
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}