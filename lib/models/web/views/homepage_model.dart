import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/paged_response.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/reservation_api.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/models/web/components/side_nav_model.dart';
import 'package:seat_saver/pages/web/views/homepage.dart';
import 'package:seat_saver/pages/web/views/landing.dart';
import 'package:seat_saver/pages/web/views/ratings_page.dart';
import 'package:seat_saver/pages/web/views/reservations_graphs_page.dart';
import 'package:seat_saver/utils/animations.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';
import 'package:seat_saver/utils/sign_up_methods.dart';
import 'package:seat_saver/utils/web_toaster.dart';

class HomepageModel extends FlutterFlowModel<WebHomepage> with ChangeNotifier {
  final int ownerId;
  final AccountApi accountApi;
  final ReservationsApi reservationsApi;
  final VenuesApi venuesApi;

  HomepageModel({
    required this.ownerId,
    AccountApi? accountApi,
    ReservationsApi? reservationsApi,
    VenuesApi? venuesApi,
  }) : accountApi = accountApi ?? AccountApi(),
       reservationsApi = reservationsApi ?? ReservationsApi(),
       venuesApi = venuesApi ?? VenuesApi();

  final Map<String, AnimationInfo> animationsMap =
      Animations.homepageAnimations;

  final List<String> headers = [
    'Name',
    'Location',
    'Max. capacity',
    'Avail. capacity',
    'Rating',
  ];
  ValueNotifier<bool> isLoadingTable = ValueNotifier<bool>(false);
  List<Venue> venues = [];

  int lastMonthReservationsCount = 0;
  int nextMonthReservationsCount = 0;
  int totalReservationsCount = 0;

  int totalReviewsCount = 0;
  double overallRating = 0;

  double overallUtilisationRate = 0;

  Venue? bestPerformingVenue;
  Venue? worstPerformingVenue;

  int? selectedInterval = null;
  Timer? _refreshTimer;

  @override
  void initState(BuildContext context) {}

  void init(BuildContext context) {
    _setUserToSharedPreferences(context, ownerId);
    fetchData(context);

    startTimer(context);
  }

  void fetchData(BuildContext context) {
    fetchVenues(context);
    _fetchReservationData();
    _fetchReviewsData();
  }

  void startTimer(context) {
    _refreshTimer?.cancel();
    if (selectedInterval == null) {
      return;
    }

    _refreshTimer = Timer.periodic(Duration(seconds: selectedInterval!), (_) {
      fetchData(context);
    });
    notifyListeners();
  }

  @override
  void dispose() {
    isLoadingTable.dispose();
    venues.clear();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _setUserToSharedPreferences(
    BuildContext context,
    int ownerId,
  ) async {
    BasicResponse<User?> response = await accountApi.getUser(ownerId);
    if (response.success && response.data != null) {
      User user = response.data!;
      await sharedPreferencesCache.setString('ownerEmail', user.email);
      await sharedPreferencesCache.setString('ownerName', user.username);
      Provider.of<SideNavModel>(context, listen: false).getUserFromCache();
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(
        context,
        'Error happened while logging you in. Please try again later.¬',
      );
      sharedPreferencesCache.clear();
      currentAuthMethod = AuthenticationMethod.none;
      Navigator.of(context).pushReplacement(
        FadeInRoute(page: const WebLanding(), routeName: Routes.webLanding),
      );
    }
  }

  Future<void> fetchVenues(BuildContext context) async {
    isLoadingTable = ValueNotifier<bool>(true);
    notifyListeners();
    PagedResponse<Venue> pagedVenues = await venuesApi.getVenuesByOwner(
      ownerId,
      size: 50,
    );

    venues.clear();
    if (pagedVenues.items.isNotEmpty) {
      venues.addAll(pagedVenues.items);
      isLoadingTable = ValueNotifier<bool>(false);
      if (pagedVenues.items.length > 1) {
        bestPerformingVenue = pagedVenues.items.reduce(
          (a, b) => a.rating > b.rating ? a : b,
        );
        worstPerformingVenue = pagedVenues.items
            .where((venue) => venue.id != bestPerformingVenue!.id)
            .reduce((a, b) => a.rating < b.rating ? a : b);
      } else {
        bestPerformingVenue = null;
        worstPerformingVenue = null;
      }

      notifyListeners();
      return;
    }

    isLoadingTable = ValueNotifier<bool>(false);
    notifyListeners();
  }

  Future<void> _fetchReservationData() async {
    totalReservationsCount = await reservationsApi.getReservationCount(ownerId);

    lastMonthReservationsCount = await reservationsApi.getReservationCount(
      ownerId,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
    );

    nextMonthReservationsCount = await reservationsApi.getReservationCount(
      ownerId,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
    );
    notifyListeners();
  }

  Future<void> _fetchReviewsData() async {
    totalReviewsCount = await venuesApi.getVenueRatingsCount(ownerId);
    overallRating = await venuesApi.getOverallRating(ownerId);
    overallUtilisationRate = await venuesApi.getVenueUtilisationRate(ownerId);
    notifyListeners();
  }

  Function() goToRatingsPage(BuildContext context) {
    return () {
      if (venues.isNotEmpty) {
        Navigator.of(context).push(
          FadeInRoute(
            page: WebRatingsPage(ownerId: ownerId),
            routeName: '${Routes.webRatingsPage}?ownerId=$ownerId',
          ),
        );
      } else {
        WebToaster.displayInfo(
          context,
          'You have no venues registered yet. Register a venues first to view details.',
        );
      }
    };
  }

  Function() goToReservationsGraphsPage(BuildContext context) {
    return () {
      if (venues.isNotEmpty) {
        Navigator.of(context).push(
          FadeInRoute(
            page: ReservationsGraphsPage(ownerId: ownerId),
            routeName: '${Routes.webReservationsGraphs}?ownerId=$ownerId',
          ),
        );
      } else {
        WebToaster.displayInfo(
          context,
          'You have no venues registered yet. Register a venues first to view details.',
        );
      }
    };
  }
}
