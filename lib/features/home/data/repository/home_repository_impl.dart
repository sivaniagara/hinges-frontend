import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user_data_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../data_source/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserDataEntity>> getUserData(String firebaseId) async {
    try {
      final result = await remoteDataSource.getUserData(firebaseId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
