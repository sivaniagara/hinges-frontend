import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color(0xFF800000), // Maroon Background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Stack(
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // User Label
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                          // Close Button
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Image.asset(
                                width: 25,
                                'assets/images/png/cancel_icon.png'
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD32F2F),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
                          ),
                          child: const Text(
                            "PROFILE",
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Main Content
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left Section: Stats & Coins
                      _buildInfoSection(
                        context,
                        child: Column(
                          children: [
                            const Text(
                              "AUCTION PLAYED - 20",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const Divider(color: Colors.black, thickness: 2),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("QUALIFIED - 11", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                VerticalDivider(color: Colors.black, thickness: 2),
                                Text("DISQUALIFIED - 9", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            const Divider(color: Colors.black, thickness: 2),
                            const Text(
                              "COINS AVAILABLE",
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "3500",
                                  style: TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Image.asset('assets/images/png/coins_menu_icon.png', height: 30),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      // Right Section: Achievements
                      _buildInfoSection(
                        context,
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "ACHIEVEMENTS",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildPrizeRow(
                                title: '1ST PRICE',
                                image: 'first_price',
                                count: '',
                            ),
                            _buildPrizeRow(
                              title: '2ND PRICE',
                              image: 'second_price',
                              count: '',
                            ),
                            _buildPrizeRow(
                              title: '3RD PRICE',
                              image: 'third_price',
                              count: '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "LOGGED IN WITH WITH FACEBOOK",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.logout, color: Colors.white, size: 16),
                        label: const Text(
                          "LOG OUT",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, {required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/png/auction_card.png'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          // color: const Color(0xFF4A0000).withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }

  Widget _buildPrizeRow(
      {required String title,required String image, required String count}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Image.asset(
              width: 30,
              'assets/images/png/$image.png'
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Text(
            count,
            style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
