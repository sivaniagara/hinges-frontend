import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/home/presentation/pages/rule_book_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/setting_dialog.dart';
import 'package:hinges_frontend/features/home/presentation/pages/shop_dialog.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/enums/mini_auction_franchise_enum.dart';

import '../../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../../core/presentation/widgets/dialog_details.dart';
import '../../../../../core/utils/app_images.dart';


class MiniAuctionMode extends StatefulWidget {
  const MiniAuctionMode({super.key});

  @override
  State<MiniAuctionMode> createState() => _MiniAuctionModeState();
}

class _MiniAuctionModeState extends State<MiniAuctionMode> {


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
                    _MiniAuctionTableCard(
                      title: "MINI AUCTION LITE",
                      isLocked: false,
                      onTap: (){
                        context.push('/game');
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
                    _MiniAuctionTableCard(
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


class _MiniAuctionTableCard extends StatelessWidget {
  final String title;
  final bool isLocked;
  void Function()? onTap;
  void Function()? infoTap;

  _MiniAuctionTableCard({
    required this.title,
    required this.isLocked,
    this.onTap,
    this.infoTap,
  });

  List<MiniAuctionFranchiseEnum> franchiseList = [
    MiniAuctionFranchiseEnum.csk,
    MiniAuctionFranchiseEnum.mi,
    MiniAuctionFranchiseEnum.kkr,
    MiniAuctionFranchiseEnum.srh,
    MiniAuctionFranchiseEnum.rcb,
  ];

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
                      child: Column(
                        spacing: 2,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(franchiseList.length, (index){
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.5),
                                  color: Color(0xffFFEAB6)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 15,
                                      child: tableText('${index+1}')
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.18,
                                      child: tableText(franchiseList[index].fullName())
                                  ),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        image: AssetImage(franchiseList[index].image()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })

                        ],
                      ),
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

  Widget tableText(String value){
    return Text(
      value,
      maxLines: 2,
      style: GoogleFonts.oxanium(textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.black)),
    );
  }
}
