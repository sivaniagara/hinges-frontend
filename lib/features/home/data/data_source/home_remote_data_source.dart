import 'package:hinges_frontend/features/home/utils/home_urls.dart';

import '../../../../core/network/http_service.dart';
import '../models/user_data_model.dart';

abstract class HomeRemoteDataSource {
  Future<UserDataModel> getUserData(String firebaseId);
  Future<void> increaseUserCoins(String userId, int coins);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HttpService httpService;

  HomeRemoteDataSourceImpl({required this.httpService});

  @override
  Future<UserDataModel> getUserData(String firebaseId) async {
    try{
      final response = await httpService.post(
        HomeUrls.fetchHome,
        body: {
          'fire_base_id': firebaseId,
        },
      );

      if (response['status'] == 200) {
        print("getUserData response => $response");
        return UserDataModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch user data');
      }
    }catch(e, stackTrace){
      print("error : $e");
      print("stackTrace : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<void> increaseUserCoins(String userId, int coins) async {
    try {
      final response = await httpService.post(
        HomeUrls.increaseUserCoins,
        body: {
          'user_id': userId,
          'coins': coins,
        },
      );

      if (response['status'] != 200) {
        throw Exception(response['message'] ?? 'Failed to update user coins');
      }
    } catch (e) {
      print("error increasing coins : $e");
      rethrow;
    }
  }
}
