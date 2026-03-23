import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';
import '../usecase/sign_up_usecase.dart';

abstract class AuthRepository{
  Future<Either<Failure, UserCredential>> signUp(SignUpParams params);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, UserCredential>> signInWithGoogle();
  Future<Either<Failure, UserCredential>> signInAnonymously();
  Future<Either<Failure, void>> updateUserDetailsInDb({
    required String userId,
    required String userName,
    String? userEmailId,
    required String userMobileNumber,
    required int authProvider,
    String? profilePath,
    required DateTime createdAt,
  });
  Future<Either<Failure, void>> syncGuestUser({
    required String userId,
    required String userName,
  });
}
