import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/features/home/presentation/pages/rule_instruction_dialog.dart';

import 'buy_coins_dialog.dart';

class RuleBookDialog extends StatelessWidget {
  const RuleBookDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color(0xFF800000), // Maroon Background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(AppImages.redTag))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            Image.asset(AppImages.ruleBookIcon, width: 25,),
                            Text('Rule Book', style: GoogleFonts.oxanium(textStyle: TextStyle(color: Colors.white,fontSize: 16)),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Close Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset(
                        width: 25,
                        AppImages.cancelIcon
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AuctionCardForRuleBook(
                    title: "MINI AUCTION",
                    isLocked: false,
                  ),
                  _AuctionCardForRuleBook(
                    title: "MEGA AUCTION",
                    isLocked: true,
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

class _AuctionCardForRuleBook extends StatelessWidget {
  final String title;
  final bool isLocked;

  const _AuctionCardForRuleBook({required this.title, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isLocked ? (){
        showDialog(
          context: context,
          builder: (context) => const RuleInstructionDialog(
              title: 'MINI AUCTION RULES',
              description: 'Mini Auction Mode Is the Fastest Mode of Indian Bidding League (IBL). In This League Only Four Users Can Be Played as Franchise Owners Such As TKS, MI, RCK, BGR.  There are 4 Round of Auctions Will Be Conducted in This Game Which Includes Batsmen, Wicket Keepers, All Rounders, Bowlers. Each Category Will Be Arranged as Three Sets Such as Indian Capped Players, Foreign Players & Indian Uncapped Players. The Player List to Be Auctioned in The Entire Game Will Be Available in The Game Panel and It Contains All the Details, Specification and Description of The Players.'
          ),
        );
      } : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // Wood Frame Background
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 250,
                height: 150,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(AppImages.auctionCard), // Placeholder for wood texture
                    fit: BoxFit.fitHeight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  // border: Border.all(color: const Color(0xFF5D3A1A), width: 8),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  // decoration: BoxDecoration(
                  //   gradient: const RadialGradient(
                  //     colors: [Color(0xFF800000), Color(0xFF4A0000)],
                  //   ),
                  //   borderRadius: BorderRadius.circular(30),
                  // ),
                  child: isLocked

                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock, color: Color(0xFFFFD700), size: 50),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          color: const Color(0xFFFFD700),
                          child: const Text(
                            "LOCKED",
                            style: TextStyle(color: Color(0xFF4A0000), fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
                      : null,
                ),
              ),
              // Header Tag
              if(!isLocked)
                Positioned(
                  top: 65,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red
                    ),
                    child: Center(
                      child: Text('Read', style:
                      GoogleFonts.oxanium(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white// border color
                        ),
                      )),
                    ),
                  )
                ),
              Positioned(
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isLocked ? const Color(0xFFFFD700) : const Color(0xFFD32F2F),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.oxanium(textStyle: TextStyle(
                      color: isLocked ? const Color(0xFF4A0000) : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    )),
                  ),
                ),
              ),
              if(!isLocked)
                Positioned(
                  bottom: -10,
                  child: Image.asset(
                    AppImages.biddingPeople,
                    height: 100,
                    width: 140,
                  ),
                )

            ],
          ),
        ],
      ),
    );
  }
}

