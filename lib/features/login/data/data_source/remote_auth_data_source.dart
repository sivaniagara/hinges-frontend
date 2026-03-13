import 'package:hinges_frontend/features/login/utils/login_urls.dart';
import '../../../../core/network/http_service.dart';

abstract class RemoteAuthDataSource{
  Future<Map<String, dynamic>> storeUserInDb({
    required String uid,
    required String email,
    required String userName,
    required String phoneNumber,
  });

  Future<Map<String, dynamic>> updateUserDetails({
    required String userId,
    required String userName,
    String? userEmailId,
    required String userMobileNumber,
    required int authProvider,
    String? profilePath,
    required DateTime createdAt,
  });
}

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final HttpService httpService;

  RemoteAuthDataSourceImpl({required this.httpService});

  @override
  Future<Map<String, dynamic>> storeUserInDb({
    required String uid,
    required String email,
    required String userName,
    required String phoneNumber,
  }) async {
    final response = await httpService.post(
      LoginUrls.signUp,
      body: {
        "fire_base_id": uid,
        "user_email_id": email,
        "user_name": userName,
        "user_mobile_number": phoneNumber,
        "auth_provider": 1,
        "created_at": DateTime.now().toUtc().toIso8601String(),
      },
    );
    return response;
  }

  @override
  Future<Map<String, dynamic>> updateUserDetails({
    required String userId,
    required String userName,
    String? userEmailId,
    required String userMobileNumber,
    required int authProvider,
    String? profilePath,
    required DateTime createdAt,
  }) async {
    final response = await httpService.post(
      LoginUrls.signUp, // Reusing signUp endpoint if it handles both or use a specific update endpoint if available. Based on prompt, sending data to backend.
      body: {
        "user_id": userId,
        "user_name": userName,
        "user_email_id": userEmailId,
        "user_mobile_number": userMobileNumber,
        "auth_provider": authProvider,
        "profile_path": profilePath,
        "created_at": createdAt.toUtc().toIso8601String(),
      },
    );
    return response;
  }
}
