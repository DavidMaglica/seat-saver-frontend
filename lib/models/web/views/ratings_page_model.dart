import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/utils/animations.dart';

class WebRatingsPageModel extends ChangeNotifier {
  final int ownerId;
  final VenuesApi venuesApi;

  WebRatingsPageModel({required this.ownerId, VenuesApi? venuesApi})
    : venuesApi = venuesApi ?? VenuesApi();

  final Map<String, AnimationInfo> animationsMap =
      Animations.utilityPagesAnimations;

  int? selectedInterval = null;
  Timer? _refreshTimer;

  Map<int, Map<int, int>> ratingsByVenueId = {};
  Map<int, String> venueNamesById = {};

  bool isLoading = true;

  void init() {
    fetchData(ownerId);

    startTimer();
  }

  void startTimer() {
    _refreshTimer?.cancel();
    if (selectedInterval == null) {
      return;
    }

    _refreshTimer = Timer.periodic(Duration(seconds: selectedInterval!), (
      timer,
    ) {
      fetchData(ownerId);
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchData(int ownerId) async {
    isLoading = true;
    notifyListeners();

    final venues = await venuesApi.getVenuesByOwner(ownerId);

    for (final venue in venues.content) {
      final ratings = await venuesApi.getAllVenueRatings(venue.id);
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
