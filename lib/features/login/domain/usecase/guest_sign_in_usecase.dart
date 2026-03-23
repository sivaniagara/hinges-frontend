import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class GuestSignInUseCase implements UseCase<UserCredential, NoParams> {
  final AuthRepository repository;

  GuestSignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserCredential>> call(NoParams params) async {
    // In our repository, we should implement a method for anonymous/guest login
    // For now, I'll assume AuthRepository has a signInAnonymously method
    return await repository.signInAnonymously();
  }
}
