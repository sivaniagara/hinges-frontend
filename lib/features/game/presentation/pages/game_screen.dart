import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                firstColumn(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFBB1311), // Outer darker red
                        Color(0xFF670201)
                      ],
                      radius: 0.7,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
                firstColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget firstColumn(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
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
        Text('PLAYERS LIST', style: GoogleFonts.oxanium(textStyle: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),),
        Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            playerCategory(title: 'BATSMAN', image: AppImages.batsmanIcon),
            playerCategory(title: 'WICKET KEEPER', image: AppImages.wicketKeeperIcon),
            playerCategory(title: 'ALL ROUNDER', image: AppImages.allRounderIcon),
            playerCategory(title: 'BOWLER', image: AppImages.bowlerIcon),
          ],
        ),
        Column(
          spacing: 5,
          children: [
            redCard('MY SQUAD'),
            redCard('POINTS TABLE'),
          ],
        ),
        SizedBox(height: 1,)
      ],
    );
  }

  Widget redCard(String title){
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.redTag),
              fit: BoxFit.fill
          )
      ),
      child: Center(
        child: gradientText(title),
      ),
    );
  }

  Widget playerCategory(
  {
    required String title,
    required String image,
}
      ){
    return Row(
      spacing: 10,
      children: [
        Image.asset(
          width: 25,
            height: 25,
            image,
          fit: BoxFit.cover,
        ),
        gradientText(title)
      ],
    );
  }
  
  Widget gradientText(String title){
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,    // starts at top
          end: Alignment.bottomCenter,   // ends at bottom
          colors: [Colors.white, Color(0xffFF1D2B)],
        ).createShader(bounds);          // uses actual text size automatically!
      },
      blendMode: BlendMode.srcIn,        // important for text coloring
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,           // base color (white works well with srcIn)
        ),
      ),
    );
  }
}