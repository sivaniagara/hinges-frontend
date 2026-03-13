import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class UpdateUserDetailsParams {
  final String userId;
  final String userName;
  final String? userEmailId;
  final String userMobileNumber;
  final int authProvider;
  final String? profilePath;
  final DateTime createdAt;

  UpdateUserDetailsParams({
    required this.userId,
    required this.userName,
    this.userEmailId,
    required this.userMobileNumber,
    required this.authProvider,
    this.profilePath,
    required this.createdAt,
  });
}

class UpdateUserDetailsUseCase implements UseCase<void, UpdateUserDetailsParams> {
  final AuthRepository repository;

  UpdateUserDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserDetailsParams params) async {
    return await repository.updateUserDetailsInDb(
      userId: params.userId,
      userName: params.userName,
      userEmailId: params.userEmailId,
      userMobileNumber: params.userMobileNumber,
      authProvider: params.authProvider,
      profilePath: params.profilePath,
      createdAt: params.createdAt,
    );
  }
}
