import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_ids.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/enums/mini_auction_franchise_enum.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../home/domain/entities/category_and_items_entity.dart';
import '../../../home/domain/entities/player_entity.dart';
import '../../domain/entities/auction_player_status_entity.dart';

class PlayersScreen extends StatelessWidget {
  final String userId;
  final String playerRole;
  final String playerRoleName;
  const PlayersScreen({super.key, required this.userId, required this.playerRole, required this.playerRoleName});

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

              final userState = context.read<HomeBloc>().state as HomeLoaded;
              List<AuctionPlayerStatusEntity> playersList = state.gameData.auctionPlayersStatusList.where((e) => e.playerRoleId == playerRole).toList();
              
              // Sorting logic: Auction players first, then Unsold, then Sold/Buy
              playersList = [
                ...playersList.where((e) => e.playerAuctionStatus == PlayerAuctionStatusEnum.available || e.playerAuctionStatus == PlayerAuctionStatusEnum.notShown),
                ...playersList.where((e) => e.playerAuctionStatus == PlayerAuctionStatusEnum.notSold),
                ...playersList.where((e) => e.playerAuctionStatus == PlayerAuctionStatusEnum.buy || e.playerAuctionStatus == PlayerAuctionStatusEnum.sold),
              ];

              final totalCount = playersList.length;
              final soldCount = playersList.where((e) => e.playerAuctionStatus == PlayerAuctionStatusEnum.sold || e.playerAuctionStatus == PlayerAuctionStatusEnum.buy).length;
              final auctionCount = playersList.where((e) => e.playerAuctionStatus == PlayerAuctionStatusEnum.available || e.playerAuctionStatus == PlayerAuctionStatusEnum.notShown).length;
              final unsoldCount = playersList.where((e) => e.playerAuctionStatus == PlayerAuctionStatusEnum.notSold).length;

