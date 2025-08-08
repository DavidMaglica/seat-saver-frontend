import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/pages/web/views/account.dart';
import 'package:table_reserver/pages/web/views/landing.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class AccountModel extends FlutterFlowModel<WebAccount> with ChangeNotifier {
  int? numberOfReservations;
  int? venuesOwned;

  final Map<String, AnimationInfo> animationsMap = Animations.accountAnimations;

  @override
  void initState(BuildContext context) {
    _fetchReservationsCount();
    _fetchVenuesOwnedCount();
  }

  void init() {
    _fetchReservationsCount();
    _fetchVenuesOwnedCount();
  }

  Future<void> _fetchReservationsCount() async {
    numberOfReservations = 5;
    notifyListeners();
  }

  Future<void> _fetchVenuesOwnedCount() async {
    venuesOwned = 2;
    notifyListeners();
  }

  Future<void> logOut(BuildContext context) async {
    Navigator.of(
      context,
    ).push(FadeInRoute(page: const WebLanding(), routeName: Routes.webLanding));
  }
}
