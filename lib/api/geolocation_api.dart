import 'package:TableReserver/api/api_routes.dart';
import 'package:TableReserver/api/data/user_location.dart';
import 'package:TableReserver/api/dio_setup.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final dio = setupDio(ApiRoutes.geolocation);
final logger = Logger();

class GeolocationApi {
  Future<List<String>> getNearbyCities(UserLocation userLocation) async {
    try {
      var response = await dio.get(
        ApiRoutes.getNearbyCities,
        queryParameters: {
          'latitude': userLocation.latitude,
          'longitude': userLocation.longitude
        },
        options: Options(
          validateStatus: (status) =>
              status != null && status < 600,
        ),
      );

      if (response.statusCode == 200) {
        return List<String>.from(response.data);
      } else {
        logger.e('Non-200 response: ${response.statusCode} - ${response.data}');
        return [];
      }
    } catch (e) {
      logger.e('Error fetching nearby cities: $e');
      return [];
    }
  }
}
