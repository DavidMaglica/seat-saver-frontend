import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/auth/sign_up_tab.dart';

class SignUpTabModel extends FlutterFlowModel<SignUpTab> {
  final AccountApi accountApi = AccountApi();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  late final StreamSubscription authSubscription;

  @override
  void initState(BuildContext context) {
    authListener();
    googleSignIn.attemptLightweightAuthentication();
  }

  @override
  void dispose() {
    authSubscription.cancel();
  }

  void authListener() {
    authSubscription = googleSignIn.authenticationEvents.listen((event) {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final GoogleSignInAccount user = event.user;
        signUp(user.displayName ?? user.email, user.email, user.id, user.id);
      } else if (event is GoogleSignInException) {
        debugPrint('Auth failed: $event');
      }
    });
  }

  Future<BasicResponse<int>> signUp(
    String username,
    String email,
    String password,
    String confirmedPassword,
  ) async {
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
