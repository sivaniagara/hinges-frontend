import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/theme/app_theme.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/features/login/presentation/widgets/mandala_background.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/audio_manager.dart';
import '../../../../core/utils/so_loud.dart';

class RuleSummaryScreen extends StatelessWidget {
  const RuleSummaryScreen({super.key});

  static const List<Map<String, String>> _rules = [
    {'rule': 'Auction Mode:', 'details': 'Multiplayer Cricket Auction'},
    {'rule': 'Players per Room:', 'details': '5 Users'},
    {'rule': 'Available Franchises:', 'details': '10'},
    {'rule': 'Franchises per Room:', 'details': '5 Randomly Assigned'},
    {'rule': 'Total Squad Size:', 'details': '12 Players'},
    {'rule': 'Pre-filled Squad:', 'details': '7 Players (Green Slots)'},
    {'rule': 'Slots to be Filled:', 'details': '5 Players (Red Slots)'},
    {'rule': 'Initial Squad Rating:', 'details': '59.5'},
    {'rule': 'Total Purse:', 'details': '₹60.00 Cr'},
    {'rule': 'Purse Already Spent:', 'details': '₹35.00 Cr'},
    {'rule': 'Remaining Purse:', 'details': '₹25.00 Cr'},
    {'rule': 'Total Auction Rounds:', 'details': '5'},
    {'rule': 'Rounds 1–4:', 'details': 'Randomized Role-based Player Sets'},
    {'rule': 'Round 5:', 'details': 'Accelerated Set'},
    {'rule': 'Bid Increment:', 'details': '₹0.25 Cr (₹25 Lakhs)'},
    {'rule': 'Round Break:', 'details': 'After Every Round (30 Seconds)'},
    {'rule': 'Qualification:', 'details': 'Complete all remaining squad requirements'},
    {'rule': 'Prize Eligibility:', 'details': 'Qualified Users Only'},
    {'rule': 'Winner:', 'details': 'Highest Rating Order'},
    {'rule': 'Tie Scenario 1:', 'details': 'Remaining Purse Comparison'},
    {'rule': 'Tie Scenario 2:', 'details': 'Highest Rating of ICP Comparison'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MandalaBackground(
        showParticle: false,
        animateContent: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // --- Header ---
              Row(
                children: [
                  Container(
                    width: 250,
                    height: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.titleGoldenFrame),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'RULE SUMMARY',
                        style: GoogleFonts.oxanium(
                          color: const Color(0xFFD4AF37),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      playTap();
                      context.pop();
                    },
                    child: Image.asset(AppImages.backMenuIcon, width: 45),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // --- Rules Table ---
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTableHeader(),
                      Expanded(
                        child: RawScrollbar(
                          thumbColor: const Color(0xFFD4AF37),
                          radius: const Radius.circular(8),
                          thickness: 6,
                          thumbVisibility: true,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: _rules.length,
                            itemBuilder: (context, index) {
                              return _buildRuleRow(
                                rule: _rules[index]['rule']!,
                                details: _rules[index]['details']!,
                                isOdd: index.isOdd,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'MINI AUCTION LITE - OFFICIAL RULE BOOK',
                style: GoogleFonts.rajdhani(
                  color: AppTheme.borderGold.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white10,
        border: Border(bottom: BorderSide(color: Color(0xFFD4AF37), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'RULE',
              style: GoogleFonts.oxanium(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'DETAILS',
              style: GoogleFonts.oxanium(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow({
    required String rule,
    required String details,
    required bool isOdd,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: isOdd ? Colors.white.withOpacity(0.02) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFD4AF37).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              rule,
              style: GoogleFonts.rajdhani(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
                height: 1.15,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              details,
              style: GoogleFonts.rajdhani(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFFD700).withOpacity(0.8),
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}