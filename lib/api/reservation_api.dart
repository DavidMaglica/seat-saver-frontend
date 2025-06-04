import 'package:TableReserver/api/api_routes.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/api/data/reservation_details.dart';
import 'package:TableReserver/api/dio_setup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final dio = setupDio(ApiRoutes.reservation);
final logger = Logger();

class ReservationApi {
  Future<List<ReservationDetails>> getReservations(int userId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getReservations,
        queryParameters: {'userId': userId},
      );

      debugPrint('Response data: ${response.data}');

      List<ReservationDetails> reservations = (response.data as List)
          .map((reservation) => ReservationDetails.fromJson(reservation))
          .toList();

      return reservations;
    } catch (e) {
      logger.e('Error fetching reservations: $e');
      return [];
    }
  }

  Future<BasicResponse> createReservation(
    int userId,
    int venueId,
    int numberOfPeople,
    DateTime reservationDate,
  ) async {
    try {
      Response response = await dio.post(
        ApiRoutes.createReservation,
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

  Future<BasicResponse> deleteReservation(
    int userId,
    int reservationId,
  ) async {
    try {
      Response response = await dio.delete(
        ApiRoutes.deleteReservation,
        queryParameters: {
          'userId': userId,
          'reservationId': reservationId,
        },
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
