import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../error/failure.dart';
import 'websocket_service.dart';

class WebSocketServiceImpl implements WebSocketService {
  WebSocket? _socket;

  @override
  Stream<dynamic> get stream =>
      _socket?.map((event) => jsonDecode(event)) ??
          const Stream.empty();

  @override
  Future<Either<Failure, void>> connect(String url) async {
    try {
      _socket = await WebSocket.connect(url);
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
