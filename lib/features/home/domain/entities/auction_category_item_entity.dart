import 'package:equatable/equatable.dart';

class AuctionCategoryItemEntity extends Equatable {
  final String id;
  final String categoryItemId;
  final int coinsGameFees;
  final int coinsFirstPrize;
  final int coinsSecondPrize;
  final int cashGameFees;
  final int cashFirstPrize;
  final int cashSecondPrize;

  const AuctionCategoryItemEntity({
    required this.id,
    required this.categoryItemId,
    required this.coinsGameFees,
    required this.coinsFirstPrize,
    required this.coinsSecondPrize,
    required this.cashGameFees,
    required this.cashFirstPrize,
    required this.cashSecondPrize,
  });

  @override
  List<Object?> get props => [
        id,
        categoryItemId,
        coinsGameFees,
        coinsFirstPrize,
        coinsSecondPrize,
        cashGameFees,
        cashFirstPrize,
        cashSecondPrize,
      ];
}