              return Column(
                children: [
                  // --- Header Row ---
                  Row(
                    spacing: 30,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.8, color: AppTheme.borderGold),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                width: 25,
                                height: 25,
                                context.read<GameBloc>().getPlayerRoleImageById(playerRole),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                children: [
                                  Text(
                                    playerRoleName.toUpperCase(),
                                    style: GoogleFonts.cinzel(
                                      color: AppTheme.borderGold,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Text(
                                    'SET',
                                    style: GoogleFonts.cinzel(
                                      color: AppTheme.borderGold,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              getStartDivider(),
                              _buildHeaderStat('TOTAL PLAYERS', '$totalCount', AppImages.mySquad, Colors.white),
                              getStartDivider(),
                              _buildHeaderStat('PLAYERS SOLD', '$soldCount', AppImages.playerSold, Colors.green),
                              getStartDivider(),
                              _buildHeaderStat('PLAYERS IN AUCTION', '$auctionCount', AppImages.hammer, Colors.yellow),
                              getStartDivider(),
                              _buildHeaderStat('PLAYERS UNSOLD', '$unsoldCount', AppImages.playerUnsold, Colors.red),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(AppImages.backMenuIcon, width: 50),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // --- Table Section ---
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFF00AFFF).withOpacity(0.3), width: 1),
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
                                itemCount: playersList.length,
                                itemBuilder: (context, index) {
                                  final player = playersList[index];
                                  final (status, statusColor) = getPlayerStatus(player);
                                  final franchise = getFranchise(player.teamId);

                                  return _buildTableRow(
                                    no: '${index + 1}',
                                    name: player.playerName.toUpperCase(),
                                    description: getRoleStyle(player, userState.userData.categoryAndItsItem, userState.userData.players),
                                    category: getPlayerCategory(player, userState.userData.categoryAndItsItem, userState.userData.players),
                                    flag: getPlayerCountryFlag(player, userState.userData.categoryAndItsItem, userState.userData.players),
                                    basePrice: context.read<GameBloc>().formatPriceShort(player.basePrice),
                                    rating: player.baseRating.toString(),
                                    status: status,
                                    statusColor: statusColor,
                                    soldPrice: (player.playerAuctionStatus == PlayerAuctionStatusEnum.sold || player.playerAuctionStatus == PlayerAuctionStatusEnum.buy) 
                                        ? context.read<GameBloc>().formatPriceShort(player.currentPrice) 
                                        : '-',
                                    franchise: franchise != MiniAuctionFranchiseEnum.empty ? franchise.shortName() : '-',
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

  Widget _buildDiamondDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Transform.rotate(
        angle: 45 * 3.14159 / 180,
        child: Container(
          width: 6,
          height: 6,
          color: const Color(0xFFD4AF37),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, String image, Color color) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.cinzel(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, width: 30, height: 30,),
            const SizedBox(width: 8),
            Text(value, style: GoogleFonts.cinzel(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w900)),
          ],
        ),
      ],
    );
  }

  Widget getStartDivider(){
    return SizedBox(
      height: 30,
      child: VerticalDivider(
        thickness: 0.4,
        color: AppTheme.borderGold
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: const Border(bottom: BorderSide(color: Color(0xFF00AFFF), width: 1)),
      ),
      child: Row(
        children: [
          _buildCell('NO', flex: 1, isHeader: true),
          _buildCell('PLAYER NAME', flex: 3, isHeader: true, textAlign: TextAlign.start),
          _buildCell('DESCRIPTION', flex: 3, isHeader: true),
          _buildCell('CATEGORY', flex: 2, isHeader: true),
          _buildCell('COUNTRY', flex: 2, isHeader: true),
          _buildCell('BASE PRICE', flex: 2, isHeader: true),
          _buildCell('RATING', flex: 1, isHeader: true),
          _buildCell('STATUS', flex: 2, isHeader: true),
          _buildCell('SOLD PRICE', flex: 2, isHeader: true),
          _buildCell('FRANCHISE', flex: 2, isHeader: true),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    required String no,
    required String name,
    required String description,
    required String category,
    required String flag,
    required String basePrice,
    required String rating,
    required String status,
    required Color statusColor,
    required String soldPrice,
    required String franchise,
    required bool isOdd,
  }) {
    Color categoryColor = const Color(0xFF00BFFF); // ICP blue
    if (category == 'IUP') categoryColor = const Color(0xFFFF8C00); // IUP orange
    else if (category == 'FP') categoryColor = const Color(0xFFFF00FF); // FP purple

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isOdd ? Colors.white.withOpacity(0.02) : Colors.transparent,
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 0.5)),
      ),
      child: Row(
        children: [
          _buildCell(no, flex: 1, color: Colors.white),
          _buildCell(name, flex: 3, isBold: true, color: Colors.white, textAlign: TextAlign.start, fontSize: 10),
          _buildCell(description, flex: 3, fontSize: 10, color: Colors.white),
          _buildCell(category, flex: 2, color: categoryColor, isBold: true),
          _buildCell(flag, flex: 2, fontSize: 18),
          _buildCell(basePrice, flex: 2, color: Colors.white),
          _buildCell(rating, flex: 1, color: AppTheme.borderGold, isBold: true),
          _buildCell(status, flex: 2, color: statusColor, isBold: true),
          _buildCell(soldPrice, flex: 2),
          _buildCell(franchise, flex: 2, color: AppTheme.borderGold, isBold: true),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required int flex, bool isHeader = false, bool isBold = false, Color color = Colors.white, double fontSize = 11, TextAlign textAlign = TextAlign.center}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          text,
          textAlign: textAlign,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cinzel(
            fontSize: isHeader ? 10 : fontSize,
            fontWeight: isHeader || isBold ? FontWeight.bold : FontWeight.normal,
            color: isHeader ? AppTheme.borderGold : color,
          ),
        ),
      ),
    );
  }

  // --- Logic Helper Methods ---

  (String, Color) getPlayerStatus(AuctionPlayerStatusEntity player){
    if(player.playerAuctionStatus == PlayerAuctionStatusEnum.sold || player.playerAuctionStatus == PlayerAuctionStatusEnum.buy){
      return ('SOLD', Colors.green);
    }else if(player.playerAuctionStatus == PlayerAuctionStatusEnum.notSold){
      return ('UNSOLD', Colors.red);
    }else{
      return ('AUCTION', const Color(0xFF00AFFF));
    }
  }

