import 'package:dio/dio.dart';

Dio setupDio() {
  return Dio(
    BaseOptions(
      baseUrl: 'http://<backend-address>:<backend-port>',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );
}
