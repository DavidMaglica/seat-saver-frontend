import 'package:dio/dio.dart';

Dio setupDio() {
  return Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.2:8085',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );
}
