import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future<List<String>> getNearbyCities(Position position) async {
  List<String> nearbyCities = [];
  final List<String> mocked = [
    'Zagreb',
    'Split',
    'Rijeka',
    'Osijek',
    'Dubrovnik'
  ];

  try {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/location/nearby?latitude=${position.latitude}&longitude=${position.longitude}'));

//     {
//       "error_message" : "You must enable Billing on the Google Cloud Project at https://console.cloud.google.com/project/_/billing/enable Learn more at https://developers.google.com/maps/gmp-get-started",
//       "html_attributions" : [],
//       "results" : [],
//       "status" : "REQUEST_DENIED"
//      }

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      for (final city in data) {
        nearbyCities.add(city['name']);
      }
      return nearbyCities;
    } else {
      print('Failed to fetch nearby cities: ${response.statusCode}');
      return mocked;
    }
  } catch (e) {
    print('Error fetching nearby cities: $e');
    return mocked;
  }
}
