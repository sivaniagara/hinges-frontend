import 'package:hinges_frontend/features/home/utils/home_urls.dart';

import '../../../../core/network/http_service.dart';
import '../models/user_data_model.dart';

abstract class HomeRemoteDataSource {
  Future<UserDataModel> getUserData(String firebaseId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HttpService httpService;

  HomeRemoteDataSourceImpl({required this.httpService});

  @override
  Future<UserDataModel> getUserData(String firebaseId) async {
    // Assuming the endpoint is /user/details?firebase_id=...
    // You should update this with your actual endpoint URL
    final response = await httpService.post(
      HomeUrls.fetchHome,
      body: {
        'fire_base_id': firebaseId,
      },
    );

    if (response['status'] == 200) {
      return UserDataModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch user data');
    }
  }
}
