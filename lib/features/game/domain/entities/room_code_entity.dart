import 'package:equatable/equatable.dart';

class RoomCodeEntity extends Equatable {
  final String roomCode;

  const RoomCodeEntity({required this.roomCode});

  @override
  List<Object?> get props => [roomCode];
}
