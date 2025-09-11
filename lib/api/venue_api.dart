import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:seat_saver/api/common/api_routes.dart';
import 'package:seat_saver/api/common/dio_setup.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/paged_response.dart';
import 'package:seat_saver/api/data/rating.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/data/venue_type.dart';
import 'package:seat_saver/utils/logger.dart';

class VenuesApi {
  final Dio dio;

  VenuesApi({Dio? dio}) : dio = dio ?? setupDio();

  Future<Venue?> getVenue(int venueId) async {
    try {
      Response response = await dio.get(ApiRoutes.venueById(venueId));

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
      final Map<String, dynamic> queryParams = {'page': page, 'size': size};

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        queryParams['searchQuery'] = searchQuery.trim();
      }

      if (typeIds != null && typeIds.isNotEmpty) {
        queryParams['typeIds'] = typeIds;
      }

      final Response response = await dio.get(
        ApiRoutes.venues,
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

  Future<PagedResponse<Venue>> getVenuesByOwner(
    int ownerId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.venuesByOwnerId(ownerId),
        queryParameters: {'page': page, 'size': size},
      );

      return PagedResponse.fromJson(
        response.data,
        (json) => Venue.fromJson(json),
      );
    } catch (e) {
      logger.e('Error fetching venues by owner: $e');
      return PagedResponse<Venue>(
        content: [],
        page: 0,
        size: 0,
        totalElements: 0,
        totalPages: 0,
      );
    }
  }

  Future<int> getVenueCountByOwner(int ownerId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.venuesCountByOwnerId(ownerId),
      );

