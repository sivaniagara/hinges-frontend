import 'package:dartz/dartz.dart';
import '../error/failure.dart';

abstract class WebSocketService {
  Future<Either<Failure, void>> connect(String url);

  void send(dynamic data);

  Stream<dynamic> get stream;

  Future<void> disconnect();
}
