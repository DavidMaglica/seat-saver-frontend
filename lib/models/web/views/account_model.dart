import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:seat_saver/api/reservation_api.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/pages/web/views/account.dart';
import 'package:seat_saver/pages/web/views/landing.dart';
import 'package:seat_saver/utils/animations.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';
import 'package:seat_saver/utils/sign_up_methods.dart';
import 'package:seat_saver/utils/web_toaster.dart';

class AccountModel extends FlutterFlowModel<WebAccount> with ChangeNotifier {
  int? numberOfReservations;
  int? venuesOwned;

  int get ownerId => sharedPreferencesCache.getInt('ownerId')!;

  ReservationsApi reservationsApi;
  VenuesApi venuesApi;

  AccountModel({ReservationsApi? reservationsApi, VenuesApi? venuesApi})
    : reservationsApi = reservationsApi ?? ReservationsApi(),
      venuesApi = venuesApi ?? VenuesApi();

  final Map<String, AnimationInfo> animationsMap = Animations.accountAnimations;

  @override
  void initState(BuildContext context) {}

  void init() {
    _fetchReservationsCount();
    _fetchVenuesOwnedCount();
  }

  Future<void> _fetchReservationsCount() async {
    numberOfReservations = await reservationsApi.getReservationCount(ownerId);
    notifyListeners();
  }

  Future<void> _fetchVenuesOwnedCount() async {
    venuesOwned = await venuesApi.getVenueCountByOwner(ownerId);
    notifyListeners();
  }

  Future<void> logOut(BuildContext context) async {
    switch (currentAuthMethod) {
      case AuthenticationMethod.google:
        sharedPreferencesCache.clear();
        await googleSignIn.signOut();
        redirectToLanding(context);
        return;
      case AuthenticationMethod.custom:
        sharedPreferencesCache.clear();
        redirectToLanding(context);
        return;
      case AuthenticationMethod.none:
        if (!context.mounted) return;
        WebToaster.displayError(
          context,
          'Failed to log out. Please try again.',
        );
        return;
    }
  }

  void redirectToLanding(BuildContext context) {
    if (!context.mounted) return;
    currentAuthMethod = AuthenticationMethod.none;
    Navigator.of(context).pushReplacement(
      FadeInRoute(page: const WebLanding(), routeName: Routes.webLanding),
    );
  }
}
