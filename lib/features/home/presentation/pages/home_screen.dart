import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/home/presentation/pages/rule_book_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/setting_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/shop_dialog.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/utils/app_images.dart';
import 'profile_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


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
              _buildTopBar(context),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _AuctionCard(
                      title: "MINI AUCTION",
                      isLocked: false,
                      onTap: (){
                        context.pushReplacement('/miniAuction');
                      },
                    ),
                    _AuctionCard(
                      title: "MEGA AUCTION",
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

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Stack(
        children: [
          // Profile Section
          Positioned(
            left: 0,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const ProfileDialog(),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.amber, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      "RAGUNATH K",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: IntrinsicWidth(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: const BoxDecoration(
                    color: Color(0xff2F0907),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
                ),
                child: Center(
                  child: Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            // color: Colors.red,
                            width: 120,
                            height: 35,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 30,
                                  bottom: 5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.amber, width: 1.5),
                                    ),
                                    child: const Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          "1,0000",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.add_circle, color: Colors.green, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  child: Image.asset(
                                      width: 45,
                                      height: 40,
                                      AppImages.coinsMenuIcon
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text('Coins', style: GoogleFonts.jockeyOne(textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),)
                        ],
                      ),
                      _TopActionButton(
                          icon: AppImages.shopMenuIcon,
                          title: 'Shop',
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (context) => const ShopDialog(),
                            );
                          }
                      ),
                      _TopActionButton(
                          icon: AppImages.freeCoinMenuIcon,
                          title: 'Free Coins',
                          onTap: (){

                          }
                      ),
                      _TopActionButton(
                          icon: AppImages.settingsMenuIcon,
                          title: 'Setting',
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (context) => const SettingDialog(),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: _TopActionButton(
                icon: AppImages.ruleBookMenuIcon,
                title: 'Rule Book',
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (context) => const RuleBookDialog(),
                  );
                }
            ),
          ),
        ],
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

class _AuctionCard extends StatelessWidget {
  final String title;
  final bool isLocked;
  void Function()? onTap;
  
  _AuctionCard({
    required this.title,
    required this.isLocked,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  top: 30,
                  child: Image.asset(
                    AppImages.auctionerBox,
                    height: 100,
                    width: 100,
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
      ),
    );
  }
}