  MiniAuctionFranchiseEnum getFranchise(String teamId){
    if(MiniAuctionFranchiseEnum.csk.teamId() == teamId) return MiniAuctionFranchiseEnum.csk;
    if(MiniAuctionFranchiseEnum.mi.teamId() == teamId) return MiniAuctionFranchiseEnum.mi;
    if(MiniAuctionFranchiseEnum.kkr.teamId() == teamId) return MiniAuctionFranchiseEnum.kkr;
    if(MiniAuctionFranchiseEnum.srh.teamId() == teamId) return MiniAuctionFranchiseEnum.srh;
    if(MiniAuctionFranchiseEnum.rcb.teamId() == teamId) return MiniAuctionFranchiseEnum.rcb;
    return MiniAuctionFranchiseEnum.empty;
  }

  String getPlayerCountryFlag(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    final countryId = playerEntity.countryId;
    Map<String, String> flagMap = {
      '6880d715f960074f0cf61be7': '🇮🇳',
      '6880d71ef960074f0cf61be8': '🇦🇺',
      '6880d725f960074f0cf61be9': '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
      '6880d72bf960074f0cf61bea': '🇵🇰',
      '6880d734f960074f0cf61beb': '🇳🇿',
      '6880d73ff960074f0cf61bec': '🇿🇦',
      '6880d748f960074f0cf61bed': '🇱🇰',
      '6880d751f960074f0cf61bee': '🏝️',
      '6880d759f960074f0cf61bef': '🇧🇩',
      '6880d760f960074f0cf61bf0': '🇦🇫',
      '6880d766f960074f0cf61bf1': '🇮🇪',
      '6880d76df960074f0cf61bf2': '🇿🇼',
    };
    return flagMap[countryId] ?? '❓';
  }

  String getPlayerCategory(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    return toShortForm(categoryAndItemsEntity.playerCategoryCategoryId.firstWhere((e) => e.id == playerEntity.playerCategory).categoryItemName);
  }

  String getRoleStyle(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    String style = '';
    if(player.playerRoleId == AppIds.batsmanId){
      style = categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName;
    }else if(player.playerRoleId == AppIds.wicketKeeperId){
      style = categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName;
    }else if(player.playerRoleId == AppIds.allRounderId){
      style = categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName;
      style += ' / ' + categoryAndItemsEntity.bowlingStyleCategoryId.firstWhere((e) => e.id == playerEntity.bowlingStyle).categoryItemName;
    }else if(player.playerRoleId == AppIds.bowlerId){
      style = categoryAndItemsEntity.bowlingStyleCategoryId.firstWhere((e) => e.id == playerEntity.bowlingStyle).categoryItemName;
    }
    return style.toUpperCase();
  }

  String toShortForm(String role) {
    return role.split(' ').map((word) => word[0]).join().toUpperCase();
  }

  String getPlayerCountryShortForm(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    final countryId = playerEntity.countryId;
    Map<String, String> countryShortForms = {
      '6880d715f960074f0cf61be7': 'IND',
      '6880d71ef960074f0cf61be8': 'AUS',
      '6880d725f960074f0cf61be9': 'ENG',
      '6880d72bf960074f0cf61bea': 'PAK',
      '6880d734f960074f0cf61beb': 'NZ',
      '6880d73ff960074f0cf61bec': 'SA',
      '6880d748f960074f0cf61bed': 'SL',
      '6880d751f960074f0cf61bee': 'WI',
      '6880d759f960074f0cf61bef': 'BAN',
      '6880d760f960074f0cf61bf0': 'AFG',
      '6880d766f960074f0cf61bf1': 'IRE',
      '6880d76df960074f0cf61bf2': 'ZIM',
    };
    return countryShortForms[countryId] ?? 'N/A';
  }
}