      return response.data as int;
    } catch (e) {
      logger.e('Error fetching venue count by owner: $e');
      return 0;
    }
  }

  Future<PagedResponse<Venue>> getNearbyVenues(
    double? latitude,
    double? longitude, {
    int page = 0,
    int size = 15,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.venues,
        queryParameters: {
          'category': 'nearby',
          'page': page,
          'size': size,
          'latitude': latitude,
          'longitude': longitude,
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

  Future<PagedResponse<Venue>> getTrendingVenues({
    int page = 0,
    int size = 10,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.venues,
        queryParameters: {'category': 'trending', 'page': page, 'size': size},
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

  Future<PagedResponse<Venue>> getNewVenues({
    int page = 0,
    int size = 10,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.venues,
        queryParameters: {'category': 'new', 'page': page, 'size': size},
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

  Future<PagedResponse<Venue>> getSuggestedVenues({
    int page = 0,
    int size = 10,
  }) async {
    try {
      Response response = await dio.get(
        ApiRoutes.venues,
        queryParameters: {'category': 'suggested', 'page': page, 'size': size},
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
      Response response = await dio.get(ApiRoutes.venueType(typeId));

      return response.data;
    } catch (e) {
      logger.e('Error fetching venue type: $e');
      return null;
    }
  }

  Future<List<VenueType>> getAllVenueTypes() async {
    try {
      Response response = await dio.get(ApiRoutes.allVenueTypes);
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
      Response response = await dio.get(ApiRoutes.venueAverageRating(venueId));

      return response.data;
    } catch (e) {
      logger.e('Error fetching venue rating: $e');
      return null;
    }
  }

  Future<List<Rating>> getAllVenueRatings(int venueId) async {
    try {
      Response response = await dio.get(ApiRoutes.allVenueRatings(venueId));

      List<Rating> ratings = (response.data as List)
          .map((rating) => Rating.fromJson(rating))
          .toList();

      return ratings;
    } catch (e) {
      logger.e('Error fetching venue ratings: $e');
      return [];
    }
  }

  Future<int> getVenueRatingsCount(int ownerId) async {
    try {
      Response response = await dio.get(ApiRoutes.venueRatingsCount(ownerId));

      return response.data as int;
    } catch (e) {
      logger.e('Error fetching venue ratings count: $e');
      return 0;
    }
  }

  Future<double> getOverallRating(int ownerId) async {
    try {
      Response response = await dio.get(ApiRoutes.overallRating(ownerId));

      return response.data as double;
    } catch (e) {
      logger.e('Error fetching overall rating: $e');
      return 0.0;
    }
  }

  Future<double> getVenueUtilisationRate(int ownerId) async {
    try {
      Response response = await dio.get(
        ApiRoutes.venueUtilisationRate(ownerId),
      );

      return response.data as double;
    } catch (e) {
      logger.e('Error fetching venue utilisation rate: $e');
      return 0.0;
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
        ApiRoutes.rateVenue(venueId),
        queryParameters: {
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

  Future<BasicResponse> uploadVenueImage(
    int venueId,
    Uint8List imageBytes,
    String filename,
  ) async {
    try {
      String mimeType = filename.endsWith('.png')
          ? 'image/png'
          : filename.endsWith('.jpg') || filename.endsWith('.jpeg')
          ? 'image/jpeg'
          : 'application/octet-stream';

      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await dio.post(
        ApiRoutes.venueImages(venueId),
        data: formData,
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error uploading venue image: $e');
      return BasicResponse(
        success: false,
        message: 'Error uploading venue image',
      );
    }
  }

  Future<BasicResponse> uploadMenuImage(
    int venueId,
    Uint8List imageBytes,
    String filename,
  ) async {
    try {
      String mimeType = filename.endsWith('.png')
          ? 'image/png'
          : filename.endsWith('.jpg') || filename.endsWith('.jpeg')
          ? 'image/jpeg'
          : 'application/octet-stream';

      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await dio.post(
        ApiRoutes.menuImages(venueId),
        data: formData,
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error uploading menu image: $e');
      return BasicResponse(
        success: false,
        message: 'Error uploading menu image',
      );
    }
  }

  Future<Uint8List?> getVenueHeaderImage(int venueId) async {
    try {
      Response response = await dio.get(ApiRoutes.venueHeaderImage(venueId));

      if (response.data['data'] is String) {
        return base64Decode(response.data['data'] as String);
      } else if (response.data is Uint8List) {
        return response.data as Uint8List;
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Error fetching venue header image: $e');
      return null;
    }
  }

  Future<List<Uint8List>> getVenueImages(int venueId) async {
    try {
      Response response = await dio.get(ApiRoutes.venueImages(venueId));

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
      Response response = await dio.get(ApiRoutes.menuImages(venueId));

      List<Uint8List> images = (response.data as List)
          .map((base64Str) => base64Decode(base64Str as String))
          .toList();

      return images;
    } catch (e) {
      logger.e('Error fetching menu images: $e');
      return [];
    }
  }

  Future<BasicResponse<int>> createVenue({
    required int ownerId,
    required String name,
    required String location,
    required int maximumCapacity,
    required int typeId,
    required List<int> workingDays,
    required String workingHours,
    String? description,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'ownerId': ownerId,
        'name': name,
        'location': location,
        'maximumCapacity': maximumCapacity,
        'typeId': typeId,
        'workingDays': workingDays,
        'workingHours': workingHours,
        'description': description,
      };

      Response response = await dio.post(ApiRoutes.venues, data: data);

      final int? venueId = response.data['data'] as int?;

      if (venueId == null) {
        return BasicResponse(
          success: false,
          message: 'Failed to create venue. Please try again.',
        );
      }

      return BasicResponse<int>(
        success: true,
        message: 'Venue created successfully.',
        data: venueId,
      );
    } catch (e) {
      logger.e('Error creating venue: $e');
      return BasicResponse(success: false, message: 'Error creating venue');
    }
  }

  Future<BasicResponse> editVenue({
    required int venueId,
    String? name,
    String? location,
    int? maximumCapacity,
    int? typeId,
    List<int>? workingDays,
    String? workingHours,
    String? description,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'location': location,
        'maximumCapacity': maximumCapacity,
        'typeId': typeId,
        'workingDays': workingDays,
        'workingHours': workingHours,
        'description': description,
      };

      Response response = await dio.patch(
        ApiRoutes.venueById(venueId),
        data: data,
      );

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error editing venue: $e');
      return BasicResponse(success: false, message: 'Error editing venue');
    }
  }

  Future<BasicResponse> deleteVenue(int venueId) async {
    try {
      Response response = await dio.delete(ApiRoutes.venueById(venueId));

      return BasicResponse.fromJson(response.data, (json) => json);
    } catch (e) {
      logger.e('Error deleting venue: $e');
      return BasicResponse(
        success: false,
        message: 'Error deleting venue. Please try again later.',
      );
    }
  }
}
