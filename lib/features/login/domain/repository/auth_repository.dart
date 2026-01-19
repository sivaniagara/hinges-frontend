import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';

abstract class AuthRepository{
  Future<Either<Failure, UserCredential>> signUp({
    required String userName,
    required String phoneNumber,
    required String emailId,
    required String password,
    required bool agreeTermsAndCondition
  });
}