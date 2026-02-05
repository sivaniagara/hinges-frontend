import '../../domain/entities/category_and_items_entity.dart';
import 'category_item_model.dart';

class CategoryAndItemsModel extends CategoryAndItemsEntity {
  const CategoryAndItemsModel({
    required List<CategoryItemModel> super.teamCategoryId,
    required List<CategoryItemModel> super.miniAuctionLiteCategoryId,
    required List<CategoryItemModel> super.megaAuctionLiteCategoryId,
    required List<CategoryItemModel> super.countryCategoryId,
    required List<CategoryItemModel> super.playerRoleCategoryId,
    required List<CategoryItemModel> super.playerCategoryCategoryId,
    required List<CategoryItemModel> super.battingStyleCategoryId,
    required List<CategoryItemModel> super.bowlingStyleCategoryId,
  });

  factory CategoryAndItemsModel.fromJson(Map<String, dynamic> json) {
    return CategoryAndItemsModel(
      teamCategoryId: (json['team_category_id'] as List? ?? [])
          .map((i) => CategoryItemModel.fromJson(i))
          .toList(),
      miniAuctionLiteCategoryId: (json['mini_auction_lite_category_id'] as List? ?? [])
          .map((i) => CategoryItemModel.fromJson(i))
          .toList(),
      megaAuctionLiteCategoryId: (json['mega_auction_lite_category_id'] as List? ?? [])
          .map((i) => CategoryItemModel.fromJson(i))
          .toList(),
      countryCategoryId: (json['country_category_id'] as List? ?? [])
          .map((i) => CategoryItemModel.fromJson(i))
          .toList(),
      playerRoleCategoryId: (json['player_role_category_id'] as List? ?? [])
          .map((i) => CategoryItemModel.fromJson(i))
          .toList(),
      playerCategoryCategoryId: (json['player_category_category_id'] as List? ?? [])
          .map((i) => CategoryItemModel.fromJson(i))
          .toList(),
      battingStyleCategoryId: (json['batting_style_category_id'] as List? ?? [])
          .map((i) => CategoryItemModel.fromJson(i))
          .toList(),
      bowlingStyleCategoryId: (json['bowling_style_category_id'] as List? ?? [])
          .map((i) => CategoryItemModel.fromJson(i))
          .toList(),
    );
  }
}
