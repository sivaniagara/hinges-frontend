import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_ids.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/presentation/widgets/gradient_text.dart';

import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../../domain/entities/user_status_entity.dart';
import '../bloc/game_bloc.dart';

class PointsTableScreen extends StatelessWidget {
  const PointsTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> textColorForYellowTag = [const Color(0xff330000), const Color(0xffFF1D2B)];

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
                          title: 'POINTS TABLE',
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
                        _buildHeaderCell('SL.NO', flex: 1),
                        _buildHeaderCell('FRANCHISE NAME', flex: 6),
                        _buildHeaderCell('RATING', flex: 3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Table Content
                  BlocBuilder<GameBloc,GameState>(builder: (context, state){
                    if(state is GameLoaded){
                      List<UserStatusEntity> listOfUser = getPointsTableList(state.gameData.usersStatusList, context);
                      return Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          children: List.generate(listOfUser.length, (index){
                            MiniAuctionFranchiseEnum miniAuctionFranchiseEnum = getFranchiseEnum(listOfUser[index].teamId);
                            return _buildTeamRow(
                              '${index+1}',
                              miniAuctionFranchiseEnum.fullName(), 
                              miniAuctionFranchiseEnum.image(),
                                getRating(context, listOfUser[index].userId)
                            );
                          }),
                        ),
                      );
                    }
                    return Container();
                  }),

                ],
              ),
              // Close Button
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(AppImages.cancelIcon, width: 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getRating(BuildContext context, String userId){
    double totalRating = 0.0;
    Map<int, AuctionPlayerStatusEntity?> squad = context.read<GameBloc>().getMySquad(userId);
    for(var player in squad.values){
      if(player != null){
        totalRating += player.baseRating;
      }
    }
    return totalRating;
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

  List<UserStatusEntity> getPointsTableList(List<UserStatusEntity> listOfUser, BuildContext context){
    Map<String, double> usersSquad = {};
    for(var user in listOfUser){
      usersSquad[user.userId] = 0;
      Map<int, AuctionPlayerStatusEntity?> squad = context.read<GameBloc>().getMySquad(user.userId);
      for(var player in squad.values){
        if(player != null){
          usersSquad[user.userId] = usersSquad[user.userId]! + player.baseRating;
        }
      }
    }
    var sortedEntries = usersSquad.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // descending
    return sortedEntries.map((e) {
      return listOfUser.firstWhere((user) => user.userId == e.key);
    }).toList();
  }

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: flex == 1 ? TextAlign.start : (flex == 6 ? TextAlign.center : TextAlign.end),
        style: GoogleFonts.oxanium(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTeamRow(String slNo, String name, String logo, double rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.brown, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            slNo,
            style: GoogleFonts.oxanium(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 1.5),
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset(logo, fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: GoogleFonts.oxanium(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            '$rating',
            style: GoogleFonts.oxanium(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
