import 'package:dio/dio.dart';
import 'package:table_reserver/api/common/api_routes.dart';
import 'package:table_reserver/api/common/dio_setup.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/utils/logger.dart';

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

  Future<ReservationDetails?> getReservationById(int reservationId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.reservationById(reservationId),
      );

      return ReservationDetails.fromJson(response.data);
    } catch (e) {
      logger.e('Error fetching reservation by ID: $e');
      return null;
    }
  }

  Future<List<ReservationDetails>> getVenueReservations(int venueId) async {
    try {
      Response response = await dio.get(ApiRoutes.venueReservations(venueId));

      List<ReservationDetails> reservations = (response.data as List)
          .map((reservation) => ReservationDetails.fromJson(reservation))
          .toList();

      return reservations;
    } catch (e) {
      logger.e('Error fetching venue reservations: $e');
      return [];
    }
  }

  Future<int> getReservationCount(
    int ownerId, {
    int? venueId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.reservationCount(ownerId),
        queryParameters: {
          'venueId': venueId,
          'startDate': startDate?.toIso8601String(),
          'endDate': endDate?.toIso8601String(),
        },
      );

      return response.data as int;
    } catch (e) {
      logger.e('Error fetching reservation count: $e');
      return 0;
    }
  }

  Future<BasicResponse> createReservation({
    required int venueId,
    required int numberOfGuests,
    required DateTime reservationDate,
    int? userId,
    String? userEmail,
  }) async {
    try {
      Response response = await dio.post(
        ApiRoutes.reservations,
        data: {
          'userId': userId,
          'userEmail': userEmail,
          'venueId': venueId,
          'reservationDate': reservationDate.toIso8601String(),
          'numberOfGuests': numberOfGuests,
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

  Future<BasicResponse> updateReservation({
    required int reservationId,
    required int numberOfGuests,
    required DateTime reservationDate,
  }) async {
    try {
      Response response = await dio.patch(
        ApiRoutes.reservationById(reservationId),
        data: {
          'reservationDate': reservationDate.toIso8601String(),
          'numberOfGuests': numberOfGuests,
        },
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error updating reservation: $e');
      return BasicResponse(
        success: false,
        message: 'Failed to update reservation',
      );
    }
  }

  Future<BasicResponse> deleteReservation(int reservationId) async {
    try {
      Response response = await dio.delete(
        ApiRoutes.reservationById(reservationId),
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
