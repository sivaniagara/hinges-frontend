import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/presentation/widgets/gradient_text.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';

import '../../../home/domain/entities/category_and_items_entity.dart';
import '../../../home/domain/entities/player_entity.dart';
import '../../domain/entities/auction_player_status_entity.dart';

class MySquadScreen extends StatelessWidget {
  const MySquadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> textColorForRedTag = [Colors.white, const Color(0xffFF1D2B)];
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Stack(
            children: [
              Column(
                children: [
                  // Header
                  Center(
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImages.yellowTag),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Center(
                        child: GradientText(
                          title: 'MY SQUAD',
                          colors: textColorForYellowTag,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Table Section
                  Expanded(
                    child: Row(
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_drop_up, color: Colors.white, size: 24),
                            Icon(Icons.arrow_drop_down, color: Colors.white, size: 24),
                          ],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4D2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.brown, width: 2),
                            ),
                            child: Column(
                              children: [
                                _buildTableHeader(),
                                BlocBuilder<GameBloc,GameState>(builder: (context, state){
                                  final userState = context.read<HomeBloc>().state as HomeLoaded;
                                  final mySquad = context.read<GameBloc>().getMySquad(userState.userData.userId);
                                  if(state is GameLoaded){
                                    return Expanded(
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          for(var key = 1;key < 13;key++)
                                            if(mySquad[key] != null)
                                              Column(
                                                children: [
                                                  _buildTableRow(
                                                      '$key',
                                                      context.read<GameBloc>().getRole(key),
                                                      mySquad[key]!.playerName,
                                                      getRoleStyle(key, mySquad[key]!, userState.userData.categoryAndItsItem, userState.userData.players),
                                                      getPlayerCategory(mySquad[key]!, userState.userData.categoryAndItsItem, userState.userData.players),
                                                      true,
                                                      'IND',
                                                      true,
                                                      '${mySquad[key]!.currentPrice} CR',
                                                      mySquad[key]!.baseRating.toString()
                                                  ),
                                                  const Divider(height: 1, color: Colors.brown, thickness: 1),
                                                ],
                                              )
                                            else
                                              Column(
                                                children: [
                                                  _buildTableRow('$key', context.read<GameBloc>().getRole(key), '', '', '', false, '', false, '', ''),
                                                  const Divider(height: 1, color: Colors.brown, thickness: 1),
                                                ],
                                              )


                                          // _buildTableRow('2', 'BAT 2', 'SHIVAM DUBE', 'LHB', 'ICP', true, 'IND', true, '6 CR', '8.5'),
                                          // const Divider(height: 1, color: Colors.brown, thickness: 1),
                                          // _buildTableRow('3', 'BAT 3', '', '', '', false, '', false, '', ''),
                                          // const Divider(height: 1, color: Colors.brown, thickness: 1),
                                          // _buildTableRow('4', 'WK 1', 'MS TONY', 'WK/RHB', 'ICP', true, 'IND', true, '8.25 CR', '10'),
                                        ],
                                      ),
                                    );
                                  }

                                  return const SizedBox.shrink();

                                }),

                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_drop_up, color: Colors.white, size: 24),
                            Icon(Icons.arrow_drop_down, color: Colors.white, size: 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Bottom Section
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4D2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.brown, width: 2),
                    ),
                    child: Row(
                      children: [
                        // Purchase Criteria
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                            child: Column(
                              children: [
                                Text('PURCHASE CRITERIA', style: GoogleFonts.oxanium(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                                const SizedBox(height: 4),
                                const Divider(color: Colors.brown, height: 1),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildCriteriaRow('ICP', Colors.blue, [true, true, true, false, false]),
                                      _buildCriteriaRow('FP', Colors.orange, [true, true, false, false, false]),
                                      _buildCriteriaRow('IUP', Colors.grey, [true, true, false, false, false]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1, color: Colors.brown, thickness: 1),
                        // Bowler Criteria
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                            child: Column(
                              children: [
                                Text('BOWLER CRITERIA', style: GoogleFonts.oxanium(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                                const SizedBox(height: 4),
                                const Divider(color: Colors.brown, height: 1),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildBowlerRow('RIGHT ARM SPIN', false),
                                      _buildBowlerRow('LEFT ARM SPIN', true),
                                      _buildBowlerRow('RIGHT ARM FAST', true),
                                      _buildBowlerRow('LEFT ARM FAST', false),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1, color: Colors.brown, thickness: 1),
                        // Team Info
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(AppImages.csk, height: 50),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'CHENNAI SUPREME KINGS',
                                        style: GoogleFonts.oxanium(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildStatBox('MY PURSE', '60 CR', AppImages.yellowTag, textColorForYellowTag),
                                    _buildStatBox('PURSE REM', '25 CR', AppImages.redTag, textColorForRedTag),
                                    _buildStatBox('TOTAL RATING', '59.5', AppImages.redTag, textColorForRedTag),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Close Button
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(AppImages.cancelIcon, width: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getPlayerCategory(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    String playerCategory = '';
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    playerCategory = toShortForm(categoryAndItemsEntity.playerCategoryCategoryId.firstWhere((e) => e.id == playerEntity.playerCategory).categoryItemName);
    return playerCategory;
  }

  String getRoleStyle(int position, AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    String playerRoleStyle = '';
    if(position >= 1 && position <= 3){
      PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
      playerRoleStyle = toShortForm(categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName);
    }else if(position >= 4 && position <= 5){
      PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
      playerRoleStyle = toShortForm(categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName);
    }else if(position >= 6 && position <= 9){
      PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
      playerRoleStyle = toShortForm(categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName);
      playerRoleStyle += '/';
      playerRoleStyle += toShortForm(categoryAndItemsEntity.bowlingStyleCategoryId.firstWhere((e) => e.id == playerEntity.bowlingStyle).categoryItemName);
    }else if(position >= 10 && position <= 12){
      PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
      playerRoleStyle = toShortForm(categoryAndItemsEntity.bowlingStyleCategoryId.firstWhere((e) => e.id == playerEntity.bowlingStyle).categoryItemName);
    }
    return playerRoleStyle;
  }
  String toShortForm(String role) {
    return role
        .split(' ')
        .map((word) => word[0])
        .join();
  }



  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.brown, width: 1)),
      ),
      child: Row(
        children: [
          _buildCell('SLOT NO', flex: 1, isHeader: true),
          _buildCell('SLOT TYPE', flex: 1, isHeader: true),
          _buildCell('PLAYER NAME', flex: 3, isHeader: true),
          _buildCell('DESCRIPTION', flex: 2, isHeader: true),
          _buildCell('CATERGORY', flex: 1, isHeader: true), // Preserve "CATERGORY" typo from image
          _buildCell('COUNTRY', flex: 1, isHeader: true),
          _buildCell('SOLD PRICE', flex: 1, isHeader: true),
          _buildCell('RATING', flex: 1, isHeader: true),
        ],
      ),
    );
  }

  Widget _buildTableRow(String slotNo, String slotType, String name, String desc, String category, bool showCatIcon, String country, bool showFlag, String price, String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _buildCell(slotNo, flex: 1),
          _buildCell(slotType, flex: 1),
          _buildCell(name, flex: 3, isBold: true),
          _buildCell(desc, flex: 2),
          _buildCell(category, flex: 1, showIcon: showCatIcon),
          _buildCell(country, flex: 1, showFlag: showFlag),
          _buildCell(price, flex: 1, isBold: true, useZuume: true),
          _buildCell(rating, flex: 1, isBold: true, useZuume: true),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required int flex, bool isHeader = false, bool isBold = false, bool showIcon = false, bool showFlag = false, bool useZuume = false}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: useZuume 
                ? const TextStyle(
                    fontFamily: 'Zuume',
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.black,
                  )
                : GoogleFonts.oxanium(
                    fontSize: isHeader ? 9 : 11,
                    fontWeight: isHeader || isBold ? FontWeight.bold : FontWeight.normal,
                    color: Colors.black,
                  ),
            ),
            if (showIcon) ...[
              const SizedBox(width: 4),
              const Icon(Icons.circle, color: Colors.blue, size: 10),
            ],
            if (showFlag) ...[
              const SizedBox(width: 4),
              Image.asset(AppImages.indiaFlag, width: 18),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaRow(String label, Color iconColor, List<bool> dots) {
    return Row(
      children: [
        Icon(Icons.circle, color: iconColor, size: 14),
        const SizedBox(width: 6),
        SizedBox(width: 25, child: Text(label, style: GoogleFonts.oxanium(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black))),
        const SizedBox(width: 6),
        ...dots.map((isGreen) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: Icon(Icons.circle, color: isGreen ? Colors.green : Colors.red, size: 14),
        )),
      ],
    );
  }

  Widget _buildBowlerRow(String label, bool isGreen) {
    return Row(
      children: [
        Image.asset(AppImages.bowlerIcon, width: 14, height: 14),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: GoogleFonts.oxanium(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black))),
        Icon(Icons.circle, color: isGreen ? Colors.green : Colors.red, size: 12),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, String tagImage, List<Color> colors) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.oxanium(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 2),
        Container(
          width: 85,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(tagImage),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: GradientText(
              title: value,
              colors: colors,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
