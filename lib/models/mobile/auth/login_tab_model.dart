import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/mobile/auth/log_in_tab.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/toaster.dart';
import 'package:table_reserver/utils/utils.dart';

import '../../../utils/routes.dart';

class LogInTabModel extends FlutterFlowModel<LogInTab> with ChangeNotifier {
  final AccountApi accountApi = AccountApi();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  String? emailErrorText;
  String? passwordErrorText;

  @override
  void initState(BuildContext context) {
    googleSignIn.attemptLightweightAuthentication();
  }

  Future<void> logIn(
    BuildContext context,
    String userEmail,
    String password,
  ) async {
    if (!_validateFields(userEmail, password)) return;

    BasicResponse<int?> response = await accountApi.logIn(userEmail, password);

    if (response.success && response.data != null) {
      int userId = response.data!;

      UserResponse? userResponse = await accountApi.getUser(userId);

      User user = userResponse!.user!;

      sharedPreferencesCache.setInt('userId', user.id);

      Position? lastKnownLocation = getPositionFromLatAndLong(
        user.lastKnownLatitude,
        user.lastKnownLongitude,
      );

      if (lastKnownLocation != null) {
        await sharedPreferencesCache.setString(
          'lastKnownLocation',
          jsonEncode({
            'lat': lastKnownLocation.latitude,
            'lng': lastKnownLocation.longitude,
          }),
        );
      }

      _goToHomepage(context, user.id, lastKnownLocation);
    } else {
      if (!context.mounted) return;
      Toaster.displayError(context, response.message);
    }
  }

  void _goToHomepage(BuildContext context, int userId, Position? userLocation) {
    Navigator.of(context).push(
      MobileFadeInRoute(
        page: const Homepage(),
        routeName: Routes.homepage,
        arguments: {'userId': userId, 'userLocation': userLocation},
      ),
    );
  }

  bool _validateFields(String email, String password) {
    bool isValid = true;
    if (email.isEmpty) {
      emailErrorText = 'Email cannot be empty';
      isValid = false;
    } else if (!emailRegex.hasMatch(email)) {
      emailErrorText = 'Please enter a valid email address';
      isValid = false;
    } else {
      emailErrorText = null;
    }

    if (password.isEmpty) {
      passwordErrorText = 'Password cannot be empty';
      isValid = false;
    } else {
      passwordErrorText = null;
    }

    notifyListeners();
    return isValid;
  }
}
