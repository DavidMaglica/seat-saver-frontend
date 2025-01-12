import 'package:TableReserver/api/data/user_location.dart';

import 'dio_setup.dart';

final dio = setupDio('/geolocation');

Future<List<String>> getNearbyCities(UserLocation userLocation) async {
  var response = await dio.get(
      '/get-nearby-cities?latitude=${userLocation.latitude}&longitude=${userLocation.longitude}');

  return List<String>.from(response.data);
}
