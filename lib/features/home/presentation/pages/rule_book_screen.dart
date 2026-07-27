import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/audio_manager.dart';
import '../../../../core/utils/so_loud.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../widgets/app_background.dart';

/// Rule book detail screen for "Mini Auction Lite".
///
/// Design language: real glassmorphism (frosted blur panels, not flat black
/// overlays) so the cards sit on top of the blue starfield background rather
/// than fighting it. Each category carries its own accent color — pulled
/// from the same curated gradients — so tabs and their content read as
/// distinct sections while staying inside one cohesive gold/blue palette.
class RuleBookScreen extends StatelessWidget {
  const RuleBookScreen({super.key});

  static final List<_RuleCategory> _categories = [
    _RuleCategory(
      label: 'OVERVIEW',
      icon: Icons.info_outline,
      accent: const Color(0xFFFDC830),
      sections: [
        _RuleSection(
          number: '1',
          title: 'Match Format',
          icon: Icons.people_outline,
          paragraphs: [
            'Mini Auction Lite is a multiplayer cricket auction where 5 users compete simultaneously. Each auction room consists of 5 participants, with every player representing one randomly allocated franchise.',
          ],
        ),
        _RuleSection(
          number: '2',
          title: 'Franchise Allocation',
          icon: Icons.business_center_outlined,
          paragraphs: [
            'A total of 10 franchises are available in the game. At the beginning of each auction, 5 franchises are randomly assigned to the participating users. Each user represents only the franchise allocated to them for that auction.',
          ],
        ),
        _RuleSection(
          number: '7',
          title: 'Auction Structure',
          icon: Icons.timeline_outlined,
          paragraphs: [
            'The auction consists of 5 rounds. Rounds 1–4 consist of role-based player sets, randomized for every auction room:',
          ],
          bullets: const ['Batsmen Set', 'Wicket-Keepers Set', 'All-Rounders Set', 'Bowlers Set'],
          footnote: 'Round 5 is always the Accelerated Set and is fixed as the final round. A Round Break (30 Seconds) is provided after each round to review squads and plan strategy.',
        ),
        _RuleSection(
          number: '8',
          title: 'Player Information',
          icon: Icons.assignment_outlined,
          paragraphs: ['Every player presented during the auction includes:'],
          bullets: const [
            'Player Name',
            'Base Price',
            'Player Rating',
            'Player Category',
            'Playing Role',
            'Country',
            'Player Description',
          ],
          footnote: 'Users are expected to carefully analyse the player information and formulate their bidding strategy accordingly.',
        ),
      ],
    ),
    _RuleCategory(
      label: 'SQUAD & BOWLING',
      icon: Icons.groups_outlined,
      accent: const Color(0xFF4FC3F7),
      sections: [
        _RuleSection(
          number: '3',
          title: 'Squad Status',
          icon: Icons.sports_cricket_outlined,
          paragraphs: [
            'Every franchise begins the auction with a partially completed squad — 12 total player slots, 7 already filled, 5 to be filled during the auction.',
          ],
          statTiles: const [
            _StatTile('SQUAD RATING', '59.5'),
            _StatTile('TOTAL PURSE', '₹60.00 Cr'),
            _StatTile('PURSE SPENT', '₹35.00 Cr'),
            _StatTile('PURSE LEFT', '₹25.00 Cr', highlight: true),
          ],
          footnote: 'The objective is to complete the remaining five player slots while maintaining all squad requirements.',
        ),
        _RuleSection(
          number: '4',
          title: 'Squad Composition Rules',
          icon: Icons.assignment_turned_in_outlined,
          paragraphs: ['To successfully complete the squad, users must fill the remaining five vacancies as follows:'],
          table: const _RuleTable(
            headers: ['Role', 'Total', 'Filled', 'Auction'],
            rows: [
              ['Batsman', '3', '2', '1'],
              ['Wicket-Keeper', '2', '1', '1'],
              ['All-Rounder', '4', '2', '2'],
              ['Bowler', '3', '2', '1'],
            ],
            highlightLastColumn: true,
          ),
          footnote: 'Every completed squad must satisfy the above composition.',
        ),
        _RuleSection(
          number: '5',
          title: 'Category Requirements',
          icon: Icons.category_outlined,
          paragraphs: ['The completed squad must also satisfy the player category distribution. Remaining players required:'],
          table: const _RuleTable(
            headers: ['Category', 'Total', 'Filled', 'Auction'],
            rows: [
              ['Indian Capped (ICP)', '5', '3', '2'],
              ['Foreign Player (FP)', '4', '2', '2'],
              ['Indian Uncapped (IUP)', '3', '2', '1'],
            ],
            highlightLastColumn: true,
          ),
          footnote: 'Failure to satisfy the category requirements will result in squad disqualification.',
          emphasizeFootnote: true,
        ),
        _RuleSection(
          number: '6',
          title: 'Bowling Combination',
          icon: Icons.sports_baseball_outlined,
          paragraphs: [
            'Every completed squad must contain a balanced bowling attack. Across the combined All-Rounder and Bowler positions (7 players), the squad must include:',
          ],
          bullets: const [
            'One Right Arm Fast (RAF)',
            'One Left Arm Fast (LAF)',
            'One Right Arm Spin (RAS)',
            'One Left Arm Spin (LAS)',
          ],
          footnote: 'Out of the above four bowling variation slots, any two may already be filled in the pre-filled squad. Users complete only the remaining two during the auction.',
        ),
      ],
    ),
    _RuleCategory(
      label: 'BIDDING & QUALIFICATION',
      icon: Icons.gavel_outlined,
      accent: const Color(0xFFFFA451),
      sections: [
        _RuleSection(
          number: '9',
          title: 'Bidding Rules',
          icon: Icons.attach_money_outlined,
          paragraphs: ['Each successful bid increases the player\'s price by ₹0.25 Crore (25 Lakhs). Users:'],
          bullets: const [
            'Cannot bid beyond their remaining purse.',
            'Cannot purchase players for already completed squad slots.',
            'Must maintain sufficient purse throughout the auction.',
            'Must ensure every purchase contributes towards mandatory squad requirements.',
          ],
          footnote: 'Any invalid bid shall not be accepted by the Auctioneer.',
        ),
        _RuleSection(
          number: '10',
          title: 'Qualification & Eligibility',
          icon: Icons.verified_outlined,
          paragraphs: [
            'The "My Squad" section displays completed slots in Green and incomplete slots in Red. To qualify for the final rankings, users must satisfy all of the following before the auction concludes:',
          ],
          bullets: const [
            'Every incomplete (Red) slot must be successfully filled and turned Green.',
            'Every mandatory squad composition requirement must be satisfied.',
            'Every mandatory player category requirement must be satisfied.',
            'Every mandatory bowling combination requirement must be satisfied.',
            'The squad must be completed within the available purse and auction rules.',
          ],
          footnote: 'Only Qualified users shall be eligible to appear in the final rankings and compete for prize rewards.',
          emphasizeFootnote: true,
        ),
        _RuleSection(
          number: '11',
          title: 'Accelerated Set',
          icon: Icons.speed_outlined,
          paragraphs: [
            'The fifth and final round is known as the Accelerated Set — the final opportunity to complete any remaining squad requirements before the auction concludes.',
            'Users are encouraged to strategically manage their purse during earlier rounds so they can effectively utilize the Accelerated Set if required.',
          ],
        ),
        _RuleSection(
          number: '12',
          title: 'Disqualification',
          icon: Icons.warning_amber_outlined,
          paragraphs: ['A user shall be Disqualified if:'],
          bullets: const [
            'One or more required squad slots remain incomplete.',
            'Any mandatory role requirement is not satisfied.',
            'Any mandatory player category requirement is not fulfilled.',
            'The mandatory bowling combination requirements are not met.',
            'The squad violates any auction rule or eligibility requirement.',
          ],
          footnote: 'Disqualified users shall not be considered for rankings or prize rewards.',
          emphasizeFootnote: true,
        ),
      ],
    ),
    _RuleCategory(
      label: 'RESULTS & PRIZES',
      icon: Icons.emoji_events_outlined,
      accent: const Color(0xFFE85D9E),
      sections: [
        _RuleSection(
          number: '13',
          title: 'Prize Eligibility',
          icon: Icons.redeem_outlined,
          paragraphs: [
            'Only users who successfully qualify before the completion of the auction shall be eligible for prize rewards. Disqualified users shall not receive any prize rewards irrespective of:',
          ],
          bullets: const ['Final Squad Rating', 'Remaining Purse', 'Number of Players Purchased', 'Individual Player Ratings'],
        ),
        _RuleSection(
          number: '14',
          title: 'Points Table',
          icon: Icons.leaderboard_outlined,
          paragraphs: ['The Points Table displays live standings of all participating users and their franchises throughout the auction, determined based on:'],
          bullets: const ['Total Squad Rating', 'Remaining Purse'],
          footnote: 'The Points Table updates in real time as users purchase players. Monitor it regularly to adjust your bidding strategy.',
        ),
        _RuleSection(
          number: '15',
          title: 'Result',
          icon: Icons.military_tech_outlined,
          paragraphs: ['Once the auction concludes, only Qualified users are considered for final rankings, determined using the following order of priority:'],
          bullets: const [
            'Primary Criteria — ranked by Final Squad Rating. Top 3 receive Gold, Silver, Bronze.',
            'Tie-Breaker 1 — if Final Squad Rating ties, higher Remaining Purse ranks higher.',
            'Tie-Breaker 2 — if both tie, the highest-rated Indian Capped Player (ICP) ranks higher.',
          ],
          footnote: 'Build squads with higher-rated players while managing your purse efficiently throughout the auction.',
        ),
        _RuleSection(
          number: '16',
          title: "Auctioneer's Decision",
          icon: Icons.gavel_rounded,
          paragraphs: [
            "The Auctioneer's decisions regarding auction proceedings, bid acceptance, player allocation, rule interpretation, technical validations, qualification, final rankings, and result declaration shall be final and binding on all participating users.",
          ],
        ),
      ],
    ),
    _RuleCategory(
      label: 'GLOSSARY',
      icon: Icons.menu_book_outlined,
      accent: const Color(0xFFB388FF),
      sections: [
        _RuleSection(
          number: '17',
          title: 'Abbreviations',
          icon: Icons.book_outlined,
          table: const _RuleTable(
            headers: ['Abbr.', 'Meaning'],
            rows: [
              ['ICP', 'Indian Capped Player'],
              ['FP', 'Foreign Player'],
              ['IUP', 'Indian Uncapped Player'],
              ['BAT', 'Batsman'],
              ['WK', 'Wicket-Keeper'],
              ['ALR', 'All-Rounder'],
              ['BOWL', 'Bowler'],
              ['CAT.', 'Category'],
              ['FR.', 'Franchise'],
              ['CTRY.', 'Country'],
              ['PR.', 'Purse Remaining'],
              ['RHB', 'Right-Handed Batsman'],
              ['LHB', 'Left-Handed Batsman'],
              ['RAF', 'Right Arm Fast'],
              ['LAF', 'Left Arm Fast'],
              ['RAS', 'Right Arm Spin'],
              ['LAS', 'Left Arm Spin'],
            ],
          ),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: AppBackground(
        animateContent: false,
        child: DefaultTabController(
          length: _categories.length,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                const SizedBox(height: 10),
                _Header(onBack: () {
                  playTap();
                  context.pop();
                }),
                const SizedBox(height: 6),
                const _OrnamentDivider(),
                const SizedBox(height: 10),
                _CategoryTabs(categories: _categories),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (final c in _categories) _CategoryContent(category: c),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.goldenStarLine, width: 46),
              const SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFDE08D), Color(0xFFFDC830), Color(0xFFFFD700)],
                ).createShader(bounds),
                child: const GoldenTitle(title: 'MINI AUCTION LITE', fontSize: 22),
              ),
              const SizedBox(width: 10),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(AppImages.goldenStarLine, width: 46),
              ),
            ],
          ),
          Positioned(
            right: 16,
            child: GestureDetector(
              onTap: onBack,
              child: Image.asset(AppImages.backMenuIcon, width: 46),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrnamentDivider extends StatelessWidget {
  const _OrnamentDivider();

  @override
  Widget build(BuildContext context) {
    Widget line({required bool leadTransparent}) => Expanded(
      child: Container(
        height: 1.2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: leadTransparent
                ? [Colors.transparent, AppTheme.borderGold.withOpacity(0.7)]
                : [AppTheme.borderGold.withOpacity(0.7), Colors.transparent],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          line(leadTransparent: true),
          const SizedBox(width: 8),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFFFDE08D), Color(0xFFFFD700)]),
              boxShadow: [BoxShadow(color: AppTheme.borderGold.withOpacity(0.6), blurRadius: 6, spreadRadius: 1)],
            ),
          ),
          const SizedBox(width: 8),
          line(leadTransparent: false),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tabs
// ---------------------------------------------------------------------------

class _CategoryTabs extends StatelessWidget {
  final List<_RuleCategory> categories;

  const _CategoryTabs({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: _Glass(
        borderRadius: 18,
        opacity: 0.15,
        borderOpacity: 0.25,
        padding: const EdgeInsets.all(4),
        tint: const Color(0xFF08142E),
        child: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          splashBorderRadius: BorderRadius.circular(16),
          indicator: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFDE08D), Color(0xFFFDC830)]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: AppTheme.borderGold.withOpacity(0.45), blurRadius: 12, spreadRadius: 0.5)],
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white70,
          labelPadding: const EdgeInsets.symmetric(horizontal: 3),
          labelStyle: GoogleFonts.rajdhani(fontSize: 12.5, fontWeight: FontWeight.bold, letterSpacing: 0.3),
          unselectedLabelStyle: GoogleFonts.rajdhani(fontSize: 12.5, fontWeight: FontWeight.w600),
          tabs: [
            for (final c in categories)
              Tab(
                height: 34,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(c.icon, size: 14),
                      const SizedBox(width: 6),
                      Text(c.label),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

class _CategoryContent extends StatelessWidget {
  final _RuleCategory category;

  const _CategoryContent({required this.category});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
      children: [
        for (int i = 0; i < category.sections.length; i++)
          _FadeIn(
            index: i,
            child: _RuleCard(
              section: category.sections[i],
              accent: category.accent,
              index: i, // Pass index for odd/even coloring
            ),
          ),
        if (category.label == 'GLOSSARY')
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 16),
            child: _RuleNote(
              text: 'All player names, character images, ratings, attributes, and other in-game content are entirely fictional and created solely for entertainment and gameplay purposes.',
              accent: category.accent,
            ),
          )
        else
          const SizedBox(height: 10),
      ],
    );
  }
}

