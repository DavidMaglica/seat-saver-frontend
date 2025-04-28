import 'package:TableReserver/api/data/basic_response.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../api/account_api.dart';
import '../utils/signup_methods.dart';
import '../pages/auth/signup_tab.dart';

class SignUpTabModel extends FlutterFlowModel<SignUpTab> {
  final AccountApi accountApi = AccountApi();
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void dispose() {}

  @override
  void initState(BuildContext context) {}

  Future<BasicResponse> signUp(SignUpMethodEnum signUpMethod) async {
    switch (signUpMethod) {
      case SignUpMethodEnum.apple:
        return _appleSignUp();

      case SignUpMethodEnum.google:
        return _googleSignUp();

      case SignUpMethodEnum.custom:
        return _customSignUp(
            widget.model.usernameSignUpTextController.text,
            widget.model.emailAddressSignUpTextController.text,
            widget.model.passwordSignUpTextController.text,
            widget.model.passwordConfirmTextController.text);

      default:
        return BasicResponse(success: false, message: 'Unknown sign up method');
    }
  }

  BasicResponse _appleSignUp() {
    return BasicResponse(success: false, message: 'Currently unavailable');
  }

  BasicResponse _googleSignUp() {
    return BasicResponse(success: false, message: 'Currently unavailable');
  }

  Future<BasicResponse> _customSignUp(
    String username,
    String email,
    String password,
    String confirmedPassword,
  ) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return BasicResponse(
          success: false, message: 'Please fill in all fields');
    }

    if (!emailRegex.hasMatch(email)) {
      return BasicResponse(success: false, message: 'Invalid email address');
    }

    if (password.length < 8) {
      return BasicResponse(
          success: false,
          message: 'Password must be at least 8 characters long');
    }

    if (password != confirmedPassword) {
      return BasicResponse(success: false, message: 'Passwords do not match');
    }

    return await accountApi.signUp(username, email, password);
  }
}
