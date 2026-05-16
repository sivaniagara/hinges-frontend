import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/enums/mini_auction_franchise_enum.dart';

import '../../domain/entities/auction_player_status_entity.dart';
import '../../domain/entities/user_status_entity.dart';

class PointsTableScreen extends StatelessWidget {
  const PointsTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF001F4D), // Dark blue center glow
              Color(0xFF000511), // Deep black edges
            ],
            radius: 1.2,
            center: Alignment.center,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state is! GameLoaded) return const SizedBox.shrink();

              final pointsTableList = getPointsTableList(state.gameData.usersStatusList, context);

              return Column(
                children: [
                  // --- Header Row ---
                  Row(
                    children: [
                      Container(
                        width: 220,
                        height: 50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.titleGoldenFrame),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'POINTS TABLE',
                            style: GoogleFonts.oxanium(
                              color: const Color(0xFFD4AF37),
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(AppImages.backMenuIcon, width: 45),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // --- Table Section ---
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          _buildTableHeader(),
                          Expanded(
                            child: RawScrollbar(
                              thumbColor: const Color(0xFFD4AF37),
                              radius: const Radius.circular(8),
                              thickness: 6,
                              thumbVisibility: true,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: pointsTableList.length,
                                itemBuilder: (context, index) {
                                  final user = pointsTableList[index];
                                  final franchise = getFranchiseEnum(user.teamId);
                                  final rating = getRating(context, user.userId);

                                  return _buildTeamRow(
                                    rank: index + 1,
                                    userName: user.userName.toUpperCase(),
                                    franchiseName: franchise.shortName(),
                                    franchiseLogo: franchise.image(),
                                    remainingPurse: context.read<GameBloc>().formatPriceShort(user.balanceAmount),
                                    totalRating: rating.toStringAsFixed(1),
                                    isOdd: index.isOdd,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white10,
        border: Border(bottom: BorderSide(color: Color(0xFFD4AF37), width: 1)),
      ),
      child: Row(
        children: [
          _buildCell('RANK', flex: 2, isHeader: true),
          _buildCell('USERNAME', flex: 4, isHeader: true),
          _buildCell('FRANCHISE', flex: 4, isHeader: true),
          _buildCell('REMAINING PURSE', flex: 4, isHeader: true),
          _buildCell('TOTAL RATING', flex: 3, isHeader: true),
        ],
      ),
    );
  }

  Widget _buildTeamRow({
    required int rank,
    required String userName,
    required String franchiseName,
    required String franchiseLogo,
    required String remainingPurse,
    required String totalRating,
    required bool isOdd,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isOdd ? Colors.white.withOpacity(0.02) : Colors.transparent,
        border: Border(bottom: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.1), width: 1)),
      ),
      child: Row(
        children: [
          // RANK with shield effect
          Expanded(
            flex: 2,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(AppImages.rankTag, width: 50, height: 30,),
                  Text(
                    '$rank',
                    style: GoogleFonts.oxanium(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37)),
                  ),
                ],
              ),
            ),
          ),
          // USERNAME
          _buildCell(userName, flex: 4, isBold: true),
          // FRANCHISE (Logo + Short Name)
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(franchiseLogo, height: 35),
                const SizedBox(width: 8),
                Text(
                  franchiseName,
                  style: GoogleFonts.oxanium(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          // REMAINING PURSE
          _buildCell(remainingPurse, flex: 4, color: const Color(0xFF00FF00), isBold: true),
          // TOTAL RATING
          _buildCell(totalRating, flex: 3, color: const Color(0xFFFFD700), isBold: true),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required int flex, bool isHeader = false, bool isBold = false, Color color = Colors.white, double fontSize = 14, TextAlign textAlign = TextAlign.center}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: textAlign,
        style: GoogleFonts.oxanium(
          fontSize: isHeader ? 12 : fontSize,
          fontWeight: isHeader || isBold ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? const Color(0xFFD4AF37) : color,
        ),
      ),
    );
  }

  // --- Logic Helper Methods (Preserved) ---

  double getRating(BuildContext context, String userId){
    double totalRating = 0.0;
    Map<int, AuctionPlayerStatusEntity?> squad = context.read<GameBloc>().getMySquad(userId);
    for(var player in squad.values){
      if(player != null && (player.playerAuctionStatus == PlayerAuctionStatusEnum.sold || player.playerAuctionStatus == PlayerAuctionStatusEnum.buy)){
        totalRating += player.baseRating;
      }
    }
    return totalRating;
  }

  MiniAuctionFranchiseEnum getFranchiseEnum(String teamId){
    if(teamId == MiniAuctionFranchiseEnum.csk.teamId()) return MiniAuctionFranchiseEnum.csk;
    if(teamId == MiniAuctionFranchiseEnum.mi.teamId()) return MiniAuctionFranchiseEnum.mi;
    if(teamId == MiniAuctionFranchiseEnum.rcb.teamId()) return MiniAuctionFranchiseEnum.rcb;
    if(teamId == MiniAuctionFranchiseEnum.kkr.teamId()) return MiniAuctionFranchiseEnum.kkr;
    if(teamId == MiniAuctionFranchiseEnum.srh.teamId()) return MiniAuctionFranchiseEnum.srh;
    // if(teamId == MiniAuctionFranchiseEnum.gt.teamId()) return MiniAuctionFranchiseEnum.gt;
    // if(teamId == MiniAuctionFranchiseEnum.lsg.teamId()) return MiniAuctionFranchiseEnum.lsg;
    // if(teamId == MiniAuctionFranchiseEnum.dc.teamId()) return MiniAuctionFranchiseEnum.dc;
    // if(teamId == MiniAuctionFranchiseEnum.pk.teamId()) return MiniAuctionFranchiseEnum.pk;
    // if(teamId == MiniAuctionFranchiseEnum.rr.teamId()) return MiniAuctionFranchiseEnum.rr;
    return MiniAuctionFranchiseEnum.empty;
  }

  List<UserStatusEntity> getPointsTableList(List<UserStatusEntity> listOfUser, BuildContext context){
    Map<String, double> usersSquad = {};
    for(var user in listOfUser){
      usersSquad[user.userId] = getRating(context, user.userId);
    }
    var sortedEntries = usersSquad.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // descending
    return sortedEntries.map((e) {
      return listOfUser.firstWhere((user) => user.userId == e.key);
    }).toList();
  }
}
