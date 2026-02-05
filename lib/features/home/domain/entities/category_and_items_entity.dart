import 'package:equatable/equatable.dart';
import 'category_item_entity.dart';

class CategoryAndItemsEntity extends Equatable {
  final List<CategoryItemEntity> teamCategoryId;
  final List<CategoryItemEntity> miniAuctionLiteCategoryId;
  final List<CategoryItemEntity> megaAuctionLiteCategoryId;
  final List<CategoryItemEntity> countryCategoryId;
  final List<CategoryItemEntity> playerRoleCategoryId;
  final List<CategoryItemEntity> playerCategoryCategoryId;
  final List<CategoryItemEntity> battingStyleCategoryId;
  final List<CategoryItemEntity> bowlingStyleCategoryId;

  const CategoryAndItemsEntity({
    required this.teamCategoryId,
    required this.miniAuctionLiteCategoryId,
    required this.megaAuctionLiteCategoryId,
    required this.countryCategoryId,
    required this.playerRoleCategoryId,
    required this.playerCategoryCategoryId,
    required this.battingStyleCategoryId,
    required this.bowlingStyleCategoryId,
  });

  @override
  List<Object?> get props => [
        teamCategoryId,
        miniAuctionLiteCategoryId,
        megaAuctionLiteCategoryId,
        countryCategoryId,
        playerRoleCategoryId,
        playerCategoryCategoryId,
        battingStyleCategoryId,
        bowlingStyleCategoryId,
      ];
}
