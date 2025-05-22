import 'package:TableReserver/api/data/user_location.dart';
import 'package:logger/logger.dart';

import 'dio_setup.dart';

final dio = setupDio('/geolocation');
final logger = Logger();

class GeolocationApi {
  Future<List<String>> getNearbyCities(UserLocation userLocation) async {
    try {
      var response = await dio.get(
          '/get-nearby-cities?latitude=${userLocation.latitude}&longitude=${userLocation.longitude}');

      return List<String>.from(response.data);
    } catch (e) {
      logger.e('Error fetching nearby cities: $e');
      return [];
    }
  }
}
