import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_data_entity.dart';
import '../repository/home_repository.dart';

class GetUserDataUseCase {
  final HomeRepository repository;

  GetUserDataUseCase({required this.repository});

  Future<Either<Failure, UserDataEntity>> call(String firebaseId) async {
    return await repository.getUserData(firebaseId);
  }
}
