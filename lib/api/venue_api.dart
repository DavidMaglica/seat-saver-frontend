import 'dart:convert';
import 'dart:typed_data';

import 'package:table_reserver/api/api_routes.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/rating.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/data/venue_type.dart';
import 'package:table_reserver/api/dio_setup.dart';
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

  Future<PagedResponse<Venue>> getAllVenues(
    int page,
    int size,
    String? searchQuery,
    List<int>? typeIds,
  ) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'size': size,
      };

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        queryParams['searchQuery'] = searchQuery.trim();
      }

      if (typeIds != null && typeIds.isNotEmpty) {
        queryParams['typeIds'] = typeIds;
      }

      final Response response = await dio.get(
        ApiRoutes.getAllVenues,
        queryParameters: queryParams,
      );

      return PagedResponse.fromJson(
        response.data,
        (json) => Venue.fromJson(json),
      );
    } catch (e) {
      logger.e('Error fetching all venues: $e');
      return PagedResponse<Venue>(
        content: [],
        page: 0,
        size: 0,
        totalElements: 0,
        totalPages: 0,
      );
    }
  }

  Future<PagedResponse<Venue>> getNearbyVenuesNew({
    int page = 0,
    int size = 15,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenuesByCategory,
        queryParameters: {
          'category': 'nearby',
          'page': page,
          'size': size,
        },
      );

      return PagedResponse.fromJson(
        response.data,
        (json) => Venue.fromJson(json),
      );
    } catch (e) {
      logger.e('Error fetching nearby venues: $e');
      return PagedResponse<Venue>(
        content: [],
        page: 0,
        size: 0,
        totalElements: 0,
        totalPages: 0,
      );
    }
  }

  Future<PagedResponse<Venue>> getTrendingVenuesNew({
    int page = 0,
    int size = 10,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenuesByCategory,
        queryParameters: {
          'category': 'trending',
          'page': page,
          'size': size,
        },
      );

      return PagedResponse.fromJson(
        response.data,
        (json) => Venue.fromJson(json),
      );
    } catch (e) {
      logger.e('Error fetching trending venues: $e');
      return PagedResponse<Venue>(
        content: [],
        page: 0,
        size: 0,
        totalElements: 0,
        totalPages: 0,
      );
    }
  }

  Future<PagedResponse<Venue>> getNewVenuesNew({
    int page = 0,
    int size = 10,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenuesByCategory,
        queryParameters: {
          'category': 'new',
          'page': page,
          'size': size,
        },
      );

      return PagedResponse.fromJson(
        response.data,
        (json) => Venue.fromJson(json),
      );
    } catch (e) {
      logger.e('Error fetching new venues: $e');
      return PagedResponse<Venue>(
        content: [],
        page: 0,
        size: 0,
        totalElements: 0,
        totalPages: 0,
      );
    }
  }

  Future<PagedResponse<Venue>> getSuggestedVenuesNew({
    int page = 0,
    int size = 10,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.getVenuesByCategory,
        queryParameters: {
          'category': 'suggested',
          'page': page,
          'size': size,
        },
      );

      return PagedResponse.fromJson(
        response.data,
        (json) => Venue.fromJson(json),
      );
    } catch (e) {
      logger.e('Error fetching suggested venues: $e');
      return PagedResponse<Venue>(
        content: [],
        page: 0,
        size: 0,
        totalElements: 0,
        totalPages: 0,
      );
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
