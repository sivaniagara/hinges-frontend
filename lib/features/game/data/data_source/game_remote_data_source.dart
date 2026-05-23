import '../../../../core/network/http_service.dart';
import '../../utils/game_urls.dart';
import '../models/game_data_model.dart';
import '../models/room_code_model.dart';

abstract class GameRemoteDataSource {
  Future<GameDataModel> getGameData(Map<String, dynamic> jsonData);
  Future<void> exitMatch(Map<String, dynamic> jsonData);
  Future<RoomCodeModel> getRoomCode();
}

class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  final HttpService httpService;

  GameRemoteDataSourceImpl({required this.httpService});

  @override
  Future<GameDataModel> getGameData(Map<String, dynamic> jsonData) async {
    try{
      print("going to get gameData.....");
      print("jsonData => ${jsonData}");
      final response = await httpService.post(
          GameUrls.joinMatch,
          body: {
            "user_id" : jsonData['userId'],
            "user_name" : jsonData['userName'],
            "auction_category_id": jsonData['auctionCategoryId'],
            "match_type": jsonData['matchType'],
            "room_code": jsonData['roomCode'],
            "host_id": jsonData['hostId'],
          }
      );

      print("getGameData response => $response");
      return GameDataModel.fromJson(response['data']);
    }catch(e, stackTrace){
      print('getGameData error => $e');
      print('getGameData stackTrace => $stackTrace');
      rethrow;
    }

  }

  @override
  Future<void> exitMatch(Map<String, dynamic> jsonData) async {
    try {
      await httpService.post(
        GameUrls.exitMatch,
        body: {
          "user_id": jsonData['user_id'],
          "match_id": jsonData['match_id'],
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RoomCodeModel> getRoomCode() async {
    try {
      final response = await httpService.get(GameUrls.getRoomCode);
      return RoomCodeModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
