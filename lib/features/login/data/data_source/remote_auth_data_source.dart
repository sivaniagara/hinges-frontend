
import '../../../../core/network/http_service.dart';

abstract class RemoteAuthDataSource{
  Future<Map<String, dynamic>> storeUserInDb({
    required String uid,
    required String email,
    required String userName,
    required String phoneNumber,
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
      'http://192.168.1.90:8000/user/login',
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
}