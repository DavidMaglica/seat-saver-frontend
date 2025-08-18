import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/models/web/side_nav_model.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/pages/web/views/landing.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/sign_up_methods.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class HomepageModel extends FlutterFlowModel<WebHomepage> with ChangeNotifier {
  final int ownerId;

  HomepageModel({required this.ownerId});

  final AccountApi accountApi = AccountApi();
  final ReservationApi reservationApi = ReservationApi();
  final VenueApi venueApi = VenueApi();

  final Map<String, AnimationInfo> animationsMap =
      Animations.homepageAnimations;

  final List<String> headers = [
    'Name',
    'Location',
    'Working Hours',
    'Max. capacity',
    'Avail. capacity',
    'Rating',
  ];
  List<Venue> venues = [];

  int lastMonthReservationsCount = 0;
  int nextMonthReservationsCount = 0;
  int totalReservationsCount = 0;

  int totalReviewsCount = 0;
  double overallRating = 0;

  double overallUtilisationRate = 0;

  Timer? _refreshTimer;

  @override
  void initState(BuildContext context) {}

  void init(BuildContext context) {
    _setUserToSharedPreferences(context, ownerId);
    _fetchAll(context);

    // _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
    //   _fetchAll(context);
    // });
  }

  void _fetchAll(BuildContext context) {
    fetchVenues(context);
    _fetchReservationData();
    _fetchReviewsData();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _setUserToSharedPreferences(
    BuildContext context,
    int ownerId,
  ) async {
    UserResponse? response = await accountApi.getUser(ownerId);
    if (response != null && response.success && response.user != null) {
      User user = response.user!;
      await prefsWithCache.setString('userEmail', user.email);
      await prefsWithCache.setString('userName', user.username);
      Provider.of<SideNavModel>(context, listen: false).getUserFromCache();
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(
        context,
        'Error happened while logging you in. Please try again later.¬',
      );
      prefsWithCache.clear();
      currentAuthMethod = AuthenticationMethod.none;
      Navigator.of(context).pushReplacement(
        FadeInRoute(page: const WebLanding(), routeName: Routes.webLanding),
      );
    }
  }

  Future<void> fetchVenues(BuildContext context) async {
    try {
      PagedResponse<Venue> fetchedVenues = await venueApi.getVenuesByOwner(
        ownerId,
        size: 50,
      );
      if (fetchedVenues.items.isNotEmpty) {
        venues.clear();
        venues.addAll(fetchedVenues.items);
        notifyListeners();
      } else {
        if (!context.mounted) return;
        WebToaster.displayInfo(context, 'No venues found for this owner.');
      }
    } catch (e) {
      if (!context.mounted) return;
      WebToaster.displayError(context, 'Error fetching venues: $e');
    }
  }

  Future<void> _fetchReservationData() async {
    totalReservationsCount = await reservationApi.getReservationCount(ownerId);

    lastMonthReservationsCount = await reservationApi.getReservationCount(
      ownerId,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
    );

    nextMonthReservationsCount = await reservationApi.getReservationCount(
      ownerId,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
    );
    notifyListeners();
  }

  Future<void> _fetchReviewsData() async {
    totalReviewsCount = await venueApi.getVenueRatingsCount(ownerId);
    overallRating = await venueApi.getOverallRating(ownerId);
    overallUtilisationRate = await venueApi.getVenueUtilisationRate(ownerId);
    notifyListeners();
  }
}
