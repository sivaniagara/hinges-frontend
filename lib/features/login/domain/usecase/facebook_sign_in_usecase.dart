import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class FacebookSignInUseCase implements UseCase<UserCredential, NoParams> {
  final AuthRepository repository;

  FacebookSignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserCredential>> call(NoParams params) async {
    return await repository.signInWithFacebook();
  }
}
