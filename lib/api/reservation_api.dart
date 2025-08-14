import 'package:dio/dio.dart';
import 'package:table_reserver/utils/logger.dart';
import 'package:table_reserver/api/common/api_routes.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/common/dio_setup.dart';

final dio = setupDio();

class ReservationApi {
  Future<List<ReservationDetails>> getUserReservations(int userId) async {
    try {
      Response response = await dio.get(ApiRoutes.userReservations(userId));

      List<ReservationDetails> reservations = (response.data as List)
          .map((reservation) => ReservationDetails.fromJson(reservation))
          .toList();

      return reservations;
    } catch (e) {
      logger.e('Error fetching reservations: $e');
      return [];
    }
  }

  Future<List<ReservationDetails>> getOwnerReservations(int ownerId) async {
    try {
      Response response = await dio.get(ApiRoutes.ownerReservations(ownerId));

      List<ReservationDetails> reservations = (response.data as List)
          .map((reservation) => ReservationDetails.fromJson(reservation))
          .toList();

      return reservations;
    } catch (e) {
      logger.e('Error fetching reservations: $e');
      return [];
    }
  }

  Future<BasicResponse> createReservation({
    required int userId,
    required int venueId,
    required int numberOfPeople,
    required DateTime reservationDate,
  }) async {
    try {
      Response response = await dio.post(
        ApiRoutes.reservations,
        data: {
          'userId': userId,
          'venueId': venueId,
          'reservationDate': reservationDate.toIso8601String(),
          'numberOfPeople': numberOfPeople,
        },
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error creating reservation: $e');
      return BasicResponse(
        success: false,
        message: 'Failed to create reservation',
      );
    }
  }

  Future<BasicResponse> deleteReservation(int userId, int reservationId) async {
    try {
      Response response = await dio.delete(
        ApiRoutes.reservations,
        queryParameters: {'userId': userId, 'reservationId': reservationId},
      );
      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error deleting reservation: $e');
      return BasicResponse(
        success: false,
        message: 'Failed to delete reservation',
      );
    }
  }
}
