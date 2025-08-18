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

    await Future.delayed(const Duration(seconds: 10));
    // Fetch ratings data for the owner
    isLoading = false;
    notifyListeners();
  }
}
