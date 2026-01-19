import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';


class SignUpParams{
  final String userName;
  final String phoneNumber;
  final String emailId;
  final String password;
  final bool agreeTermsAndCondition;
  SignUpParams({
    required this.userName,
    required this.phoneNumber,
    required this.emailId,
    required this.password,
    required this.agreeTermsAndCondition
  });
}

class SignUpUseCase implements UseCase<UserCredential, SignUpParams>{
  final AuthRepository authRepository;
  SignUpUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserCredential>> call(SignUpParams params) {
    return authRepository.signUp(
        userName: params.userName,
        phoneNumber: params.phoneNumber,
        emailId: params.emailId,
        password: params.password,
        agreeTermsAndCondition: params.agreeTermsAndCondition
    );
  }
}