import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../widgets/app_background.dart';

class MiniAuctionLiteRuleBookScreen extends StatelessWidget {
  const MiniAuctionLiteRuleBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ScrollController scrollController = ScrollController();

    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: AppBackground(
        animateContent: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 10),

              /// 🔹 HEADER
              SizedBox(
                width: double.infinity,
                height: 90,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "MINI AUCTION LITE RULE BOOK",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          color: AppTheme.borderGold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// 🔹 BACK BUTTON
                    Positioned(
                      right: 20,
                      top: 10,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Image.asset(
                          AppImages.homeMenuIcon,
                          width: 55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 MAIN RULE CONTAINER
              Container(
                width: size.width * 0.9,
                height: size.height * 0.7,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.navyBlue,
                  image: DecorationImage(
                    image: AssetImage(AppImages.goldenOutline),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  children: [
                    /// 🔸 LEFT LOGOS
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var logo in [
                          AppImages.cskLogo,
                          AppImages.miLogo,
                          AppImages.kkrLogo,
                          AppImages.srhLogo,
                          AppImages.rcbLogo
                        ])
                          Image.asset(
                            logo,
                            width: 50,
                            height: 50,
                          ),
                      ],
                    ),

                    const SizedBox(width: 10),

                    /// 🔸 RULE LIST + SCROLLBAR
                    Expanded(
                      child: Stack(
                        children: [
                          ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.only(right: 16),
                            children: const [
                              _RuleItem(
                                index: 1,
                                title: "FRANCHISE ALLOCATION",
                                description:
                                "Each user will be allocated with a franchise name randomly.",
                              ),
                              _RuleItem(
                                index: 2,
                                title: "PRE-PICKED PLAYERS",
                                description:
                                "The cumulative purse spent and ratings of pre-picked players will be the same for all users.",
                              ),
                              _RuleItem(
                                index: 3,
                                title: "TOTAL PURSE",
                                description:
                                "Each user will be allocated with a total purse of 25 CRORES for the entire auction.",
                              ),
                              _RuleItem(
                                index: 4,
                                title: "TEAM COMPLETION",
                                description:
                                "Users need to fill the remaining 5 SLOTS in their respective team sheet.",
                              ),
                              _RuleItem(
                                index: 5,
                                title: "PLAYER LIST ACCESS",
                                description:
                                "The list of players yet to be auctioned will be provided to users so they can plan their auction strategies.",
                              ),
                            ],
                          ),

                          /// 🔥 GOLD SCROLLBAR
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: _GoldenScrollbar(
                              controller: scrollController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 RULE ITEM
class _RuleItem extends StatelessWidget {
  final int index;
  final String title;
  final String description;

  const _RuleItem({
    required this.index,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),

      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$index. $title",
            style: GoogleFonts.cinzel(
              color: AppTheme.borderGold,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 CUSTOM GOLD SCROLLBAR
class _GoldenScrollbar extends StatefulWidget {
  final ScrollController controller;

  const _GoldenScrollbar({required this.controller});

  @override
  State<_GoldenScrollbar> createState() => _GoldenScrollbarState();
}

class _GoldenScrollbarState extends State<_GoldenScrollbar> {
  double thumbOffset = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateThumb);
  }

  void _updateThumb() {
    final maxScroll = widget.controller.position.maxScrollExtent;
    final currentScroll = widget.controller.offset;

    if (maxScroll <= 0) return;

    setState(() {
      thumbOffset = currentScroll / maxScroll;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackHeight = constraints.maxHeight;
        final thumbHeight = trackHeight * 0.25;

        return Container(
          width: 12,
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              /// TRACK
              Container(
                width: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// GOLD THUMB
              Positioned(
                top: (trackHeight - thumbHeight) * thumbOffset,
                child: Container(
                  width: 8,
                  height: thumbHeight,
                  decoration: BoxDecoration(
                    color: AppTheme.borderGold,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.borderGold.withOpacity(0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}