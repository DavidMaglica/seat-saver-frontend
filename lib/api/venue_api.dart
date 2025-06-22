import 'dart:convert';
import 'dart:typed_data';

import 'package:TableReserver/api/api_routes.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/api/data/rating.dart';
import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/api/data/venue_type.dart';
import 'package:TableReserver/api/dio_setup.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final dio = setupDio(ApiRoutes.venue);
final logger = Logger();

class VenueApi {
  Future<Venue?> getVenue(int venueId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenue,
        queryParameters: {
          'venueId': venueId,
        },
      );

      return Venue.fromJson(response.data);
    } catch (e) {
      logger.e('Error fetching venue: $e');
      return null;
    }
  }

  Future<List<Venue>> getAllVenues() async {
    Response response = await dio.get(ApiRoutes.getAllVenues);
    List<Venue> venues =
        (response.data as List).map((venue) => Venue.fromJson(venue)).toList();
    return venues;
  }

  Future<List<Venue>> getNearbyVenues() async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenuesByCategory,
        queryParameters: {
          'category': 'nearby',
        },
      );
      List<Venue> nearbyVenues = (response.data as List)
          .map((venue) => Venue.fromJson(venue))
          .toList();

      nearbyVenues.sort((a, b) => a.location.compareTo(b.location));
      return nearbyVenues;
    } catch (e) {
      logger.e('Error fetching nearby venues: $e');
      return [];
    }
  }

  Future<List<Venue>> getTrendingVenues() async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenuesByCategory,
        queryParameters: {
          'category': 'trending',
        },
      );
      List<Venue> trendingVenues = (response.data as List)
          .map((venue) => Venue.fromJson(venue))
          .toList();

      trendingVenues.sort((a, b) => b.rating.compareTo(a.rating));
      return trendingVenues;
    } catch (e) {
      logger.e('Error fetching trending venues: $e');
      return [];
    }
  }

  Future<List<Venue>> getNewVenues() async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenuesByCategory,
        queryParameters: {
          'category': 'new',
        },
      );
      List<Venue> newVenues = (response.data as List)
          .map((venue) => Venue.fromJson(venue))
          .toList();

      return newVenues;
    } catch (e) {
      logger.e('Error fetching new venues: $e');
      return [];
    }
  }

  Future<List<Venue>> getSuggestedVenues() async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenuesByCategory,
        queryParameters: {
          'category': 'suggested',
        },
      );
      List<Venue> suggestedVenues = (response.data as List)
          .map((venue) => Venue.fromJson(venue))
          .toList();

      return suggestedVenues;
    } catch (e) {
      logger.e('Error fetching suggested venues: $e');
      return [];
    }
  }

  Future<String?> getVenueType(int typeId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenueType,
        queryParameters: {'typeId': typeId},
      );

      return response.data;
    } catch (e) {
      logger.e('Error fetching venue type: $e');
      return null;
    }
  }

  Future<List<VenueType>> getAllVenueTypes() async {
    try {
      Response response = await dio.get(ApiRoutes.getAllVenueTypes);
      List<VenueType> types = (response.data as List)
          .map((type) => VenueType.fromJson(type))
          .toList();
      return types;
    } catch (e) {
      logger.e('Error fetching venue types: $e');
      return [];
    }
  }

  Future<double?> getVenueRating(int venueId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenueRating,
        queryParameters: {
          'venueId': venueId,
        },
      );

      return response.data;
    } catch (e) {
      logger.e('Error fetching venue rating: $e');
      return null;
    }
  }

  Future<List<Rating>> getAllVenueRatings(int venueId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getAllVenueRatings,
        queryParameters: {
          'venueId': venueId,
        },
      );

      List<Rating> ratings = (response.data as List)
          .map((rating) => Rating.fromJson(rating))
          .toList();

      return ratings;
    } catch (e) {
      logger.e('Error fetching venue ratings: $e');
      return [];
    }
  }

  Future<BasicResponse> rateVenue(
    int venueId,
    double rating,
    int userId,
    String comment,
  ) async {
    try {
      Response response = await dio.post(
        ApiRoutes.rateVenue,
        queryParameters: {
          'venueId': venueId,
          'rating': rating,
          'userId': userId,
          'comment': comment,
        },
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error rating venue: $e');
      return BasicResponse(success: false, message: 'Error rating venue');
    }
  }

  Future<List<Uint8List>> getVenueImages(int venueId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenueImages,
        queryParameters: {
          'venueId': venueId,
        },
      );

      List<Uint8List> images = (response.data as List)
          .map((base64Str) => base64Decode(base64Str as String))
          .toList();

      return images;
    } catch (e) {
      logger.e('Error fetching venue images: $e');
      return [];
    }
  }

  Future<List<Uint8List>> getMenuImages(int venueId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenueMenuImages,
        queryParameters: {
          'venueId': venueId,
        },
      );

      List<Uint8List> images = (response.data as List)
          .map((base64Str) => base64Decode(base64Str as String))
          .toList();

      return images;
    } catch (e) {
      logger.e('Error fetching menu images: $e');
      return [];
    }
  }
}
