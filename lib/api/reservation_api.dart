import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'api_routes.dart';
import 'data/api_reservation_details.dart';
import 'data/basic_response.dart';
import 'dio_setup.dart';

final dio = setupDio(ApiRoutes.reservation);
final logger = Logger();

class ReservationApi {
  Future<List<APIReservationDetails>> getReservations(String userEmail) async {
    try {
      Response response =
          await dio.get('${ApiRoutes.getReservations}?email=$userEmail');
      List<APIReservationDetails> reservations = (response.data as List)
          .map((reservation) => APIReservationDetails.fromJson(reservation))
          .toList();

      return reservations;
    } catch (e) {
      logger.e('Error fetching reservations: $e');
      return [];
    }
  }

  Future<BasicResponse> createReservation(
    String userEmail,
    int venueId,
    int numberOfPeople,
    DateTime reservationDate,
  ) async {
    try {
      Response response = await dio.post(ApiRoutes.createReservation, data: {
        'userEmail': userEmail,
        'venueId': venueId,
        'reservationDate': reservationDate.toIso8601String(),
        'numberOfPeople': numberOfPeople,
      });

      return BasicResponse.fromJson(response.data);
    } catch (e) {
      logger.e('Error creating reservation: $e');
      return BasicResponse(
        success: false,
        message: 'Failed to create reservation',
      );
    }
  }

  Future<BasicResponse> deleteReservation(
    String email,
    int reservationId,
  ) async {
    try {
      Response response = await dio.delete(
          '${ApiRoutes.deleteReservation}?email=$email&reservationId=$reservationId');
      return BasicResponse.fromJson(response.data);
    } catch (e) {
      logger.e('Error deleting reservation: $e');
      return BasicResponse(
        success: false,
        message: 'Failed to delete reservation',
      );
    }
  }
}
