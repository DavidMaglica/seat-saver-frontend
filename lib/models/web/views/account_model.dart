import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/views/account.dart';
import 'package:table_reserver/pages/web/views/landing.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/sign_up_methods.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class AccountModel extends FlutterFlowModel<WebAccount> with ChangeNotifier {
  int? numberOfReservations;
  int? venuesOwned;

  int get ownerId => prefsWithCache.getInt('ownerId')!;

  ReservationsApi reservationsApi = ReservationsApi();
  VenuesApi venuesApi = VenuesApi();

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
        prefsWithCache.clear();
        await googleSignIn.signOut();
        redirectToLanding(context);
        return;
      case AuthenticationMethod.custom:
        prefsWithCache.clear();
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
