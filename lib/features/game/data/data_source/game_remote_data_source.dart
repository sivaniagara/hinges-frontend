import '../../../../core/network/http_service.dart';
import '../../utils/game_urls.dart';
import '../models/game_data_model.dart';

abstract class GameRemoteDataSource {
  Future<GameDataModel> getGameData(Map<String, dynamic> jsonData);
}

class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  final HttpService httpService;

  GameRemoteDataSourceImpl({required this.httpService});

  @override
  Future<GameDataModel> getGameData(Map<String, dynamic> jsonData) async {
    try{
      print("going to get gameData.....");
      final response = await httpService.post(
          GameUrls.joinMatch,
          body: {
            "user_id" : jsonData['userId'],
            "auction_category_id": jsonData['auctionCategoryId']
          }
      );

      // Assuming the API returns the JSON structure directly or wrapped in a data field
      // Based on previous patterns, let's assume it's direct or we handle the wrapper
      print("getGameData response => $response");
      return GameDataModel.fromJson(response['data']);
    }catch(e, stackTrace){
      print('getGameData error => $e');
      print('getGameData stackTrace => $stackTrace');
      rethrow;
    }

  }
}
