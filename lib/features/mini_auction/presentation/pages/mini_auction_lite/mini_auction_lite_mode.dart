import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/home/presentation/pages/rule_book_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/setting_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/shop_dialog.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/enums/mini_auction_franchise_enum.dart';

import '../../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../../core/presentation/widgets/dialog_details.dart';
import '../../../../../core/presentation/widgets/gradient_text.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../home/domain/entities/auction_category_item_entity.dart';
import '../../../../home/presentation/bloc/home_bloc.dart';


class MiniAuctionLiteMode extends StatefulWidget {
  const MiniAuctionLiteMode({super.key});

  @override
  State<MiniAuctionLiteMode> createState() => _MiniAuctionLiteModeState();
}

class _MiniAuctionLiteModeState extends State<MiniAuctionLiteMode> {


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
                    _MiniAuctionLiteModeCard(
                      title: "CLASSIC",
                      isLocked: false,
                        onTap: (){
                          context.pushReplacement('/game');
                        },
                        infoTap: (){
                          showDialog(
                            context: context,
                            builder: (context) => const DialogDetails(
                                points: [
                                  'ONLY THREE PRIZES WILL BE REWARDED',
                                  'ALL CRITERIAS TO BE FILLED PROPERLY FOR YOUR QUALIFICATION',
                                  'DISQUALIFIED USERS ARE NOT ELIGIBLE FOR PRIZE REWARDS'
                                ]
                            ),
                          );
                        }
                    ),
                    _MiniAuctionLiteModeCard(
                      title: "PREMIUM",
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


class _MiniAuctionLiteModeCard extends StatelessWidget {
  final String title;
  final bool isLocked;
  void Function()? onTap;
  void Function()? infoTap;

  _MiniAuctionLiteModeCard({
    required this.title,
    required this.isLocked,
    this.onTap,
    this.infoTap,
  });

  List<Color> gradientTextColor = [Color(0xFFFCFF6A), Color(0xFFF5A01E)];

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
                      : Center(
                    child: SizedBox(
                      width: screenWidth * 0.3,
                      child: BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state){
                            if(state is HomeLoaded){
                              AuctionCategoryItemEntity classic = state.userData.auctionCategoryItem[0];

                              return Column(
                                spacing: 2,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GradientText(title: 'ENTRY - ${classic.coinsGameFees}', colors: gradientTextColor, fontSize: 20),
                                  _buildPrizeRow(
                                    title: '1ST PRICE',
                                    image: 'first_price',
                                    count: classic.coinsFirstPrize.toString(),
                                  ),
                                  _buildPrizeRow(
                                    title: '2ND PRICE',
                                    image: 'second_price',
                                    count: classic.coinsSecondPrize.toString(),
                                  ),
                                  _buildPrizeRow(
                                    title: '3RD PRICE',
                                    image: 'third_price',
                                    count: classic.coinsThirdPrize.toString(),
                                  ),
                                ],
                              );
                            }
                            return Container();
                      }),
                    ),
                  ),
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
                  bottom: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AppImages.redTag)
                      )
                    ),
                    child: Text(
                      'PLAY',
                      style: GoogleFonts.oxanium(textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                    ),
                  ),
                ),
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

  Widget _buildPrizeRow(
      {required String title,required String image, required String count}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        spacing: 10,
        children: [
          Image.asset(
              width: 30,
              'assets/images/png/$image.png'
          ),
          GradientText(title: title, colors: gradientTextColor, fontSize: 16,),
          GradientText(title: count, colors: gradientTextColor, fontSize: 16,),
          Image.asset(
              width: 30,
              'assets/images/png/coins_menu_icon.png'
          ),
        ],
      ),
    );
  }

}
