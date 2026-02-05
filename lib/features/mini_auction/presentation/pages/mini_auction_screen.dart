import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/home/presentation/pages/rule_book_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/setting_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/shop_dialog.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/presentation/widgets/dialog_details.dart';
import '../../../../core/utils/app_images.dart';


class MiniAuctionScreen extends StatefulWidget {
  const MiniAuctionScreen({super.key});

  @override
  State<MiniAuctionScreen> createState() => _MiniAuctionScreenState();
}

class _MiniAuctionScreenState extends State<MiniAuctionScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF800000), // Center deep red
                Color(0xFFA7100E), // Outer darker red
              ],
              radius: 1.0,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        context.pop();
                      },
                      child: Image.asset(
                          width: 60,
                          AppImages.homeIcon
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _MiniAuctionCard(
                      title: "MINI AUCTION LITE",
                      isLocked: false,
                      onTap: (){
                        context.push('/miniAuctionLiteMode');
                      },
                      infoTap: (){
                        showDialog(
                          context: context,
                          builder: (context) => const DialogDetails(
                              points: [
                                'ONLY 5 SLOTS TO BE FILLED WITH YOUR REMAINING PURSE',
                                'PRIZE DISTRIBUTION IS BASED ON THE HIGHEST RATING ORDER',
                                'FOR FURTHER INFORMATION PLEASE READ THE RULE BOOK'
                              ]
                          ),
                        );
                      }
                    ),
                    _MiniAuctionCard(
                      title: "MEGA AUCTION PRO",
                      isLocked: true,
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


class _MiniAuctionCard extends StatelessWidget {
  final String title;
  final bool isLocked;
  void Function()? onTap;
  void Function()? infoTap;

  _MiniAuctionCard({
    required this.title,
    required this.isLocked,
    this.onTap,
    this.infoTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: screenWidth * 0.4,
                height: screenHeight * 0.6,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(AppImages.auctionCard), // Placeholder for wood texture
                    fit: BoxFit.fitWidth,
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
                ...[
                  Positioned(
                    left: 50,
                    top: 60,
                    child: getFranchiseLogo(AppImages.csk),
                  ),
                  Positioned(
                    right: 50,
                    top: 60,
                    child: getFranchiseLogo(AppImages.mi),
                  ),
                  Positioned(
                    right: 50,
                    bottom: 40,
                    child: getFranchiseLogo(AppImages.rcb),
                  ),
                  Positioned(
                    left: 50,
                    bottom: 40,
                    child: getFranchiseLogo(AppImages.kkr),
                  ),
                  Positioned(
                    left: 115,
                    bottom: screenHeight * 0.25,
                    child: getFranchiseLogo(AppImages.srh),
                  ),
                ]
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Info Button
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: infoTap,
            child: Container(
              margin: const EdgeInsets.only(left: 240),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline, color: Colors.white, size: 20),
            ),
          ),
        )
      ],
    );
  }
  Widget getFranchiseLogo(String image){
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(image)
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
