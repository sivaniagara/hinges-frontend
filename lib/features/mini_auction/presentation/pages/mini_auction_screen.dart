import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/home/presentation/pages/rule_book_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/setting_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/shop_dialog.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
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
                        context.pushReplacement('/home');
                      },
                      child: Image.asset(
                          width: 60,
                          AppImages.homeIcon
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _MiniAuctionCard(
                      title: "MINI AUCTION LITE",
                      isLocked: false,
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

class _TopActionButton extends StatelessWidget {
  final void Function()? onTap;
  final String icon;
  final String title;
  const _TopActionButton({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
              width: 35,
              icon
          ),
          Text(title, style: GoogleFonts.jockeyOne(textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),))

        ],
      ),
    );
  }
}

class _MiniAuctionCard extends StatelessWidget {
  final String title;
  final bool isLocked;

  const _MiniAuctionCard({required this.title, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            // Wood Frame Background
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: 280,
              height: 180,
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
                  top: 50,
                  child: Image.asset(
                    AppImages.csk,
                    width: 50,
                    height: 50,
                  ),
                ),
                Positioned(
                  right: 50,
                  top: 50,
                  child: Image.asset(
                    AppImages.mi,
                    width: 50,
                    height: 50,
                  ),
                ),
                Positioned(
                  right: 50,
                  bottom: 35,
                  child: Image.asset(
                    AppImages.rcb,
                    width: 50,
                    height: 50,
                  ),
                ),
                Positioned(
                  left: 50,
                  bottom: 35,
                  child: Image.asset(
                    AppImages.kkr,
                    width: 50,
                    height: 50,
                  ),
                ),
                Positioned(
                  left: 115,
                  bottom: 70,
                  child: Image.asset(
                    AppImages.srh,
                    width: 50,
                    height: 50,
                  ),
                ),
              ]

          ],
        ),
        const SizedBox(height: 8),
        // Info Button
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(left: 240),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFD32F2F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.info_outline, color: Colors.white, size: 20),
          ),
        )
      ],
    );
  }
}
