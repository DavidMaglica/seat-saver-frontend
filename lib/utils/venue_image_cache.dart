import 'dart:typed_data';

class VenueImageCache {
  static final Map<int, Uint8List> _cache = {};

  static Uint8List? getImage(int venueId) {
    return _cache[venueId];
  }

  static void setImage(int venueId, Uint8List imageUrl) {
    _cache[venueId] = imageUrl;
  }

  static void clear() {
    _cache.clear();
  }
}