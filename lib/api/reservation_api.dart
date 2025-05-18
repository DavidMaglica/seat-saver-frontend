import 'package:dio/dio.dart';

import 'api_routes.dart';
import 'data/basic_response.dart';
import 'data/reservation_details.dart';
import 'dio_setup.dart';

final dio = setupDio(ApiRoutes.reservation);

class ReservationApi {
  Future<List<ReservationDetailsFromApi>> getReservationsFromApi(
      String userEmail) async {
    Response response =
        await dio.get('${ApiRoutes.getReservations}?email=$userEmail');
    List<ReservationDetailsFromApi> reservations = (response.data as List)
        .map((reservation) => ReservationDetailsFromApi.fromJson(reservation))
        .toList();

    return reservations;
  }

  Future<BasicResponse> addReservationToApi(
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
      return BasicResponse(
        success: false,
        message: 'Failed to create reservation',
      );
    }
  }
}
