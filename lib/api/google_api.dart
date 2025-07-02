import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final logger = Logger();
final dio = Dio();
const String apiKey = 'AIzaSyDKUhrw-G6ZZBVz3vSVe9DzuidgasMvcYM';

class GoogleApi {
  Future<String?> getPlaceId(String city) async {
    const url = 'https://places.googleapis.com/v1/places:searchText?fields=*';
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': 'places.displayName,places.placeId',
    };

    try {
      Response response = await dio.post(
        url,
        options: Options(headers: headers),
        data: {
          'textQuery': city,
          'includedType': 'locality',
        },
      );

      if (response.data == null ||
          response.data['places'] == null ||
          response.data['places'].isEmpty) {
        return null;
      }

      String placeId = response.data['places'][0]['id'];
      return placeId;
    } catch (e) {
      logger.e('Error fetching place IDs: $e');
      return null;
    }
  }

  Future<String?> getPhotoReference(String? placeId) async {
    if (placeId == null || placeId.isEmpty) {
      return null;
    }

    final url = 'https://places.googleapis.com/v1/places/$placeId';
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': 'photos',
    };

    try {
      Response response = await dio.get(
        url,
        options: Options(headers: headers),
      );

      if (response.data == null ||
          response.data['photos'] == null ||
          response.data['photos'].isEmpty) {
        return null;
      }

      String photoReference = response.data['photos'][0]['name'];

      return photoReference;
    } catch (e) {
      logger.e('Error fetching image: $e');
      return null;
    }
  }

  Future<String?> getImage(String? photoReference) async {
    if (photoReference == null || photoReference.isEmpty) {
      return null;
    }

    final url =
        'https://places.googleapis.com/v1/$photoReference/media?maxHeightPx=800&maxWidthPx=800&skipHttpRedirect=true';

    final headers = {
      'X-Goog-Api-Key': apiKey,
      'Content-Type': 'application/json',
    };

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
        ),
      );

      if (response.data == null ||
          response.data['photoUri'] == null ||
          response.data['photoUri'].isEmpty) {
        return null;
      }

      String imageUrl = response.data['photoUri'];
      return imageUrl;
    } catch (e) {
      logger.e('Error fetching image: $e');
      return null;
    }
  }
}
