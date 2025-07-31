import 'package:TableReserver/api/account_api.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/pages/mobile/auth/signup_tab.dart';
import 'package:TableReserver/utils/sign_up_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class SignUpTabModel extends FlutterFlowModel<SignUpTab> {
  final AccountApi accountApi = AccountApi();
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void dispose() {}

  @override
  void initState(BuildContext context) {}

  Future<BasicResponse<int>> signUp(SignUpMethod signUpMethod) async {
    switch (signUpMethod) {
      case SignUpMethod.apple:
        return _appleSignUp();

      case SignUpMethod.google:
        return _googleSignUp();

      case SignUpMethod.custom:
        return _customSignUp(
            widget.model.usernameSignUpTextController.text,
            widget.model.emailAddressSignUpTextController.text,
            widget.model.passwordSignUpTextController.text,
            widget.model.passwordConfirmTextController.text);

      }
  }

  BasicResponse<int> _appleSignUp() {
    return BasicResponse(success: false, message: 'Currently unavailable');
  }

  BasicResponse<int> _googleSignUp() {
    return BasicResponse(success: false, message: 'Currently unavailable');
  }

  Future<BasicResponse<int>> _customSignUp(
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

    return await accountApi.signUp(
      email,
      username,
      password,
    );
  }
}
