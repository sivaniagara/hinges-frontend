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

      UserCredential userCredential;

      try {
        /// 1️⃣ Try creating Firebase user
        userCredential =
        await firebaseAuthDataSource.registerEmailIdAndPasswordInFirebaseAuth(
          userName: '',
          phoneNumber: '',
          emailId: params.emailId,
          password: params.password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {

          /// 2️⃣ If user already exists → sign in instead
          userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: params.emailId,
            password: params.password,
          );
        } else {
          return Left(ServerFailure(e.message ?? 'Signup failed'));
        }
      }

      final user = userCredential.user;

      if (user == null) {
        return Left(ServerFailure('User creation failed'));
      }

      /// 3️⃣ Store user in backend DB
      final response = await remoteAuthDataSource.storeUserInDb(
        uid: user.uid,
        email: params.emailId,
        userName: params.userName,
        phoneNumber: params.phoneNumber,
      );

      if (response['status'] == 200) {
        return Right(userCredential);
      }

      return Left(
        ServerFailure(response['message'] ?? 'Failed to store user'),
      );

    } catch (e) {
      return Left(ServerFailure('Signup failed: $e'));
    }
  }


  Future<void> _deleteFirebaseUser(
      User user,
      String email,
      String password,
      ) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // Reauthenticate
      await user.reauthenticateWithCredential(credential);

      // Delete user
      await user.delete();
    } catch (e) {
      debugPrint('Failed to delete Firebase user: $e');
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await firebaseAuthDataSource.forgotPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    try {
      final userCredential = await firebaseAuthDataSource.signInWithGoogle();
      return Right(userCredential);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInAnonymously() async {
    try {
      final userCredential = await firebaseAuthDataSource.signInAnonymously();
      return Right(userCredential);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserDetailsInDb({
    required String userId,
    required String userName,
    String? userEmailId,
    required String userMobileNumber,
    required int authProvider,
    String? profilePath,
    required DateTime createdAt,
  }) async {
    try {
      final response = await remoteAuthDataSource.updateUserDetails(
        userId: userId,
        userName: userName,
        userEmailId: userEmailId,
        userMobileNumber: userMobileNumber,
        authProvider: authProvider,
        profilePath: profilePath,
        createdAt: createdAt,
      );
      if (response['status'] == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure(response['message'] ?? 'Failed to update user details'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncGuestUser({required String userId, required String userName}) async {
    try {
      final response = await remoteAuthDataSource.syncGuestUser(userId: userId, userName: userName);
      if (response['status'] == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure(response['message'] ?? 'Failed to sync guest user'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
