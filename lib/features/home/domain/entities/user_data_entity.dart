import 'package:equatable/equatable.dart';
import 'category_and_items_entity.dart';
import 'auction_category_item_entity.dart';
import 'player_entity.dart';

class UserDataEntity extends Equatable {
  final String userId;
  final String userName;
  final String userEmailId;
  final String userMobileNumber;
  final int authProvider;
  final String firebaseId;
  final String profilePath;
  final String createdAt;
  final int gamePlayed;
  final int qualified;
  final int disqualified;
  final int coinWon;
  final int firstPrice;
  final int secondPrice;
  final int thirdPrice;
  final int miniAuctionLiteClassicPlayed;
  final int miniAuctionLitePremiumPlayed;
  final int miniAuctionLiteElitePlayed;
  final int miniAuctionLiteRoyalPlayed;
  final CategoryAndItemsEntity categoryAndItsItem;
  final List<AuctionCategoryItemEntity> auctionCategoryItem;
  // final List<PlayerEntity> players;

  const UserDataEntity({
    required this.userId,
    required this.userName,
    required this.userEmailId,
    required this.userMobileNumber,
    required this.authProvider,
    required this.firebaseId,
    required this.profilePath,
    required this.createdAt,
    required this.gamePlayed,
    required this.qualified,
    required this.disqualified,
    required this.coinWon,
    required this.firstPrice,
    required this.secondPrice,
    required this.thirdPrice,
    required this.miniAuctionLiteClassicPlayed,
    required this.miniAuctionLitePremiumPlayed,
    required this.miniAuctionLiteElitePlayed,
    required this.miniAuctionLiteRoyalPlayed,
    required this.categoryAndItsItem,
    required this.auctionCategoryItem,
    // required this.players,
  });

  UserDataEntity copyWith({
    String? userId,
    String? userName,
    String? userEmailId,
    String? userMobileNumber,
    int? authProvider,
    String? firebaseId,
    String? profilePath,
    String? createdAt,
    int? gamePlayed,
    int? qualified,
    int? disqualified,
    int? coinWon,
    int? firstPrice,
    int? secondPrice,
    int? thirdPrice,
    int? miniAuctionLiteClassicPlayed,
    int? miniAuctionLitePremiumPlayed,
    int? miniAuctionLiteElitePlayed,
    int? miniAuctionLiteRoyalPlayed,
    CategoryAndItemsEntity? categoryAndItsItem,
    List<AuctionCategoryItemEntity>? auctionCategoryItem,
  }) {
    return UserDataEntity(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmailId: userEmailId ?? this.userEmailId,
      userMobileNumber: userMobileNumber ?? this.userMobileNumber,
      authProvider: authProvider ?? this.authProvider,
      firebaseId: firebaseId ?? this.firebaseId,
      profilePath: profilePath ?? this.profilePath,
      createdAt: createdAt ?? this.createdAt,
      gamePlayed: gamePlayed ?? this.gamePlayed,
      qualified: qualified ?? this.qualified,
      disqualified: disqualified ?? this.disqualified,
      coinWon: coinWon ?? this.coinWon,
      firstPrice: firstPrice ?? this.firstPrice,
      secondPrice: secondPrice ?? this.secondPrice,
      thirdPrice: thirdPrice ?? this.thirdPrice,
      miniAuctionLiteClassicPlayed:
          miniAuctionLiteClassicPlayed ?? this.miniAuctionLiteClassicPlayed,
      miniAuctionLitePremiumPlayed:
          miniAuctionLitePremiumPlayed ?? this.miniAuctionLitePremiumPlayed,
      miniAuctionLiteElitePlayed:
          miniAuctionLiteElitePlayed ?? this.miniAuctionLiteElitePlayed,
      miniAuctionLiteRoyalPlayed:
          miniAuctionLiteRoyalPlayed ?? this.miniAuctionLiteRoyalPlayed,
      categoryAndItsItem: categoryAndItsItem ?? this.categoryAndItsItem,
      auctionCategoryItem: auctionCategoryItem ?? this.auctionCategoryItem,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        userName,
        userEmailId,
        userMobileNumber,
        authProvider,
        firebaseId,
        profilePath,
        createdAt,
        gamePlayed,
        qualified,
        disqualified,
        coinWon,
        firstPrice,
        secondPrice,
        thirdPrice,
        miniAuctionLiteClassicPlayed,
        miniAuctionLitePremiumPlayed,
        miniAuctionLiteElitePlayed,
        miniAuctionLiteRoyalPlayed,
        categoryAndItsItem,
        auctionCategoryItem,
        // players,
      ];
}
