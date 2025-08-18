import 'dart:typed_data';

import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:flutter/cupertino.dart';

class VenueCardByTypeModel extends ChangeNotifier {
  final BuildContext context;
  final Venue venue;
  final String venueType;

  Uint8List? venueImage;

  VenueApi venueApi = VenueApi();

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
    List<Uint8List> venueImages = await venueApi.getVenueImages(venue.id);
    if (venueImages.isNotEmpty) {
      venueImage = venueImages.first;
    } else {
      venueImage = null;
    }
  }
}
