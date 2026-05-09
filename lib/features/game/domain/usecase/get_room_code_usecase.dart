import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/room_code_entity.dart';
import '../repository/game_repository.dart';

class GetRoomCodeUseCase implements UseCase<RoomCodeEntity, NoParams> {
  final GameRepository repository;

  GetRoomCodeUseCase(this.repository);

  @override
  Future<Either<Failure, RoomCodeEntity>> call(NoParams params) async {
    return await repository.getRoomCode();
  }
}
