import 'package:logger/logger.dart';

import 'api_routes.dart';
import 'data/basic_response.dart';
import 'dio_setup.dart';

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
          '${ApiRoutes.sendEmail}?userEmail=$userEmail&subject=$subject&body=$message');

      return BasicResponse.fromJson(response.data);
    } catch (e) {
      logger.e('Error sending email: $e');
      return BasicResponse(
        success: false,
        message: 'Error sending email: $e',
      );
    }
  }
}
