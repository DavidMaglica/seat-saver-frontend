import 'package:TableReserver/api/api_routes.dart';
import 'package:TableReserver/api/data/user_location.dart';
import 'package:TableReserver/api/dio_setup.dart';
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
      );

      return List<String>.from(response.data);
    } catch (e) {
      logger.e('Error fetching nearby cities: $e');
      return [];
    }
  }
}
