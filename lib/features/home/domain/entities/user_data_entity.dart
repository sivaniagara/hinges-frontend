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
  final CategoryAndItemsEntity categoryAndItsItem;
  final List<AuctionCategoryItemEntity> auctionCategoryItem;
  final List<PlayerEntity> players;

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
    required this.categoryAndItsItem,
    required this.auctionCategoryItem,
    required this.players,
  });

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
        categoryAndItsItem,
        auctionCategoryItem,
        players,
      ];
}
