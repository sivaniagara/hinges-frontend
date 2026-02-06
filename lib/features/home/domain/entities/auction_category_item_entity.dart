import 'package:equatable/equatable.dart';

class AuctionCategoryItemEntity extends Equatable {
  final String id;
  final String categoryItemId;
  final int coinsGameFees;
  final int coinsFirstPrize;
  final int coinsSecondPrize;
  final int coinsThirdPrize;
  final int cashGameFees;
  final int cashFirstPrize;
  final int cashSecondPrize;
  final int cashThirdPrize;

  const AuctionCategoryItemEntity({
    required this.id,
    required this.categoryItemId,
    required this.coinsGameFees,
    required this.coinsFirstPrize,
    required this.coinsSecondPrize,
    required this.coinsThirdPrize,
    required this.cashGameFees,
    required this.cashFirstPrize,
    required this.cashSecondPrize,
    required this.cashThirdPrize,
  });

  @override
  List<Object?> get props => [
        id,
        categoryItemId,
        coinsGameFees,
        coinsFirstPrize,
        coinsSecondPrize,
        coinsThirdPrize,
        cashGameFees,
        cashFirstPrize,
        cashSecondPrize,
        cashThirdPrize,
      ];
}
