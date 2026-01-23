import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';

import 'buy_coins_dialog.dart';

class ShopDialog extends StatelessWidget {
  const ShopDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
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
                            Image.asset(AppImages.shopMenuIcon, width: 25,),
                            Text('Shop', style: GoogleFonts.oxanium(textStyle: TextStyle(color: Colors.white,fontSize: 16)),)
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
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _rowTag(
                      'BUY COINS',
                      'coins_menu_icon',
                      'yellow_tag',
                      (){
                        showDialog(
                            context: context,
                            builder: (context) => const BuyCoinsDialog()
                        );
                      }
                  ),
                  _rowTag(
                      'ADS FREE',
                      'ads_free',
                      'green_tag',
                      (){

                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowTag(String title, String image, String tagImage, void Function()? onTap){
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Image.asset(
              width: 50,
              'assets/images/png/$image.png'
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                    AssetImage('assets/images/png/$tagImage.png'),
                    fit: BoxFit.fill
                )
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: GoogleFonts.oxanium(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.8
                        ..color = Colors.black, // border color
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
