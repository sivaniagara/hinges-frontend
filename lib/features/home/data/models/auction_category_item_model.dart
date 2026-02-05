import '../../domain/entities/auction_category_item_entity.dart';

class AuctionCategoryItemModel extends AuctionCategoryItemEntity {
  const AuctionCategoryItemModel({
    required super.id,
    required super.categoryItemId,
    required super.coinsGameFees,
    required super.coinsFirstPrize,
    required super.coinsSecondPrize,
    required super.cashGameFees,
    required super.cashFirstPrize,
    required super.cashSecondPrize,
  });

  factory AuctionCategoryItemModel.fromJson(Map<String, dynamic> json) {
    return AuctionCategoryItemModel(
      id: json['_id'] ?? '',
      categoryItemId: json['category_item_id'] ?? '',
      coinsGameFees: json['coins_game_fees'] ?? 0,
      coinsFirstPrize: json['coins_first_prize'] ?? 0,
      coinsSecondPrize: json['coins_second_prize'] ?? 0,
      cashGameFees: json['cash_game_fees'] ?? 0,
      cashFirstPrize: json['cash_first_prize'] ?? 0,
      cashSecondPrize: json['cash_second_prize'] ?? 0,
    );
  }
}
