import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/auth/sign_up_tab.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/sign_up_methods.dart';
import 'package:table_reserver/utils/web_toaster.dart';

// TODO with ChangeNotifier
class SignUpTabModel extends FlutterFlowModel<SignUpTab> {
  bool isActive;

  SignUpTabModel({required this.isActive});

  final AccountApi accountApi = AccountApi();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  late final StreamSubscription authSubscription;

  @override
  void initState(BuildContext context) {
    final int? ownerId = sharedPreferencesCache.getInt('ownerId');
    authListener(context);
    if (isActive) {
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
    authSubscription.cancel();
  }

  void authListener(BuildContext context) {
    authSubscription = googleSignIn.authenticationEvents.listen((event) async {
      if (!isActive) return;
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final GoogleSignInAccount user = event.user;
        if (!context.mounted) return;
        await _performSignUp(context, user);
      } else if (event is GoogleSignInException) {
        debugPrint('Auth failed: $event');
      }
    });
  }

  Future<void> _performSignUp(
    BuildContext context,
    GoogleSignInAccount user,
  ) async {
    final BasicResponse<int> response = await signUp(
      username: user.displayName ?? user.email,
      email: user.email,
      password: user.id,
      confirmedPassword: user.id,
    );

    if (response.success && response.data != null) {
      if (!context.mounted) return;
      int ownerId = response.data!;
      sharedPreferencesCache.setInt('ownerId', ownerId);

      if (!context.mounted) return;
      Navigator.of(context).push(
        FadeInRoute(
          routeName: Routes.webHomepage,
          page: WebHomepage(ownerId: ownerId),
        ),
      );
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }
  }

  Future<BasicResponse<int>> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmedPassword,
  }) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return BasicResponse(
        success: false,
        message: 'Please fill in all fields',
      );
    }

    if (!emailRegex.hasMatch(email)) {
      return BasicResponse(success: false, message: 'Invalid email address');
    }

    if (password.length < 8) {
      return BasicResponse(
        success: false,
        message: 'Password must be at least 8 characters long',
      );
    }

    if (password != confirmedPassword) {
      return BasicResponse(success: false, message: 'Passwords do not match');
    }

    return await accountApi.signUp(email, username, password, true);
  }
}
