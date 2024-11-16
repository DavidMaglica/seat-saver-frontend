import 'package:dio/dio.dart';

Dio setupDio(String subPath) => Dio(
      BaseOptions(
        baseUrl: 'http://192.168.100.15:8080/$subPath',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );
