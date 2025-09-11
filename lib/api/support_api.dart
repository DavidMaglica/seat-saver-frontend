import 'package:dio/dio.dart';
import 'package:seat_saver/api/common/api_routes.dart';
import 'package:seat_saver/api/common/dio_setup.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/utils/logger.dart';

class SupportApi {
  final Dio dio;

  SupportApi({Dio? dio}) : dio = dio ?? setupDio();

  Future<BasicResponse> sendEmail(
    String userEmail,
    String subject,
    String message,
  ) async {
    try {
      var response = await dio.post(
        ApiRoutes.sendEmail,
        queryParameters: {
          'userEmail': userEmail,
          'subject': subject,
          'body': message,
        },
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error sending email: $e');
      return BasicResponse(success: false, message: 'Error sending email: $e');
    }
  }
}
