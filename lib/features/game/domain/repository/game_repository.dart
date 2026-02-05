import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/game_data_entity.dart';
import '../usecase/get_game_data_usecase.dart';

abstract class GameRepository {
  Future<Either<Failure, GameDataEntity>> getGameData(GetGameDataParam params);
}