class _FadeIn extends StatelessWidget {
  final int index;
  final Widget child;

  const _FadeIn({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final delay = (index * 50).clamp(0, 260);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 280 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, (1 - value) * 10), child: child),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Glass primitive — the one building block every panel is made from
// ---------------------------------------------------------------------------

class _Glass extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final double borderOpacity;
  final EdgeInsets padding;
  final Color? tint;

  const _Glass({
    required this.child,
    this.borderRadius = 14,
    this.opacity = 0.12,
    this.borderOpacity = 0.25,
    this.padding = EdgeInsets.zero,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final base = tint ?? const Color(0xFF08142E);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: (tint ?? const Color(0xFF08142E)).withOpacity(borderOpacity),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rule card
// ---------------------------------------------------------------------------

class _RuleCategory {
  final String label;
  final IconData icon;
  final Color accent;
  final List<_RuleSection> sections;

  const _RuleCategory({required this.label, required this.icon, required this.accent, required this.sections});
}

class _RuleTable {
  final List<String> headers;
  final List<List<String>> rows;
  final bool highlightLastColumn;

  const _RuleTable({required this.headers, required this.rows, this.highlightLastColumn = false});
}

class _StatTile {
  final String label;
  final String value;
  final bool highlight;

  const _StatTile(this.label, this.value, {this.highlight = false});
}

class _RuleSection {
  final String number;
  final String title;
  final IconData? icon;
  final List<String> paragraphs;
  final List<String> bullets;
  final List<_StatTile> statTiles;
  final _RuleTable? table;
  final String? footnote;
  final bool emphasizeFootnote;

  const _RuleSection({
    required this.number,
    required this.title,
    this.icon,
    this.paragraphs = const [],
    this.bullets = const [],
    this.statTiles = const [],
    this.table,
    this.footnote,
    this.emphasizeFootnote = false,
  });
}

class _RuleCard extends StatelessWidget {
  final _RuleSection section;
  final Color accent;
  final int index;

  const _RuleCard({
    required this.section,
    required this.accent,
    required this.index,
  });

  Color _getCardColor() {
    // Odd/Even pattern: even indices get Color(0xFF08142E), odd get Color(0xFF08142E)
    return  const Color(0xFF08142E);
  }

  @override
  Widget build(BuildContext context) {
    final hasBody = section.paragraphs.isNotEmpty ||
        section.bullets.isNotEmpty ||
        section.statTiles.isNotEmpty ||
        section.table != null ||
        section.footnote != null;

    final cardColor = _getCardColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _Glass(
        borderRadius: 16,
        opacity: 0.3, // Higher opacity for better visibility of the card color
        borderOpacity: 0.35,
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        tint: cardColor,
        child: Stack(
          children: [
             if (section.icon != null)
              Positioned(
                right: -6,
                top: -6,
                child: Icon(section.icon, size: 54, color: accent.withOpacity(0.12)),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [accent, accent.withOpacity(0.7)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        section.number,
                        style: GoogleFonts.rajdhani(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        section.title,
                        style: GoogleFonts.rajdhani(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (hasBody) ...[
                  const SizedBox(height: 9),
                  Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent.withOpacity(0.5), accent.withOpacity(0.1)],
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                ],
                for (final p in section.paragraphs)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      p,
                      style: GoogleFonts.rajdhani(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 12.5,
                        height: 1.45,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (section.statTiles.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: _StatRow(tiles: section.statTiles, accent: accent),
                  ),
                if (section.bullets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final b in section.bullets)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: accent,
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: accent.withOpacity(0.5),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Expanded(
                                  child: Text(
                                    b,
                                    style: GoogleFonts.rajdhani(
                                      color: Colors.white.withOpacity(0.92),
                                      fontSize: 12.5,
                                      height: 1.38,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                if (section.table != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 3),
                    child: _RuleTableView(table: section.table!, accent: accent),
                  ),
                if (section.footnote != null) ...[
                  const SizedBox(height: 3),
                  _Footnote(text: section.footnote!, emphasize: section.emphasizeFootnote, accent: accent),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final List<_StatTile> tiles;
  final Color accent;

  const _StatRow({required this.tiles, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < tiles.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _StatTileView(tile: tiles[i], accent: accent)),
        ],
      ],
    );
  }
}

class _StatTileView extends StatelessWidget {
  final _StatTile tile;
  final Color accent;

  const _StatTileView({required this.tile, required this.accent});

  @override
  Widget build(BuildContext context) {
    final color = tile.highlight ? accent : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: tile.highlight ? accent.withOpacity(0.6) : Colors.white.withOpacity(0.12),
          width: tile.highlight ? 1.5 : 1,
        ),
        boxShadow: tile.highlight
            ? [
          BoxShadow(
            color: accent.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ]
            : null,
      ),
      child: Column(
        children: [
          Text(
            tile.value,
            style: GoogleFonts.rajdhani(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              shadows: tile.highlight
                  ? [
                Shadow(
                  color: accent.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ]
                  : null,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            tile.label,
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              color: tile.highlight ? accent.withOpacity(0.8) : Colors.white60,
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleTableView extends StatelessWidget {
  final _RuleTable table;
  final Color accent;

  const _RuleTableView({required this.table, required this.accent});

  @override
  Widget build(BuildContext context) {
    final lastIndex = table.headers.length - 1;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        color: Colors.white.withOpacity(0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        border: TableBorder(horizontalInside: BorderSide(color: Colors.white.withOpacity(0.1))),
        columnWidths: table.headers.length == 2 ? const {0: FlexColumnWidth(1.4), 1: FlexColumnWidth(1)} : null,
        children: [
          TableRow(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent.withOpacity(0.25), accent.withOpacity(0.1)],
              ),
            ),
            children: [
              for (final h in table.headers)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  child: Text(
                    h.toUpperCase(),
                    style: GoogleFonts.rajdhani(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          for (int i = 0; i < table.rows.length; i++)
            TableRow(
              children: [
                for (int j = 0; j < table.rows[i].length; j++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    child: Text(
                      table.rows[i][j],
                      style: GoogleFonts.rajdhani(
                        color: table.highlightLastColumn && j == lastIndex
                            ? accent
                            : Colors.white.withOpacity(0.9),
                        fontSize: 11.5,
                        fontWeight: table.highlightLastColumn && j == lastIndex
                            ? FontWeight.w800
                            : FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Footnote extends StatelessWidget {
  final String text;
  final bool emphasize;
  final Color accent;

  const _Footnote({required this.text, required this.emphasize, required this.accent});

  @override
  Widget build(BuildContext context) {
    final color = emphasize ? const Color(0xFFFF6F6B) : Colors.white70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: emphasize ? const Color(0xFFFF6F6B).withOpacity(0.12) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: emphasize ? const Color(0xFFFF6F6B).withOpacity(0.4) : Colors.white.withOpacity(0.1),
          width: emphasize ? 1.2 : 1,
        ),
        boxShadow: emphasize
            ? [
          BoxShadow(
            color: const Color(0xFFFF6F6B).withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(emphasize ? Icons.warning_amber_rounded : Icons.info_outline, size: 13, color: color),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.rajdhani(
                color: color,
                fontSize: 11,
                fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
                fontStyle: FontStyle.italic,
                height: 1.3,
                shadows: emphasize
                    ? [
                  Shadow(
                    color: const Color(0xFFFF6F6B).withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ]
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleNote extends StatelessWidget {
  final String text;
  final Color accent;

  const _RuleNote({required this.text, required this.accent});

  @override
  Widget build(BuildContext context) {
    return _Glass(
      borderRadius: 12,
      opacity: 0.15,
      borderOpacity: 0.25,
      padding: const EdgeInsets.all(14),
      tint: const Color(0xFF08142E),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, size: 15, color: accent.withOpacity(0.8)),
          const SizedBox(height: 7),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              color: Colors.white70,
              fontSize: 10.5,
              fontStyle: FontStyle.italic,
              height: 1.4,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}