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
  Future<List<String>> getImages() async {
    final List<String> mocked = [
      'https://images.unsplash.com/photo-1528114039593-4366cc08227d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8aXRhbHl8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
      'https://images.unsplash.com/photo-1571492811573-16dccc6f21f8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxyZXN0YXVyYW50JTIwb3V0c2lkZXxlbnwwfHx8fDE3MTk1MDk4NTB8MA&ixlib=rb-4.0.3&q=80&w=1080',
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxyZXN0YXVyYW50fGVufDB8fHx8MTcxOTQ4NjQ0M3ww&ixlib=rb-4.0.3&q=80&w=1080',
      'https://images.unsplash.com/photo-1551024506-0bccd828d307?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyM3x8ZGVzc2VydCUyMGZpbmV8ZW58MHx8fHwxNzE5NTA5ODIyfDA&ixlib=rb-4.0.3&q=80&w=1080',
      'https://images.unsplash.com/photo-1616671285410-2a676a9a433d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxmaW5lJTIwZGluaW5nfGVufDB8fHx8MTcxOTUwOTc4OHww&ixlib=rb-4.0.3&q=80&w=1080',
      'https://images.unsplash.com/photo-1623073284788-0d846f75e329?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHxmaW5lJTIwZGluaW5nfGVufDB8fHx8MTcxOTUwOTc4OHww&ixlib=rb-4.0.3&q=80&w=1080',
      'https://images.unsplash.com/photo-1592861956120-e524fc739696?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxMXx8cmVzdGF1cmFudHxlbnwwfHx8fDE3MTk0ODY0NDN8MA&ixlib=rb-4.0.3&q=80&w=1080',
    ];
    return mocked;
  }

  final List<String> mockedPlaceholderImages = [
    'assets/images/carousel/placeholder.jpg',
    'assets/images/carousel/placeholder.jpg',
    'assets/images/carousel/placeholder.jpg',
    'assets/images/carousel/placeholder.jpg'
  ];

  Map<String, List<String>> mockedImages = {
    'Trattoria Bellissimo': [
      'assets/images/venue_images/spinnaker_1.jpg',
      'assets/images/venue_images/spinnaker_2.jpg',
      'assets/images/venue_images/spinnaker_3.jpg',
      'assets/images/venue_images/spinnaker_4.jpg',
      'assets/images/venue_images/spinnaker_5.jpg',
      'assets/images/venue_images/spinnaker_6.jpg',
      'assets/images/venue_images/spinnaker_7.jpg',
    ],
    'Tequila': [
      'assets/images/venue_images/tequila_1.jpg',
      'assets/images/venue_images/tequila_2.jpg',
      'assets/images/venue_images/tequila_3.jpg',
      'assets/images/venue_images/tequila_4.jpg',
      'assets/images/venue_images/tequila_5.jpg',
      'assets/images/venue_images/tequila_6.jpg',
      'assets/images/venue_images/tequila_7.jpg',
      'assets/images/venue_images/tequila_8.jpg',
    ],
    'La Carraia': [
      'assets/images/venue_images/laCarraia_1.jpg',
      'assets/images/venue_images/laCarraia_2.jpg',
      'assets/images/venue_images/laCarraia_3.jpg',
      'assets/images/venue_images/laCarraia_4.jpg',
    ],
    'Dei Neri': [
      'assets/images/venue_images/deiNeri_1.jpg',
      'assets/images/venue_images/deiNeri_2.jpg',
      'assets/images/venue_images/deiNeri_3.jpg',
      'assets/images/venue_images/deiNeri_4.jpg',
      'assets/images/venue_images/deiNeri_5.jpg',
    ],
    'Chang': [
      'assets/images/venue_images/chang_1.png',
      'assets/images/venue_images/chang_2.jpg',
      'assets/images/venue_images/chang_3.jpg',
      'assets/images/venue_images/chang_4.jpg',
      'assets/images/venue_images/chang_5.jpg',
      'assets/images/venue_images/chang_6.jpg',
      'assets/images/venue_images/chang_7.jpg',
      'assets/images/venue_images/chang_8.jpg',
      'assets/images/venue_images/chang_9.jpg',
      'assets/images/venue_images/chang_10.jpg',
    ],
    'Umi': [
      'assets/images/venue_images/umi_1.jpg',
      'assets/images/venue_images/umi_2.jpg',
      'assets/images/venue_images/umi_3.jpg',
      'assets/images/venue_images/umi_4.jpg',
      'assets/images/venue_images/umi_5.jpg',
      'assets/images/venue_images/umi_6.jpg',
      'assets/images/venue_images/umi_7.jpg',
      'assets/images/venue_images/umi_8.jpg'
    ],
    'Tsuki': [
      'assets/images/venue_images/tsuki_1.jpg',
      'assets/images/venue_images/tsuki_2.jpg',
      'assets/images/venue_images/tsuki_3.jpg',
      'assets/images/venue_images/tsuki_4.jpg',
      'assets/images/venue_images/tsuki_5.jpg',
    ],
    'Bacchus': [
      'assets/images/venue_images/bacchus_1.jpg',
      'assets/images/venue_images/bacchus_2.jpg',
      'assets/images/venue_images/bacchus_3.jpg',
      'assets/images/venue_images/bacchus_4.jpg',
      'assets/images/venue_images/bacchus_5.jpg',
      'assets/images/venue_images/bacchus_6.jpg',
      'assets/images/venue_images/bacchus_7.jpg',
    ],
  };

  List<String> getVenueImages(String venueName) {
    if (mockedImages.containsKey(venueName)) {
      if (mockedImages[venueName]!.isEmpty) {
        return mockedPlaceholderImages;
      }
      return mockedImages[venueName]!;
    } else {
      return mockedPlaceholderImages;
    }
  }

  // NON MOCKED API CALLS START HERE
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
}
