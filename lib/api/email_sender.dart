import 'data/basic_response.dart';
import 'dio_setup.dart';

final dio = setupDio('/email-sender');

class EmailSender {
  Future<BasicResponse> sendEmail(
    String userEmail,
    String subject,
    String message,
  ) async {
    var response = await dio.post(
      '/send-email',
      data: {
        'userEmail': userEmail,
        'subject': subject,
        'message': message,
      },
    );

    return BasicResponse.fromJson(response.data);
  }
}
