import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/presentation/widgets/cancel_header.dart';

import '../../../../core/utils/app_images.dart';

class BuyCoinsDialog extends StatelessWidget {
  const BuyCoinsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      alignment: AlignmentGeometry.topLeft,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF800000), // Maroon Background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Header Row
            CancelHeader(),
            IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(AppImages.redTag))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    spacing: 10,
                    children: [
                      Image.asset(AppImages.shopMenuIcon, width: 25,),
                      Text('Shop', style: GoogleFonts.oxanium(textStyle: TextStyle(color: Colors.white,fontSize: 16)),)
                    ],
                  ),
                ),
              ),
            ),            // Main Content
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      _buildCoinSection(
                        context,
                        coins: '100',
                        price: '10'
                      ),

                    ],
                  ),
                  _buildCoinSection(
                      context,
                      coins: '500',
                    price: '50'
                  ),
                  _buildCoinSection(
                      context,
                      coins: '1000',
                    price: '100'
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinSection(BuildContext context, {required String coins, required String price,}) {
    return Stack(
      children: [
        Container(
          width: 160,
          height: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(AppImages.auctionCard),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.coinsMenuIcon,
                  width: 60,
                ),
                Text(coins, style: GoogleFonts.oxanium(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25))),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 30,
            child: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.yellowSharpEdgeTag),
                      fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.only()
              ),
              child: Center(
                child: Text(
                  '₹$price INR',
                  style: GoogleFonts.oxanium(
                    textStyle: TextStyle(
                      color: Color(0xff603913),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }
}
