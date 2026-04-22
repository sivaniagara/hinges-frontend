import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/game_data_entity.dart';
import '../../domain/repository/game_repository.dart';
import '../../domain/usecase/get_game_data_usecase.dart';
import '../../domain/usecase/exit_match_usecase.dart';
import '../data_source/game_remote_data_source.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource remoteDataSource;

  GameRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, GameDataEntity>> getGameData(GetGameDataParam params) async {
    try {
      final result = await remoteDataSource.getGameData({
        "userId": params.userId,
        "userName": params.userName,
        "auctionCategoryId": params.auctionCategoryId,
        "matchType": params.matchType,
      });
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> exitMatch(ExitMatchParams params) async {
    try {
      await remoteDataSource.exitMatch({
        "user_id": params.userId,
        "match_id": params.matchId,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
