import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/auth/log_in_tab.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/sign_up_methods.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class LogInTabModel extends FlutterFlowModel<LogInTab> {
  bool isActive;

  LogInTabModel({required this.isActive});

  final AccountApi accountApi = AccountApi();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  late final StreamSubscription authSubscription;

  @override
  void initState(BuildContext context) {
    final int? userId = prefsWithCache.getInt('userId');
    authListener(context);
    if (isActive) {
      if (userId != null) return;
      googleSignIn.attemptLightweightAuthentication()?.then((value) {
        if (value != null) {
          currentAuthMethod = AuthenticationMethod.google;
        }
      });
    }
  }

  @override
  void dispose() {
    authSubscription.cancel();
  }

  void authListener(BuildContext context) {
    authSubscription = googleSignIn.authenticationEvents.listen((event) async {
      if (!isActive) return;
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final GoogleSignInAccount user = event.user;
        if (!context.mounted) return;
        await _performLogin(context, user);
      } else if (event is GoogleSignInException) {
        debugPrint('Auth failed: $event');
      }
    });
  }

  Future<void> _performLogin(
    BuildContext context,
    GoogleSignInAccount user,
  ) async {
    final BasicResponse<int?> response = await logIn(
      user.email,
      user.id,
      AuthenticationMethod.google,
    );

    if (response.success && response.data != null) {
      if (!context.mounted) return;
      int userId = response.data!;
      prefsWithCache.setInt('userId', userId);

      Navigator.of(context).push(
        FadeInRoute(
          routeName: Routes.webHomepage,
          page: WebHomepage(userId: userId),
        ),
      );
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }
  }

  Future<BasicResponse<int?>> logIn(
    String userEmail,
    String password,
    AuthenticationMethod authMethod,
  ) async {
    currentAuthMethod = authMethod;
    if (userEmail.isEmpty || password.isEmpty) {
      return BasicResponse(
        success: false,
        message: 'Please fill in all fields',
      );
    }

    if (!emailRegex.hasMatch(userEmail)) {
      return BasicResponse(
        success: false,
        message: 'Please enter a valid email address',
      );
    }

    return await accountApi.logIn(userEmail, password);
  }
}
