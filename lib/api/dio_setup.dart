import 'package:dio/dio.dart';

Dio setupDio(String subPath) => Dio(
      BaseOptions(
        baseUrl: 'http://172.20.10.2:8080/$subPath',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );
