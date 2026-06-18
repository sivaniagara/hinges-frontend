import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repository/home_repository.dart';

class IncreaseUserCoinsUseCase {
  final HomeRepository repository;

  IncreaseUserCoinsUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId, int coins) async {
    return await repository.increaseUserCoins(userId, coins);
  }
}
