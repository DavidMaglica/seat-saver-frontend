import 'package:dio/dio.dart';

Dio setupDio(String subPath) => Dio(
      BaseOptions(
        baseUrl: 'http://192.168.100.30:8085/$subPath',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );
