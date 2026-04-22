import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/game_repository.dart';

class ExitMatchUseCase implements UseCase<void, ExitMatchParams> {
  final GameRepository repository;

  ExitMatchUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ExitMatchParams params) async {
    return await repository.exitMatch(params);
  }
}

class ExitMatchParams extends Equatable {
  final String userId;
  final String matchId;

  const ExitMatchParams({required this.userId, required this.matchId});

  @override
  List<Object?> get props => [userId, matchId];
}
