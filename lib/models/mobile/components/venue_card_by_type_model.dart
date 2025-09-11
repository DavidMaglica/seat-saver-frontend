import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/venue_api.dart';

class VenueCardByTypeModel extends ChangeNotifier {
  final BuildContext context;
  final Venue venue;
  final String venueType;

  Uint8List? venueImage;

  VenuesApi venuesApi = VenuesApi();

  VenueCardByTypeModel({
    required this.context,
    required this.venue,
    required this.venueType,
  });

  Future<void> init() async {
    await _loadVenueImage();
    notifyListeners();
  }

  Future<void> _loadVenueImage() async {
    List<Uint8List> venueImages = await venuesApi.getVenueImages(venue.id);
    if (venueImages.isNotEmpty) {
      venueImage = venueImages.first;
    } else {
      venueImage = null;
    }
  }
}
