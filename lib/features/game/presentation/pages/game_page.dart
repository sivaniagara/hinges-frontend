import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';


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

            ],
          ),
        ),
      ),
    );
  }
}