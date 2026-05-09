import '../../domain/entities/room_code_entity.dart';

class RoomCodeModel extends RoomCodeEntity {
  const RoomCodeModel({required super.roomCode});

  factory RoomCodeModel.fromJson(Map<String, dynamic> json) {
    return RoomCodeModel(
      roomCode: json['roomCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
    };
  }
}
