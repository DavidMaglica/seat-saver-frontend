import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/pages/web/auth/log_in_tab.dart';
import 'package:seat_saver/pages/web/views/homepage.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';
import 'package:seat_saver/utils/sign_up_methods.dart';
import 'package:seat_saver/utils/web_toaster.dart';

class LogInTabModel extends FlutterFlowModel<LogInTab> with ChangeNotifier {
  bool isActive;

  LogInTabModel({required this.isActive});

  String? emailErrorText;
  String? passwordErrorText;

  final AccountApi accountApi = AccountApi();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  late final StreamSubscription authSubscription;

  @override
  void initState(BuildContext context) {}

  void init(BuildContext context) {
    final int? ownerId = sharedPreferencesCache.getInt('ownerId');
    authListener(context);
    const bool isFakeAuth = bool.fromEnvironment('FAKE_AUTH');
    if (isActive && !isFakeAuth) {
      if (ownerId != null) return;
      googleSignIn.attemptLightweightAuthentication()?.then((value) {
        if (value != null) {
          currentAuthMethod = AuthenticationMethod.google;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    authSubscription.cancel();
  }

  void authListener(BuildContext context) {
    authSubscription = googleSignIn.authenticationEvents.listen((event) async {
      if (!isActive) return;
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final GoogleSignInAccount user = event.user;
        if (!context.mounted) return;
        await logIn(context, user.email, user.id, AuthenticationMethod.google);
      } else if (event is GoogleSignInException) {
        debugPrint('Auth failed: $event');
      }
    });
  }

  Future<void> logIn(
    BuildContext context,
    String userEmail,
    String password,
    AuthenticationMethod authMethod,
  ) async {
    currentAuthMethod = authMethod;

    if (!_validateFields(userEmail, password)) return;

    BasicResponse<int?> response = await accountApi.logIn(userEmail, password);

    if (response.success && response.data != null) {
      int ownerId = response.data!;

      BasicResponse<User?> userResponse = await accountApi.getUser(ownerId);

      if (userResponse.success) {
        User user = userResponse.data!;

        sharedPreferencesCache.setInt('ownerId', ownerId);

        _goToHomepage(context, user.id);
      }
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }
  }

  void _goToHomepage(BuildContext context, int ownerId) {
    Navigator.of(context).push(
      FadeInRoute(
        routeName: Routes.webHomepage,
        page: WebHomepage(ownerId: ownerId),
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
