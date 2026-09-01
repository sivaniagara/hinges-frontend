import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hinges_frontend/core/presentation/widgets/icon_with_circular_border.dart';
import 'package:hinges_frontend/core/utils/app_ids.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/widgets/top_user_bar.dart';
import 'package:hinges_frontend/core/presentation/widgets/adaptive_status_bar.dart';
import 'package:hinges_frontend/core/theme/app_theme.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';

import '../../../../core/utils/so_loud.dart';
import '../../../game/presentation/pages/game_screen.dart';
import '../../../home/domain/entities/auction_category_item_entity.dart';
import '../../../home/domain/entities/user_data_entity.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../home/presentation/widgets/app_background.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../widgets/golden_dialog.dart';

/// ================= MODEL =================
enum MiniAuctionLiteModeEnum {classic, premium, elite, royal}
class MiniAuctionItem {
  final String id;
  final String image;
  final int fee;
  final int firstPrize;
  final int secondPrize;
  final int thirdPrize;
  final String name;
  final bool locked;
  final MiniAuctionLiteModeEnum miniAuctionLiteModeEnum;

  const MiniAuctionItem({
    required this.id,
    required this.image,
    required this.fee,
    required this.firstPrize,
    required this.secondPrize,
    required this.thirdPrize,
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
  final AuctionItem auctionItem;
  const   MiniAuctionScreen({super.key, required this.auctionItem});

  @override
  State<MiniAuctionScreen> createState() => _MiniAuctionScreenState();
}

class _MiniAuctionScreenState extends State<MiniAuctionScreen> {
  late UserDataEntity userData;
  MiniAuctionLiteMode? selectedMode;
  List<MiniAuctionItem> items = [];

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
      if(widget.auctionItem.auctionModeEnum == AuctionModeEnum.miniAuctionLite){
        items = userData.categoryAndItsItem.miniAuctionLiteCategoryId.map((miniAuctionLiteItem) {
          AuctionCategoryItemEntity auctionCategoryItemEntity = userData.auctionCategoryItem.firstWhere((e) => e.categoryItemId == miniAuctionLiteItem.id);
          final imageAndMode = {
            AppIds.miniAuctionLiteClassicId: (AppImages.miniAuctionLiteClassic, MiniAuctionLiteModeEnum.classic, false),
            AppIds.miniAuctionLitePremiumId: (AppImages.miniAuctionLitePremium, MiniAuctionLiteModeEnum.premium, !(userData.miniAuctionLiteClassicPlayed >= 50)),
            AppIds.miniAuctionLiteEliteId: (AppImages.miniAuctionLiteElite, MiniAuctionLiteModeEnum.elite, !(userData.miniAuctionLitePremiumPlayed >= 50)),
            AppIds.miniAuctionLiteRoyalId: (AppImages.miniAuctionLiteRoyal, MiniAuctionLiteModeEnum.royal, !(userData.miniAuctionLiteElitePlayed >= 50)),
          };
          final id = auctionCategoryItemEntity.id;
          return MiniAuctionItem(
              id: id,
              image: imageAndMode[id]!.$1,
              fee: auctionCategoryItemEntity.coinsGameFees,
              firstPrize: auctionCategoryItemEntity.coinsFirstPrize,
              secondPrize: auctionCategoryItemEntity.coinsSecondPrize,
              thirdPrize: auctionCategoryItemEntity.coinsThirdPrize,
              name: miniAuctionLiteItem.categoryItemName,
              locked: imageAndMode[id]!.$3,
              miniAuctionLiteModeEnum: imageAndMode[id]!.$2
          );
        }).toList();
      }
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
        SizedBox(width: 20,),
        // TopUserBar(loading: false, userData: userData, onAddTap: () {  },),
        GestureDetector(
          onTap: () {
            playVibrateOnly(duration: 10);
            context.pop();
          },
          child: Column(
            children: [
              Image.asset(AppImages.homeMenuIcon, width: 50),
              Text(
                'HOME',
                style: GoogleFonts.rajdhani(
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
    final size = MediaQuery.of(context).size;

    return Column(
      spacing: 20,
      children: [
        Column(
          spacing: 2,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StarLine(content: 'CHOOSE YOUR AUCTION ROOM', fontSize: 18,),
            Image.asset(
              AppImages.goldenCrownLine,
              width: 200,
              height: 20,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.map((item) {
            return MiniAuctionLiteCard(
              image: item.image,
              fee: item.fee.toString(),
              isLocked: item.locked,
              onTap: () {
                playSoundFromList(8);
                onSelect(item);
              },
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
      children: [
        CrownTitle(text: '${mode.miniAuctionItem.name.toUpperCase()} ROOM', fontSize: 24,),
        SizedBox(height: 20,),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ENTRY FEE - ', style: GoogleFonts.rajdhani(textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),),
            Image.asset(AppImages.coinMenuIcon, width: 20,),
            Text('${mode.miniAuctionItem.fee} COINS', style: GoogleFonts.rajdhani(textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            GameCard(
              image: AppImages.playOnline,
              onTap: () {
                playSoundFromList(8);
                context.go('/game', extra: {
                  "mode": mode,
                  "matchType": MatchTypeEnum.normalMatch,
                  "id": mode.miniAuctionItem.id
                });
              },
              size: size,
            ),
            const SizedBox(width: 20),
            GameCard(
              image: AppImages.playWithFriends,
              onTap: () {
                playSoundFromList(8);
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
  final double fontSize;

  const CrownTitle({
    super.key,
    required this.text,
    this.fontSize = 20
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image.asset(AppImages.headerGoldenCrown, width: 150, height: 20),
        Text(
          text,
          style: GoogleFonts.rajdhani(
            fontSize: fontSize,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IconWithCircularBorder(
          //   image: AppImages.ruleBookMenuIcon,
          //   settingName: "RULE BOOK",
          // ),
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
              style: GoogleFonts.rajdhani(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.borderGold,
              ),
            ),
          ),
          // IconWithCircularBorder(
          //   image: AppImages.settingsMenuIcon,
          //   settingName: "SETTINGS",
          // ),
        ],
      ),
    );
  }
}

/// ================= CARD =================

class MiniAuctionLiteCard extends StatefulWidget {
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
  State<MiniAuctionLiteCard> createState() => _MiniAuctionLiteCardState();
}

class _MiniAuctionLiteCardState extends State<MiniAuctionLiteCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    // Damped oscillation: a few back-and-forth wiggles that settle down.
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 6, end: -3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -3, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isLocked) {
      // Give feedback that this card is locked instead of doing nothing.
      HapticFeedback.mediumImpact();
      _shakeController.forward(from: 0);
      return;
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return InkWell(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: child,
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              widget.image,
              height: 170,
              width: 150,
              fit: BoxFit.fill,
            ),

            /// LOCK ICON
            if (widget.isLocked)
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.lock, color: AppTheme.borderGold, size: 18),
              ),

            /// INFO ICON
            Positioned(
              bottom: 0,
              right: 0,
              child: InfoIcon(
                isLocked: false,
                onTap: (){
                  playSoundFromList(7);
                  showClassicRoomDialog(context, widget.miniAuctionItem);
                },

              ),
            ),

            Positioned(
              bottom: 10,
              child: Column(
                children: [
                  Text(
                    'ENTRY FEE',
                    style: GoogleFonts.rajdhani(
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
                        '${widget.fee} COINS',
                        style: GoogleFonts.rajdhani(
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
      ),
    );
  }
}