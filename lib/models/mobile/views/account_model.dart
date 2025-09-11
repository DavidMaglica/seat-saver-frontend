import 'package:flutter/material.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/pages/mobile/settings/edit_profile.dart';
import 'package:seat_saver/pages/mobile/settings/notification_settings.dart';
import 'package:seat_saver/pages/mobile/settings/reservation_history.dart';
import 'package:seat_saver/pages/mobile/settings/support.dart';
import 'package:seat_saver/pages/mobile/settings/terms_of_service.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';
import 'package:seat_saver/utils/toaster.dart';

class AccountModel extends ChangeNotifier {
  final int? userId;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();
  final int pageIndex = 3;

  User? currentUser;
  final AccountApi accountApi;

  AccountModel({this.userId, AccountApi? accountApi})
      : accountApi = accountApi ?? AccountApi();

  Future<void> init() async {
    if (userId != null) {
      await _getUser(userId!);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> _getUser(int userId) async {
    final response = await accountApi.getUser(userId);
    if (response != null && response.success) {
      currentUser = response.user;
      notifyListeners();
    }
  }

  void openSettingsItem(BuildContext context, String route, String? action) {
    switch (route) {
      case Routes.termsOfService:
        Navigator.of(context).push(
          MobileFadeInRoute(page: const TermsOfService(), routeName: route),
        );
        break;

      case Routes.editProfile:
        if (currentUser == null) {
          Toaster.displayInfo(context, 'Please log in to $action.');
          return;
        } else {
          Navigator.of(context).push(
            MobileFadeInRoute(
              page: EditProfile(userId: currentUser!.id),
              routeName: route,
            ),
          );
          return;
        }

      case Routes.notificationSettings:
        if (currentUser == null) {
          Toaster.displayInfo(context, 'Please log in to $action.');
          return;
        } else {
          Navigator.of(context).push(
            MobileFadeInRoute(
              page: NotificationSettings(userId: currentUser!.id),
              routeName: route,
            ),
          );
          return;
        }

      case Routes.support:
        if (currentUser == null) {
          Toaster.displayInfo(context, 'Please log in to $action.');
          return;
        } else {
          Navigator.of(context).push(
            MobileFadeInRoute(
              page: Support(userId: currentUser!.id),
              routeName: route,
            ),
          );
          return;
        }

      case Routes.reservationHistory:
        if (currentUser == null) {
          Toaster.displayInfo(
            context,
            'Please log in to $action.',
          );
          return;
        } else {
          Navigator.of(context).push(
            MobileFadeInRoute(
              page: ReservationHistory(userId: currentUser!.id),
              routeName: route,
            ),
          );
          return;
        }

      default:
        Toaster.displayInfo(context, 'Page not found.');
        return;
    }
  }
}
