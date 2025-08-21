import 'dart:typed_data';

class VenueImageCache {
  static final Map<int, Uint8List> _cache = {};

  static Uint8List? getImage(int venueId) => _cache[venueId];

  static void setImage(int venueId, Uint8List imageBytes) {
    _cache[venueId] = imageBytes;
  }

  static void invalidate(int venueId) {
    _cache.remove(venueId);
  }

  static void clear({bool clearLocalStorage = false}) {
    _cache.clear();
  }
}
