import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';

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
                Color(0xFF4A0000), // Outer darker red
              ],
              radius: 1.0,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(context),
                const Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AuctionCard(
                        title: "MINI AUCTION",
                        isLocked: false,
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
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Row(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyan, width: 1),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "RAGUNATH",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Pro Level Player",
                      style: TextStyle(
                        color: Colors.cyan[200],
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // XP Bar
                    Container(
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.red,
                    width: 140,
                    height: 50,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber, width: 1.5),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 40),
                                Text(
                                  "1,000",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                            width: 40,
                              'assets/images/png/turning_coin_icon.png'
                          ),
                        )
                      ],
                    ),
                  ),
                  _TopActionButton(
                      icon: 'assets/images/png/home_menu_icon.png',
                      onTap: (){

                      }
                  ),
                  _TopActionButton(
                      icon: 'assets/images/png/setting_menu_icon.png',
                      onTap: (){

                      }
                  ),
                  _TopActionButton(
                      icon: 'assets/images/png/more_menu_icon.png',
                      onTap: (){

                      }
                  ),
                  _TopActionButton(
                      icon: 'assets/images/png/sound_menu_icon.png',
                      onTap: (){

                      }
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  final void Function()? onTap;
  final String icon;
  const _TopActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Image.asset(
          width: 50,
          icon
      ),
    );
  }
}

class _AuctionCard extends StatelessWidget {
  final String title;
  final bool isLocked;
  
  const _AuctionCard({required this.title, required this.isLocked});

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
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/png/auction_card.png'), // Placeholder for wood texture
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
                  style: TextStyle(
                    color: isLocked ? const Color(0xFF4A0000) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset(
                  'assets/images/png/bidding_people.png',
                height: 100,
                width: 200,
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
    );
  }
}
