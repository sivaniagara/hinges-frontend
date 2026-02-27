import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/presentation/widgets/gradient_text.dart';
import 'package:hinges_frontend/features/game/domain/entities/user_status_entity.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';

import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Stack(
            children: [
              Column(
                children: [
                  // Header
                  Center(
                    child: Container(
                      width: 220,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImages.redTag),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Center(
                        child: GradientText(
                          title: 'RESULT',
                          colors: [Colors.white, const Color(0xffFF1D2B)],
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Table Header
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4D2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.brown, width: 1),
                    ),
                    child: Row(
                      children: [
                        _buildHeaderCell('USER NAME', flex: 2),
                        _buildHeaderCell('FRANCHISE NAME', flex: 4),
                        _buildHeaderCell('ELIGIBILITY', flex: 3),
                        _buildHeaderCell('FINAL RATING', flex: 2),
                        _buildHeaderCell('PRIZE', flex: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<GameBloc, GameState>(
                      builder: (context, state){
                        if(state is GameLoaded){
                          return Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              children: List.generate(
                                  state.gameData.usersStatusList.length,
                                  (index){
                                    final user = state.gameData.usersStatusList[index];
                                    MiniAuctionFranchiseEnum miniAuctionFranchiseEnum = getFranchiseEnum(user.teamId);
                                    return _buildResultRow(
                                        user.userName,
                                        miniAuctionFranchiseEnum.fullName(),
                                        miniAuctionFranchiseEnum.image(),
                                        user.matchWinStatusEnum == MatchWinStatusEnum.qualified,
                                        context.read<GameBloc>().getRating(user.userId).toString(),
                                        (user.rank <= 3  && user.matchWinStatusEnum == MatchWinStatusEnum.qualified) ? getMedalImage(user.rank) : null,
                                        getPrizeAmount(context, user.rank)
                                    );

                                  }
                              ),
                            ),
                          );
                        }
                        return Container();
                      }
                  ),
                ],
              ),
              // Home Button
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    context.go('/home');
                  },
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Image.asset(AppImages.homeIcon, width: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getPrizeAmount(BuildContext context, int rank){
    if(rank == 1){
      return '300';
    }else if(rank == 2){
      return '200';
    }else if(rank == 3){
      return '100';
    }else{
      return '';
    }
  }

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.oxanium(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildResultRow(String userName, String franchiseName, String logo, bool isQualified, String rating, String? medalImage, String prize) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.brown, width: 1),
      ),
      child: Row(
        children: [
          // USER NAME
          Expanded(
            flex: 2,
            child: Text(
              userName,
              style: GoogleFonts.oxanium(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // FRANCHISE NAME
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    franchiseName,
                    style: GoogleFonts.oxanium(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(logo, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ELIGIBILITY
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isQualified ? 'QUALIFIED' : 'DISQUALIFIED',
                  style: GoogleFonts.oxanium(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isQualified ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  isQualified ? Icons.check_circle : Icons.cancel,
                  color: isQualified ? Colors.green : Colors.red,
                  size: 20,
                ),
              ],
            ),
          ),
          // FINAL RATING
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                rating,
                style: GoogleFonts.oxanium(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // PRIZE
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if(medalImage != null)
                  Image.asset(
                      medalImage,
                    width: 25,
                    height: 25,
                  ),
                isQualified 
                  ? GradientText(
                      title: prize,
                      colors: [const Color(0xFF330000), const Color(0xFFB8860B)], // Golden-ish gradient
                      fontSize: 16,
                    )
                  : const Icon(Icons.cancel, color: Colors.red, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String getMedalImage(int rank){
    if(rank == 1){
      return AppImages.medal1;
    }else if(rank == 2){
      return AppImages.medal2;
    }else if(rank == 3){
      return AppImages.medal3;
    }else{
      return '';
    }
  }

  MiniAuctionFranchiseEnum getFranchiseEnum(String teamId){
    if(teamId == MiniAuctionFranchiseEnum.csk.teamId()){
      return MiniAuctionFranchiseEnum.csk;
    }else if(teamId == MiniAuctionFranchiseEnum.mi.teamId()){
      return MiniAuctionFranchiseEnum.mi;
    }else if(teamId == MiniAuctionFranchiseEnum.rcb.teamId()){
      return MiniAuctionFranchiseEnum.rcb;
    }else if(teamId == MiniAuctionFranchiseEnum.kkr.teamId()){
      return MiniAuctionFranchiseEnum.kkr;
    }else{
      return MiniAuctionFranchiseEnum.srh;
    }
  }
}
