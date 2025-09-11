import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/pages/mobile/auth/sign_up_tab.dart';
import 'package:seat_saver/pages/mobile/views/homepage.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';
import 'package:seat_saver/utils/toaster.dart';

class SignUpTabModel extends FlutterFlowModel<SignUpTab> with ChangeNotifier {
  final AccountApi accountApi = AccountApi();
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  final GoogleSignIn signIn = GoogleSignIn.instance;

  String? emailErrorText;
  String? usernameErrorText;
  String? passwordErrorText;
  String? confirmPasswordErrorText;

  @override
  void initState(BuildContext context) {
    googleSignIn.attemptLightweightAuthentication();
  }

  Future<void> signUp(
    BuildContext context,
    String email,
    String username,
    String password,
    String confirmedPassword,
  ) async {
    if (!_validateAllFields(email, username, password, confirmedPassword)) {
      return;
    }

    BasicResponse<int> response = await accountApi.signUp(
      email,
      username,
      password,
      false,
    );

    int? userId = response.data;

    if (response.success && userId != null) {
      sharedPreferencesCache.setInt('userId', userId);
      _goToHomepage(context, userId);
    } else {
      if (!context.mounted) return;
      Toaster.displayError(context, response.message);
    }
  }

  void _goToHomepage(BuildContext context, int userId) {
    Navigator.of(context).push(
      MobileFadeInRoute(page: const Homepage(), routeName: Routes.homepage),
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
