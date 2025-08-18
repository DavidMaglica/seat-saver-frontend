import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/utils/animations.dart';

class WebRatingsPageModel extends ChangeNotifier {
  final int ownerId;

  WebRatingsPageModel({required this.ownerId});

  final VenueApi venueApi = VenueApi();

  final Map<String, AnimationInfo> animationsMap =
      Animations.homepageAnimations;

  Timer? _refreshTimer;

  Map<int, Map<int, int>> ratingsByVenueId = {};
  Map<int, String> venueNamesById = {};

  bool isLoading = true;

  void init() {
    fetchData(ownerId);

    // _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
    //   fetchData(ownerId);
    // });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchData(int ownerId) async {
    isLoading = true;
    notifyListeners();

    final venues = await venueApi.getVenuesByOwner(ownerId);

    for (final venue in venues.content) {
      final ratings = await venueApi.getAllVenueRatings(venue.id);
      venueNamesById[venue.id] = venue.name;

      final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      for (final r in ratings) {
        final ratingInt = r.rating.toInt().clamp(1, 5);
        counts[ratingInt] = (counts[ratingInt] ?? 0) + 1;
      }

      ratingsByVenueId[venue.id] = counts;
    }

    isLoading = false;
    notifyListeners();
  }
}
