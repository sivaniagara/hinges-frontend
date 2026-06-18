import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_data_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, UserDataEntity>> getUserData(String firebaseId);
  Future<Either<Failure, void>> increaseUserCoins(String userId, int coins);
}
