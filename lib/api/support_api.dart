import 'package:table_reserver/api/api_routes.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/dio_setup.dart';
import 'package:logger/logger.dart';

final dio = setupDio(ApiRoutes.support);
final logger = Logger();

class SupportApi {
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
      return BasicResponse(
        success: false,
        message: 'Error sending email: $e',
      );
    }
  }
}
