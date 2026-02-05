import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/sign_up_usecase.dart';
import '../data_source/firebase_auth_data_source.dart';
import '../data_source/remote_auth_data_source.dart';

class AuthRepositoryImp extends AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;
  final RemoteAuthDataSource remoteAuthDataSource;
  AuthRepositoryImp({
    required this.firebaseAuthDataSource,
    required this.remoteAuthDataSource,
  });

  @override
  Future<Either<Failure, UserCredential>> signUp(SignUpParams params) async {
    try {
      if (!params.agreeTermsAndCondition) {
        return Left(
          ServerFailure(
            'Please confirm that you agree to the Terms and Conditions to proceed.',
          ),
        );
      }

      /// 1️⃣ Create user in Firebase Auth
      final UserCredential userCredential =
      await firebaseAuthDataSource.registerEmailIdAndPasswordInFirebaseAuth(
        userName: '',
        phoneNumber: '',
        emailId: params.emailId,
        password: params.password,
      );

      final user = userCredential.user;

      if (user == null) {
        return Left(ServerFailure('User creation failed'));
      }

      /// 2️⃣ Store user in your backend DB
      final response = await remoteAuthDataSource.storeUserInDb(
        uid: user.uid,
        email: params.emailId,
        userName: params.userName,
        phoneNumber: params.phoneNumber,
      );

      /// 3️⃣ If DB success → return success
      if (response['status'] == 200) {
        return Right(userCredential);
      }

      /// 4️⃣ If DB fails → delete Firebase user (rollback)
      await _deleteFirebaseUser(user);

      return Left(
        ServerFailure(response['message'] ?? 'User already exists'),
      );
    } catch (e) {
      return Left(ServerFailure('Signup failed: $e'));
    }
  }

  Future<void> _deleteFirebaseUser(User user) async {
    try {
      await user.delete();
    } catch (e) {
      // optional: log to crashlytics
      debugPrint('Failed to delete Firebase user: $e');
    }
  }
}