import '../../domain/entities/user_data_entity.dart';
import 'category_and_items_model.dart';
import 'auction_category_item_model.dart';

class UserDataModel extends UserDataEntity {
  const UserDataModel({
    required super.userId,
    required super.userName,
    required super.userEmailId,
    required super.userMobileNumber,
    required super.authProvider,
    required super.firebaseId,
    required super.profilePath,
    required super.createdAt,
    required super.gamePlayed,
    required super.qualified,
    required super.disqualified,
    required super.coinWon,
    required super.firstPrice,
    required super.secondPrice,
    required super.thirdPrice,
    required CategoryAndItemsModel super.categoryAndItsItem,
    required List<AuctionCategoryItemModel> super.auctionCategoryItem,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userEmailId: json['user_email_id'] ?? '',
      userMobileNumber: json['user_mobile_number'] ?? '',
      authProvider: json['auth_provider'] ?? 0,
      firebaseId: json['fire_base_id'] ?? '',
      profilePath: json['profile_path'] ?? '',
      createdAt: json['created_at'] ?? '',
      gamePlayed: json['game_played'] ?? 0,
      qualified: json['qualified'] ?? 0,
      disqualified: json['disqualified'] ?? 0,
      coinWon: json['coin_won'] ?? 0,
      firstPrice: json['first_price'] ?? 0,
      secondPrice: json['second_price'] ?? 0,
      thirdPrice: json['third_price'] ?? 0,
      categoryAndItsItem: CategoryAndItemsModel.fromJson(
        json['category_and_its_item'] ?? {},
      ),
      auctionCategoryItem: (json['auction_category_item'] as List? ?? [])
          .map((i) => AuctionCategoryItemModel.fromJson(i))
          .toList(),
    );
  }
}
