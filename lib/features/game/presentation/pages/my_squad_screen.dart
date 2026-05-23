import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_ids.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/utils/constant.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../home/domain/entities/category_and_items_entity.dart';
import '../../../home/domain/entities/player_entity.dart';
import '../../../mini_auction/presentation/enums/mini_auction_franchise_enum.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../../domain/entities/user_status_entity.dart';

class MySquadScreen extends StatelessWidget {
  final String userId;
  const MySquadScreen({super.key, required this.userId});

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
              AppTheme.navyBlue,
              Color(0xFF000511), // Deep black edges
            ],
            radius: 1.2,
            center: Alignment.center,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state is! GameLoaded) return const SizedBox.shrink();

              final userState = context.read<HomeBloc>().state as HomeLoaded;
              final mySquad = context.read<GameBloc>().getMySquad(userId);
              final userStatus = state.gameData.usersStatusList.firstWhere((e) => e.userId == userId);
              final franchise = context.read<GameBloc>().getFranchise(state.gameData.usersStatusList, state.gameData.teamList, userId);

              return Column(
                children: [
                  // --- Header Row ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // MY SQUAD Title Frame
                      Container(
                        width: 120,
                        height: 50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.titleGoldenFrame),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'MY SQUAD',
                            style: GoogleFonts.cinzel(
                              color: const Color(0xFFD4AF37),
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                      // Team Logo
                      Column(
                        children: [
                          Image.asset(franchise.image(), height: 40),
                          Text(
                            franchise.shortName().toUpperCase(),
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ), // Team Name

                      // Stats Section
                      _buildHeaderStat('TOTAL PURSE', '60 CR', AppImages.purse),
                      const SizedBox(width: 10),
                      _buildHeaderStat(
                        'PURSE REM',
                        context.read<GameBloc>().formatPriceShort(userStatus.balanceAmount), 
                        AppImages.purseRem,
                        valueColor: const Color(0xFF00FF00)
                      ),
                      const SizedBox(width: 10),
                      _buildHeaderStat(
                        'TOTAL RATING', 
                        getSquadRating(mySquad).toStringAsFixed(1), 
                        AppImages.rating,
                        valueColor: const Color(0xFFFFD700)
                      ),
                      const SizedBox(width: 15),
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
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.borderGold, width: 0.5),
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
                                itemCount: 12,
                                itemBuilder: (context, index) {
                                  final key = index + 1;
                                  final player = mySquad[key];
                                  final role = context.read<GameBloc>().getRole(key);
                                  
                                  // Slot labeling to match image: BAT 1, BAT 2, BAT 3, WK 1, WK 2, ALR 1-4, BOWL 1-3
                                  int subIndex = 0;
                                  if (key <= 3) subIndex = key;
                                  else if (key <= 5) subIndex = key - 3;
                                  else if (key <= 9) subIndex = key - 5;
                                  else subIndex = key - 9;
                                  
                                  final slotLabel = "$role";

                                  if (player != null) {
                                    return _buildTableRow(
                                      slot: slotLabel,
                                      name: player.playerName.toUpperCase(),
                                      description: getRoleStyle(key, player, userState.userData.categoryAndItsItem, userState.userData.players),
                                      category: getPlayerCategory(player, userState.userData.categoryAndItsItem, userState.userData.players),
                                      basePrice: context.read<GameBloc>().formatPriceShort(player.basePrice),
                                      rating: '${player.baseRating}',
                                      soldPrice: context.read<GameBloc>().formatPriceShort(player.currentPrice),
                                      isOdd: index.isOdd,
                                    );
                                  } else {
                                    return _buildTableRow(
                                      slot: slotLabel,
                                      name: '-',
                                      description: '-',
                                      category: '-',
                                      basePrice: '-',
                                      rating: '-',
                                      soldPrice: '-',
                                      isOdd: index.isOdd,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // --- Bottom Sections: SLOT WISE, CATEGORY WISE, BOWLING WISE ---
                  Row(
                    children: [
                      // SLOT WISE Box
                      _buildBottomBox(
                        title: 'SLOT WISE',
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildNumberedSquaresRow('BAT', getPlayerPrimaryCriteria(mySquad, AppIds.batsmanId, userState.userData.players, 3)),
                            _buildNumberedSquaresRow('WK', getPlayerPrimaryCriteria(mySquad, AppIds.wicketKeeperId, userState.userData.players, 2)),
                            _buildNumberedSquaresRow('ALR', getPlayerPrimaryCriteria(mySquad, AppIds.allRounderId, userState.userData.players, 4)),
                            _buildNumberedSquaresRow('BOWL', getPlayerPrimaryCriteria(mySquad, AppIds.bowlerId, userState.userData.players, 3)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // CATEGORY WISE Box
                      _buildBottomBox(
                        title: 'CATEGORY WISE',
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildNumberedSquaresRow('ICP', getPlayerCategoryStatusList(mySquad, AppIds.indianCappedPlayerId, userState.userData.players, 5)),
                            _buildNumberedSquaresRow('FP', getPlayerCategoryStatusList(mySquad, AppIds.foreignPlayerId, userState.userData.players, 4)),
                            _buildNumberedSquaresRow('IUP', getPlayerCategoryStatusList(mySquad, AppIds.indianUnCappedPlayerId, userState.userData.players, 3)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // BOWLING WISE Box
                      _buildBottomBox(
                        title: 'BOWLING WISE',
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBowlingSquareRow('RIGHT ARM SPIN', getPlayerBowlingStyleAvailable(mySquad, AppIds.rightArmSpin, userState.userData.players)),
                            _buildBowlingSquareRow('RIGHT ARM FAST', getPlayerBowlingStyleAvailable(mySquad, AppIds.rightArmFast, userState.userData.players)),
                            _buildBowlingSquareRow('LEFT ARM SPIN', getPlayerBowlingStyleAvailable(mySquad, AppIds.leftArmSpin, userState.userData.players)),
                            _buildBowlingSquareRow('LEFT ARM FAST', getPlayerBowlingStyleAvailable(mySquad, AppIds.leftArmFast, userState.userData.players)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, String iconPath, {Color valueColor = const Color(0xFFFFD700)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 1.2),
        borderRadius: BorderRadius.circular(6),
        color: Colors.black.withOpacity(0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, width: 30, height: 30),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: GoogleFonts.cinzel(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
              Text(value, style: GoogleFonts.cinzel(fontSize: 16, color: valueColor, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: const Border(bottom: BorderSide(color: Color(0xFFD4AF37), width: 1.5)),
      ),
      child: Row(
        children: [
          _buildCell('SLOT', flex: 1, isHeader: true),
          _buildCell('PLAYER NAME', flex: 2, isHeader: true),
          _buildCell('DESCRIPTION', flex: 2, isHeader: true),
          _buildCell('CATERGORY', flex: 1, isHeader: true), // Typo preserved from image
          _buildCell('BASE PRICE', flex: 1, isHeader: true),
          _buildCell('RATING', flex: 1, isHeader: true),
          _buildCell('SOLD PRICE', flex: 1, isHeader: true),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    required String slot,
    required String name,
    required String description,
    required String category,
    required String basePrice,
    required String rating,
    required String soldPrice,
    required bool isOdd,
  }) {
    Color categoryColor = const Color(0xFF00AFFF); // ICP light blue
    if (category == 'IUP') categoryColor = const Color(0xFFFF8C00); // IUP orange/brown

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: name == '-' ? AppTheme.navyBlue : Colors.transparent,
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
      ),
      child: Row(
        children: [
          _buildCell(slot, flex: 1, color: Colors.white),
          _buildCell(name, flex: 2, isBold: true, color: Colors.white),
          _buildCell(description, flex: 2, fontSize: 10, color: Colors.white70),
          _buildCell(category, flex: 1, color: categoryColor, isBold: true),
          _buildCell(basePrice, flex: 1, color: Colors.white),
          _buildCell(rating, flex: 1, color: const Color(0xFFFFD700), isBold: true),
          _buildCell(soldPrice, flex: 1, color: const Color(0xFF00FF00), isBold: true),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required int flex, bool isHeader = false, bool isBold = false, Color color = Colors.white, double fontSize = 11}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontSize: isHeader ? 10 : fontSize,
            fontWeight: isHeader || isBold ? FontWeight.bold : FontWeight.normal,
            color: isHeader ? AppTheme.borderGold : color,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBox({required String title, required Widget content}) {
    return Expanded(
      child: Container(
        height: 110,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.goldenOutline),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Column(
            children: [
              Container(
                width: 135,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.goldenTag),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: GoogleFonts.quantico(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Expanded(child: content),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberedSquaresRow(String label, List<bool> dots) {
    return Row(
      children: [
        SizedBox(width: 45, child: Text(label, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white))),
        const SizedBox(width: 10),
        ...List.generate(dots.length, (index) {
          return Container(
            width: 20,
            height: 14,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: dots[index] ? [
                    Color(0xff43A702),
                    Color(0xff0F3600),
                  ] : [
                    Color(0xff992213),
                    Color(0xff390000),
                  ]
              ),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.white24, width: 0.5),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: GoogleFonts.cinzel(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBowlingSquareRow(String label, bool isAvailable) {
    return Row(
      children: [
        Expanded(child: Text(label, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white))),
        Container(
          width: 20,
          height: 14,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isAvailable ? [
                  Color(0xff43A702),
                  Color(0xff0F3600),
                ] : [
                  Color(0xff992213),
                  Color(0xff390000),
                ]
            ),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.white24, width: 0.5),
          ),
          child: Center(
            child: Text(
              '1',
              style: GoogleFonts.cinzel(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // --- Logic Helper Methods (Preserved and integrated) ---

  double getSquadRating(Map<int, AuctionPlayerStatusEntity?> squad){
    double rating = 0.0;
    for(var key in squad.keys) {
      if(squad[key] != null){
        rating += squad[key]!.baseRating;
      }
    }
    return rating;
  }

  String getPlayerCategory(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    return toShortForm(categoryAndItemsEntity.playerCategoryCategoryId.firstWhere((e) => e.id == playerEntity.playerCategory).categoryItemName);
  }

  bool getPlayerBowlingStyleAvailable(Map<int, AuctionPlayerStatusEntity?> squad, String playerBowlingStyleId, List<PlayerEntity> playerList){
    bool available = false;
    for(var key in squad.keys) {
      if(squad[key] != null){
        PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == squad[key]!.playerId);
        if(playerEntity.bowlingStyle == playerBowlingStyleId && (squad[key]!.playerAuctionStatus == PlayerAuctionStatusEnum.sold || squad[key]!.playerAuctionStatus == PlayerAuctionStatusEnum.buy)){
          available = true;
          break;
        }
      }
    }
    return available;
  }

  List<bool> getPlayerPrimaryCriteria(Map<int, AuctionPlayerStatusEntity?> squad, String playerRoleId, List<PlayerEntity> playerList, int totalCount){
    int total = 0;
    for(var key in squad.keys) {
      if(squad[key] != null){
        PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == squad[key]!.playerId);
        if(playerEntity.playerRole == playerRoleId && (squad[key]!.playerAuctionStatus == PlayerAuctionStatusEnum.sold || squad[key]!.playerAuctionStatus == PlayerAuctionStatusEnum.buy)){
          total++;
        }
      }
    }
    return List.generate(totalCount, (index) => index < total);
  }

  List<bool> getPlayerCategoryStatusList(Map<int, AuctionPlayerStatusEntity?> squad, String playerCategoryId, List<PlayerEntity> playerList, int totalCount){
    int total = 0;
    for(var key in squad.keys) {
      if(squad[key] != null){
        PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == squad[key]!.playerId);
        if(playerEntity.playerCategory == playerCategoryId && (squad[key]!.playerAuctionStatus == PlayerAuctionStatusEnum.sold || squad[key]!.playerAuctionStatus == PlayerAuctionStatusEnum.buy)){
          total++;
        }
      }
    }
    print("total : $total");
    return List.generate(totalCount, (index) => index < total);
  }

  String getRoleStyle(int position, AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    String style = '';
    if(position >= 1 && position <= 3){
      style = categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName;
    }else if(position >= 4 && position <= 5){
      style = categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName;
    }else if(position >= 6 && position <= 9){
      style = categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName;
      style += ' / ' + categoryAndItemsEntity.bowlingStyleCategoryId.firstWhere((e) => e.id == playerEntity.bowlingStyle).categoryItemName;
    }else if(position >= 10 && position <= 12){
      style = categoryAndItemsEntity.bowlingStyleCategoryId.firstWhere((e) => e.id == playerEntity.bowlingStyle).categoryItemName;
    }
    return style.toUpperCase();
  }

  String toShortForm(String role) {
    return role.split(' ').map((word) => word[0]).join().toUpperCase();
  }
}
