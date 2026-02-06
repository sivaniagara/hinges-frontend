import 'package:dartz/dartz.dart';
import 'package:hinges_frontend/core/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/game_data_entity.dart';
import '../repository/game_repository.dart';

class GetGameDataParam{
  final String userId;
  final String auctionCategoryId;
  GetGameDataParam({required this.userId, required this.auctionCategoryId});
}

class GetGameDataUseCase extends UseCase<GameDataEntity, GetGameDataParam> {
  final GameRepository repository;

  GetGameDataUseCase({required this.repository});

  @override
  Future<Either<Failure, GameDataEntity>> call(GetGameDataParam params) async {
    return await repository.getGameData(params);
  }
}
