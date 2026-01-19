import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/fire_store_auth_data_source.dart';
import '../data_source/firebase_auth_data_source.dart';

class AuthRepositoryImp extends AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;
  final FireStoreAuthDataSource fireStoreAuthDataSource;

  AuthRepositoryImp({
    required this.firebaseAuthDataSource,
    required this.fireStoreAuthDataSource,
  });

  @override
  Future<Either<Failure, UserCredential>> signUp({
    required String userName,
    required String phoneNumber,
    required String emailId,
    required String password,
    required bool agreeTermsAndCondition,
  }) async {
    try {
      if (!agreeTermsAndCondition) {
        return Left(ServerFailure(
            'Please confirm that you agree to the Terms and Conditions to proceed.'));
      }

      // Register in Firebase Auth
      UserCredential userCredential =
      await firebaseAuthDataSource.registerEmailIdAndPasswordInFirebaseAuth(
          emailId, password);

      return Right(userCredential);
    } catch (e) {
      if (kDebugMode) {
        print('Firebase email auth error: ${e.toString()}');
      }
      return Left(ServerFailure('Firebase Auth failed: ${e.toString()}'));
    }
  }
}