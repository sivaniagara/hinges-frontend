import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hinges_frontend/core/presentation/widgets/icon_with_circular_border.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/widgets/top_user_bar.dart';
import 'package:hinges_frontend/core/presentation/widgets/adaptive_status_bar.dart';
import 'package:hinges_frontend/core/theme/app_theme.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';

import '../../../home/domain/entities/user_data_entity.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../home/presentation/widgets/app_background.dart';
import '../widgets/golden_dialog.dart';

/// ================= MODEL =================
enum MiniAuctionLiteModeEnum {classic, premium, elite, royal}
class MiniAuctionItem {
  final String image;
  final int fee;
  final String name;
  final bool locked;
  final MiniAuctionLiteModeEnum miniAuctionLiteModeEnum;

  const MiniAuctionItem({
    required this.image,
    required this.fee,
    required this.name,
    required this.locked,
    required this.miniAuctionLiteModeEnum,
  });
}

class MiniAuctionLiteMode {
  final MiniAuctionItem miniAuctionItem;
  MiniAuctionLiteMode(this.miniAuctionItem);
}

/// ================= SCREEN =================

class MiniAuctionScreen extends StatefulWidget {
  const MiniAuctionScreen({super.key});

  @override
  State<MiniAuctionScreen> createState() => _MiniAuctionScreenState();
}

class _MiniAuctionScreenState extends State<MiniAuctionScreen> {
  late UserDataEntity userData;
  MiniAuctionLiteMode? selectedMode;

  static const List<MiniAuctionItem> items = [
    MiniAuctionItem(
        image: AppImages.classic,
        fee: 100, 
        name: "CLASSIC",
        locked: false, 
        miniAuctionLiteModeEnum: MiniAuctionLiteModeEnum.classic
    ),
    MiniAuctionItem(
        image: AppImages.premium,
        fee: 250,
        name: "PREMIUM", 
        locked: true, 
        miniAuctionLiteModeEnum: MiniAuctionLiteModeEnum.premium
    ),
    MiniAuctionItem(
        image: AppImages.elite,
        fee: 500, 
        name: "ELITE",
        locked: true,
        miniAuctionLiteModeEnum: MiniAuctionLiteModeEnum.elite
    ),
    MiniAuctionItem(
        image: AppImages.royal,
        fee: 1000, 
        name: "ROYAL", 
        locked: true,
        miniAuctionLiteModeEnum: MiniAuctionLiteModeEnum.royal
    ),
  ];

  @override
  void initState() {
    super.initState();

    /// Fullscreen landscape
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final state = context.read<HomeBloc>().state;
    if (state is HomeLoaded) {
      userData = state.userData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: AppBackground(
        animateContent: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Header(userData: userData),

              /// MAIN CONTENT
              selectedMode == null
                  ? _ArenaSelection(
                items: items,
                onSelect: (item) {
                  setState(() {
                    selectedMode = MiniAuctionLiteMode(
                      item
                    );
                  });
                },
              )
                  : _ModeSelection(
                mode: selectedMode!,
                size: size,
              ),

              const _BottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}

void showClassicRoomDialog(BuildContext context,MiniAuctionItem miniAuctionItem) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (context) {
      return Dialog(
        backgroundColor: AppTheme.navyBlue,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: GoldenDialog(miniAuctionItem: miniAuctionItem,),
      );
    },
  );
}

/// ================= HEADER =================

class _Header extends StatelessWidget {
  final UserDataEntity userData;

  const _Header({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TopUserBar(loading: false, userData: userData),
        GestureDetector(
          onTap: () => context.pop(),
          child: Column(
            children: [
              Image.asset(AppImages.homeMenuIcon, width: 50),
              Text(
                'HOME',
                style: GoogleFonts.cinzel(
                  color: AppTheme.borderGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ================= ARENA SELECTION =================

class _ArenaSelection extends StatelessWidget {
  final List<MiniAuctionItem> items;
  final Function(MiniAuctionItem) onSelect;

  const _ArenaSelection({
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CrownTitle(text: 'CHOOSE YOUR ARENA'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.map((item) {
            return MiniAuctionLiteCard(
              image: item.image,
              fee: item.fee.toString(),
              isLocked: item.locked,
              onTap: () => onSelect(item),
              miniAuctionItem: item,
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// ================= MODE SELECTION =================

class _ModeSelection extends StatelessWidget {
  final MiniAuctionLiteMode mode;
  final Size size;

  const _ModeSelection({
    required this.mode,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        CrownTitle(text: '${mode.miniAuctionItem.name} ROOM'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Entry Fee - ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
            Image.asset(AppImages.coinMenuIcon, width: 20,),
            Text('${mode.miniAuctionItem.fee} COINS', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            GameCard(
              image: AppImages.playOnline,
              onTap: () => context.go('/game'),
              size: size,
            ),
            const SizedBox(width: 20),
            GameCard(
              image: AppImages.playWithFriends,
              onTap: () {
                context.push('/playWithFriends', extra: mode);
              },
              size: size,
            ),
          ],
        ),
      ],
    );
  }
}

/// ================= TITLE =================

class CrownTitle extends StatelessWidget {
  final String text;

  const CrownTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppImages.headerGoldenCrown, width: 150, height: 20),
        Text(
          text,
          style: GoogleFonts.cinzel(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.borderGold,
          ),
        ),
        Image.asset(AppImages.goldenCrownLine, width: 200, height: 20),
      ],
    );
  }
}

/// ================= GAME CARD =================

class GameCard extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  final Size size;

  const GameCard({
    required this.image,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        image,
        width: 250,
      ),
    );
  }
}

/// ================= BOTTOM BAR =================

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconWithCircularBorder(
            image: AppImages.ruleBookMenuIcon,
            settingName: "RULE BOOK",
          ),
          Container(
            width: size.width * 0.4,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.goldenFrame),
              ),
            ),
            child: Text(
              'MINI AUCTION LITE',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.borderGold,
              ),
            ),
          ),
          IconWithCircularBorder(
            image: AppImages.settingsMenuIcon,
            settingName: "SETTINGS",
          ),
        ],
      ),
    );
  }
}

/// ================= CARD =================

class MiniAuctionLiteCard extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  final String fee;
  final bool isLocked;
  final MiniAuctionItem miniAuctionItem;

  const MiniAuctionLiteCard({
    super.key,
    required this.image,
    required this.onTap,
    required this.fee,
    required this.isLocked,
    required this.miniAuctionItem,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return InkWell(
      onTap: isLocked ? null : onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            image,
            height: size.height * 0.38,
            width: size.width / 6,
            fit: BoxFit.fill,
          ),

          /// LOCK ICON
          if (isLocked)
            const Positioned(
              top: 10,
              right: 10,
              child: Icon(Icons.lock, color: Colors.red),
            ),

          /// INFO ICON
          Positioned(
            bottom: 0,
            right: 0,
            child: InfoIcon(
                isLocked: false,
              onTap: (){
                  showClassicRoomDialog(context, miniAuctionItem);
              },

            ),
          ),

          Positioned(
            bottom: 28,
            child: Column(
              children: [
                Text(
                  'ENTRY FEE',
                  style: GoogleFonts.cinzel(
                    color: AppTheme.borderGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(AppImages.coinMenuIcon, width: 15),
                    const SizedBox(width: 5),
                    Text(
                      '$fee COIN',
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
        ],
      ),
    );
  }
}