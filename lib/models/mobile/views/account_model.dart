import 'package:flutter/material.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/pages/mobile/settings/edit_profile.dart';
import 'package:table_reserver/pages/mobile/settings/notification_settings.dart';
import 'package:table_reserver/pages/mobile/settings/reservation_history.dart';
import 'package:table_reserver/pages/mobile/settings/support.dart';
import 'package:table_reserver/pages/mobile/settings/terms_of_service.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/toaster.dart';

class AccountModel extends ChangeNotifier {
  final BuildContext context;
  final int? userId;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();
  final int pageIndex = 3;

  User? currentUser;
  final AccountApi accountApi = AccountApi();

  AccountModel({required this.context, this.userId});

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

  void openSettingsItem(String route, String? action) {
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
            'Please log in to view your reservation history.',
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
