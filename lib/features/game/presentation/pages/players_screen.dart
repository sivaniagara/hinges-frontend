import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_ids.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/presentation/widgets/gradient_text.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/enums/mini_auction_franchise_enum.dart';

import '../../../home/domain/entities/category_and_items_entity.dart';
import '../../../home/domain/entities/player_entity.dart';
import '../../domain/entities/auction_player_status_entity.dart';
import '../../domain/entities/user_status_entity.dart';

class PlayersScreen extends StatelessWidget {
  final String userId;
  final String playerRole;
  final String playerRoleName;
  const PlayersScreen({super.key, required this.userId, required this.playerRole, required this.playerRoleName});

  @override
  Widget build(BuildContext context) {
    List<Color> textColorForRedTag = [Colors.white, const Color(0xffFF1D2B)];
    List<Color> textColorForYellowTag = [const Color(0xff330000), const Color(0xffFF1D2B)];
    print('playerRole : $playerRole');
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
                          title: playerRoleName,
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
                                  // final mySquad = context.read<GameBloc>().getMySquad(userId);
                                  if(state is GameLoaded){
                                    List<AuctionPlayerStatusEntity> playersList = state.gameData.auctionPlayersStatusList.where((e) => e.playerRoleId == playerRole).toList();
                                    return Expanded(
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          for(var player = 0;player < playersList.length;player++)
                                            Column(
                                              children: [
                                                _buildTableRow(
                                                    '${player+1}',
                                                    getFranchise(playersList[player].teamId).shortName(),
                                                    playersList[player].playerName,
                                                    getRoleStyle(playersList[player], userState.userData.categoryAndItsItem, userState.userData.players),
                                                    getPlayerCategory(playersList[player], userState.userData.categoryAndItsItem, userState.userData.players),
                                                    getPlayerCategoryImage(playersList[player], userState.userData.categoryAndItsItem, userState.userData.players),
                                                    getPlayerCountryShortForm(playersList[player], userState.userData.categoryAndItsItem, userState.userData.players),
                                                    getPlayerCountryFlag(playersList[player], userState.userData.categoryAndItsItem, userState.userData.players),
                                                    '${(playersList[player].currentPrice/10000000).toStringAsFixed(2)} CR',
                                                    playersList[player].baseRating.toString()
                                                ),
                                                const Divider(height: 1, color: Colors.brown, thickness: 1),
                                              ],
                                            )
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
                      ],
                    ),
                  ),
                ],
              ),
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

  double getSquadRating(Map<int, AuctionPlayerStatusEntity?> squad){
    double rating = 0.0;
    for(var key in squad.keys) {
      if(squad[key] != null){
        rating += squad[key]!.baseRating;
      }
    }
    return rating;
  }


  MiniAuctionFranchiseEnum getFranchise(String teamId){
    if(MiniAuctionFranchiseEnum.csk.teamId() == teamId){
      return MiniAuctionFranchiseEnum.csk;
    }else if(MiniAuctionFranchiseEnum.mi.teamId() == teamId){
      return MiniAuctionFranchiseEnum.mi;
    }else if(MiniAuctionFranchiseEnum.kkr.teamId() == teamId) {
      return MiniAuctionFranchiseEnum.kkr;
    }else if(MiniAuctionFranchiseEnum.srh.teamId() == teamId) {
      return MiniAuctionFranchiseEnum.srh;
    }else if(MiniAuctionFranchiseEnum.rcb.teamId() == teamId){
      return MiniAuctionFranchiseEnum.rcb;
    }else{
      return MiniAuctionFranchiseEnum.empty;
    }

  }

  String getPlayerCountryFlag(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    String playerCountryId = '';
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    playerCountryId = categoryAndItemsEntity.countryCategoryId.firstWhere((e) => e.id == playerEntity.countryId).id;
    Map<String, String> flagMap = {
      '6880d715f960074f0cf61be7': '\u{1F1EE}\u{1F1F3}', // India 🇮🇳
      '6880d71ef960074f0cf61be8': '\u{1F1E6}\u{1F1FA}', // Australia 🇦🇺
      '6880d725f960074f0cf61be9': '\u{1F1EC}\u{1F1E7}', // England 🇬🇧
      '6880d72bf960074f0cf61bea': '\u{1F1F5}\u{1F1F0}', // Pakistan 🇵🇰
      '6880d734f960074f0cf61beb': '\u{1F1F3}\u{1F1FF}', // New Zealand 🇳🇿
      '6880d73ff960074f0cf61bec': '\u{1F1FF}\u{1F1E6}', // South Africa 🇿🇦
      '6880d748f960074f0cf61bed': '\u{1F1F1}\u{1F1F0}', // Sri Lanka 🇱🇰
      '6880d751f960074f0cf61bee': '\u{1F1F2}\u{1F1FC}', // West Indies (Montserrat 🇲🇸 often used)
      '6880d759f960074f0cf61bef': '\u{1F1E7}\u{1F1E9}', // Bangladesh 🇧🇩
      '6880d760f960074f0cf61bf0': '\u{1F1E6}\u{1F1EB}', // Afghanistan 🇦🇫
      '6880d766f960074f0cf61bf1': '\u{1F1EE}\u{1F1EA}', // Ireland 🇮🇪
      '6880d76df960074f0cf61bf2': '\u{1F1FF}\u{1F1FC}', // Zimbabwe 🇿🇼
    };
    if(flagMap.containsKey(playerCountryId)){
      return flagMap[playerCountryId]!;
    }else{
      return 'N/A';
    }
  }

  String getPlayerCountryShortForm(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    String playerCountryId = '';
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    playerCountryId = categoryAndItemsEntity.countryCategoryId.firstWhere((e) => e.id == playerEntity.countryId).id;
    Map<String, String> countryShortForms = {
      '6880d715f960074f0cf61be7': 'IND', // India
      '6880d71ef960074f0cf61be8': 'AUS', // Australia
      '6880d725f960074f0cf61be9': 'ENG', // England
      '6880d72bf960074f0cf61bea': 'PAK', // Pakistan
      '6880d734f960074f0cf61beb': 'NZ',  // New Zealand
      '6880d73ff960074f0cf61bec': 'SA',  // South Africa
      '6880d748f960074f0cf61bed': 'SL',  // Sri Lanka
      '6880d751f960074f0cf61bee': 'WI',  // West Indies
      '6880d759f960074f0cf61bef': 'BAN', // Bangladesh
      '6880d760f960074f0cf61bf0': 'AFG', // Afghanistan
      '6880d766f960074f0cf61bf1': 'IRE', // Ireland
      '6880d76df960074f0cf61bf2': 'ZIM', // Zimbabwe
    };

    if(countryShortForms.containsKey(playerCountryId)){
      return countryShortForms[playerCountryId]!;
    }else{
      return 'N/A';
    }
  }

  String getPlayerCategory(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    String playerCategory = '';
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    playerCategory = toShortForm(categoryAndItemsEntity.playerCategoryCategoryId.firstWhere((e) => e.id == playerEntity.playerCategory).categoryItemName);
    return playerCategory;
  }

  bool getPlayerBowlingStyleAvailable(Map<int, AuctionPlayerStatusEntity?> squad, String playerBowlingStyleId, List<PlayerEntity> playerList){
    bool available = false;
    for(var key in squad.keys) {
      if(squad[key] != null){
        PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == squad[key]!.playerId);
        if(playerEntity.bowlingStyle == playerBowlingStyleId){
          available = true;
          break;
        }
      }
    }
    return available;
  }
  List<bool> getPlayerCategoryStatusList(Map<int, AuctionPlayerStatusEntity?> squad, String playerCategoryId, List<PlayerEntity> playerList, totalCount){
    int total = 0;
    for(var key in squad.keys) {
      if(squad[key] != null){
        PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == squad[key]!.playerId);
        if(playerEntity.playerCategory == playerCategoryId){
          total++;
        }
      }
    }
    return List.generate(totalCount, (index) {
      if(index < total){
        return true;
      }
      return false;
    });
  }
  String getPlayerCategoryImage(AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    String playerRoleId = '';
    PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
    playerRoleId = categoryAndItemsEntity.playerRoleCategoryId.firstWhere((e) => e.id == playerEntity.playerRole).id;
    Map<String, String> roleCategory = {
      '6881ba0f36213beb0017be9c': AppImages.batsmanIcon,
      '6881ba3936213beb0017be9d': AppImages.wicketKeeperIcon,
      '6881bba636213beb0017be9e': AppImages.allRounderIcon,
      '6881e28cc8d219cd96a5c4b2': AppImages.bowlerIcon,
    };

    if(roleCategory.containsKey(playerRoleId)){
      return roleCategory[playerRoleId]!;
    }else{
      return 'N/A';
    }
  }
  String getRoleStyle( AuctionPlayerStatusEntity player, CategoryAndItemsEntity categoryAndItemsEntity, List<PlayerEntity> playerList){
    String playerRoleStyle = '';
    if(player.playerRoleId == AppIds.batsmanId){
      PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
      playerRoleStyle = toShortForm(categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName);
    }else if(player.playerRoleId == AppIds.wicketKeeperId){
      PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
      playerRoleStyle = toShortForm(categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName);
    }else if(player.playerRoleId == AppIds.allRounderId){
      PlayerEntity playerEntity = playerList.firstWhere((e) => e.playerId == player.playerId);
      playerRoleStyle = toShortForm(categoryAndItemsEntity.battingStyleCategoryId.firstWhere((e) => e.id == playerEntity.battingStyle).categoryItemName);
      playerRoleStyle += '/';
      playerRoleStyle += toShortForm(categoryAndItemsEntity.bowlingStyleCategoryId.firstWhere((e) => e.id == playerEntity.bowlingStyle).categoryItemName);
    }else if(player.playerRoleId == AppIds.bowlerId){
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
          _buildCell('FRANCHISE', flex: 1, isHeader: true),
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

  Widget _buildTableRow(String slotNo, String franchise, String name, String desc, String category, String roleImage, String country, String flag, String price, String rating) {
    print('roleImage => ${roleImage}');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _buildCell(slotNo, flex: 1),
          _buildCell(franchise, flex: 1),
          _buildCell(name, flex: 3, isBold: true),
          _buildCell(desc, flex: 2),
          _buildCell(category, flex: 1, image: roleImage),
          _buildCell(country, flex: 1, flag: flag),
          _buildCell(price, flex: 1, isBold: true,),
          _buildCell(rating, flex: 1, isBold: true),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required int flex, bool isHeader = false, bool isBold = false, bool useZuume = false , String image = '', String flag = ''}) {
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
            if (flag.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                  flag,
                  style: GoogleFonts.oxanium(
                    fontSize: isHeader ? 9 : 11,
                    fontWeight: isHeader || isBold ? FontWeight.bold : FontWeight.normal,
                    color: Colors.black,
                  )
              )            ],
            if (image.isNotEmpty) ...[
              const SizedBox(width: 4),
              Image.asset(image, width: 18),
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

