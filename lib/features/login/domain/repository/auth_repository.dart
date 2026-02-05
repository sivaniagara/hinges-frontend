import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';
import '../usecase/sign_up_usecase.dart';

abstract class AuthRepository{
  Future<Either<Failure, UserCredential>> signUp(SignUpParams params);
}