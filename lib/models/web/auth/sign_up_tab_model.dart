import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/auth/sign_up_tab.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/sign_up_methods.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class SignUpTabModel extends FlutterFlowModel<SignUpTab> with ChangeNotifier {
  bool isActive;

  SignUpTabModel({required this.isActive});

  String? emailErrorText;
  String? usernameErrorText;
  String? passwordErrorText;
  String? confirmPasswordErrorText;

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
    super.dispose();
    authSubscription.cancel();
  }

  void authListener(BuildContext context) {
    authSubscription = googleSignIn.authenticationEvents.listen((event) async {
      if (!isActive) return;
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final GoogleSignInAccount user = event.user;
        if (!context.mounted) return;
        await signUp(
          context: context,
          email: user.email,
          username: user.displayName ?? user.email,
          password: user.id,
          confirmedPassword: user.id,
          authMethod: AuthenticationMethod.google,
        );
      } else if (event is GoogleSignInException) {
        debugPrint('Auth failed: $event');
      }
    });
  }

  Future<void> signUp({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
    required String confirmedPassword,
    required AuthenticationMethod authMethod,
  }) async {
    currentAuthMethod = authMethod;

    if (!_validateAllFields(email, username, password, confirmedPassword)) {
      return;
    }

    BasicResponse<int> response = await accountApi.signUp(
      email,
      username,
      password,
      true,
    );

    if (response.success && response.data != null) {
      int ownerId = response.data!;

      UserResponse? userResponse = await accountApi.getUser(ownerId);

      if (userResponse != null && userResponse.success) {
        User user = userResponse.user!;

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

  bool _validateAllFields(
    String email,
    String username,
    String password,
    String confirmPassword,
  ) {
    bool isValid = true;

    if (email.isEmpty) {
      emailErrorText = 'Email cannot be empty';
      isValid = false;
    } else if (!emailRegex.hasMatch(email)) {
      emailErrorText = 'Invalid email address';
      isValid = false;
    } else {
      emailErrorText = null;
    }

    if (username.isEmpty) {
      usernameErrorText = 'Username cannot be empty';
      isValid = false;
    } else {
      usernameErrorText = null;
    }

    if (password.isEmpty) {
      passwordErrorText = 'Password cannot be empty';
      isValid = false;
    } else if (password.length < 8) {
      passwordErrorText = 'Password must be at least 8 characters';
      isValid = false;
    } else {
      passwordErrorText = null;
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordErrorText = 'Please confirm your password';
      isValid = false;
    } else if (password != confirmPassword) {
      confirmPasswordErrorText = 'Passwords do not match';
      isValid = false;
    } else {
      confirmPasswordErrorText = null;
    }

    notifyListeners();
    return isValid;
  }
}
