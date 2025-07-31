import 'package:TableReserver/api/account_api.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/pages/mobile/auth/sign_up_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpTabModel extends FlutterFlowModel<SignUpTab> {
  final AccountApi accountApi = AccountApi();
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  final GoogleSignIn signIn = GoogleSignIn.instance;

  @override
  void dispose() {}

  @override
  void initState(BuildContext context) {}

  Future<BasicResponse<int>> signUp(
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
