import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../error/failure.dart';
import 'websocket_service.dart';

class WebSocketServiceImpl implements WebSocketService {
  WebSocket? _socket;
  // final String ipAddress = 'wss://api.hingesgames.com/';
  final String ipAddress = 'ws://139.59.39.124:8000/';
  // static final String ipAddress = 'ws://192.168.1.112:8000/'; // local
  @override
  Stream<dynamic> get stream =>
      _socket?.map((event) => jsonDecode(event)) ??
          const Stream.empty();

  @override
  Future<Either<Failure, void>> connect(String url) async {
    try {
      print('$ipAddress$url');
      _socket = await WebSocket.connect('$ipAddress$url');

      _socket!.done.then((_) {
        print("Socket closed from server");
      });
      return const Right(null);
    } catch (e) {
      return Left(WebSocketFailure(e.toString()));
    }
  }


  @override
  void send(dynamic data) {
    if (_socket != null) {
      _socket!.add(jsonEncode(data));
    }
  }

  @override
  Future<void> disconnect() async {
    await _socket?.close();
    _socket = null;
  }
}
