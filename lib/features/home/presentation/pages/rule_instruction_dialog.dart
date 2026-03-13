import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/presentation/widgets/cancel_header.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';

class RuleInstructionDialog extends StatelessWidget {
  final String title;
  final String description;

  const RuleInstructionDialog({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Categorizing rules based on the content provided
    final sections = [
      _RuleSection(
        title: 'GENERAL ALLOCATION',
        icon: Icons.group_work_rounded,
        rules: [
          'Users will be allocated with a random franchise while entering the auction room.',
          'The cumulative purse spent & ratings of pre-picked players will be same for all users.',
        ],
      ),
      _RuleSection(
        title: 'PURSE & BIDDING',
        icon: Icons.account_balance_wallet_rounded,
        rules: [
          'Each user will be allocated with a purse of 25 Crores for the entire auction.',
          'Each bid or padel raised will be considered as 0.25 Crores.',
          "The auctioneer's decision is final.",
          'Users cannot bid beyond their remaining purse amount.',
        ],
      ),
      _RuleSection(
        title: 'SQUAD BUILDING (5 EMPTY SLOTS)',
        icon: Icons.groups_rounded,
        rules: [
          '1 Batsman, 1 Wicket-Keeper, 2 All-Rounders, 1 Bowler.',
          'Player Types: 2 Indian Capped (ICP), 2 Foreign (FP), 1 Indian Uncapped (IUP).',
          'Bowler Criteria: 1 Right Arm Spin and 1 Left Arm Fast (among the 2 AR & 1 BWL).',
          'Users cannot bid for players when respective slots are already filled.',
        ],
      ),
      _RuleSection(
        title: 'ROUNDS & STRATEGY',
        icon: Icons.layers_rounded,
        rules: [
          'Total 4 Rounds: Batsmen Set, Wicket-Keepers Set, All-Rounders Set, Bowlers Set.',
          'Upcoming players can be seen in the "PLAYERS SET" to plan strategies.',
          'Franchise squads can be seen by clicking their logo in the auction room.',
        ],
      ),
      _RuleSection(
        title: 'QUALIFICATION & WINNING',
        icon: Icons.emoji_events_rounded,
        rules: [
          'Users must satisfy ALL criteria to qualify for rankings.',
          'Winners declared by highest rating order from qualified users.',
          'Tie-breaker: Remaining purse amount will be compared.',
        ],
      ),
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF800000), Color(0xFF4A0000)],
            radius: 1.0,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CancelHeader(),
            // Header Tag
            IntrinsicWidth(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(AppImages.redTag),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(AppImages.ruleBookIcon, width: 22),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: GoogleFonts.oxanium(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Rules List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  return _buildSectionCard(sections[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(_RuleSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(section.icon, color: Colors.amber, size: 18),
                const SizedBox(width: 10),
                Text(
                  section.title,
                  style: GoogleFonts.oxanium(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: section.rules.map((rule) => _buildRuleItem(rule)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, color: Colors.white70, size: 6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              rule,
              style: GoogleFonts.instrumentSans(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleSection {
  final String title;
  final IconData icon;
  final List<String> rules;

  _RuleSection({
    required this.title,
    required this.icon,
    required this.rules,
  });
}
