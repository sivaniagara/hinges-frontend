import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class RegisterGuestUserParams {
  final String userId;
  final String userName;

  RegisterGuestUserParams({required this.userId, required this.userName});
}

class RegisterGuestUserUseCase implements UseCase<void, RegisterGuestUserParams> {
  final AuthRepository repository;

  RegisterGuestUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterGuestUserParams params) async {
    return await repository.syncGuestUser(
      userId: params.userId,
      userName: params.userName,
    );
  }
}
