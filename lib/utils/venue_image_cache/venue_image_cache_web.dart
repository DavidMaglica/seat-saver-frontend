import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:table_reserver/utils/logger.dart';

class VenueImageCache {
  static final Map<int, Uint8List> _cache = {};

  static Uint8List? getImage(int venueId) {
    if (_cache.containsKey(venueId)) return _cache[venueId];

    final encoded = html.window.localStorage['venue_$venueId'];
    if (encoded != null) {
      final bytes = base64Decode(encoded);
      _cache[venueId] = bytes;
      return bytes;
    }
    return null;
  }

  static void setImage(int venueId, Uint8List imageBytes) {
    _cache[venueId] = imageBytes;
    if (imageBytes.lengthInBytes < 3 * 1024 * 1024) {
      final encoded = base64Encode(imageBytes);
      try {
        html.window.localStorage['venue_$venueId'] = encoded;
      } catch (e) {
        logger.e('Error saving image to local storage: $e');
      }
    }
  }

  static void clear({bool clearLocalStorage = false}) {
    _cache.clear();
    if (clearLocalStorage) {
      html.window.localStorage.clear();
    }
  }
}
