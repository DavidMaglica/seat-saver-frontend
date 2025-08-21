import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/mobile/auth/log_in_tab.dart';

class LogInTabModel extends FlutterFlowModel<LogInTab> {
  final AccountApi accountApi = AccountApi();

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void dispose() {}

  @override
  void initState(BuildContext context) {
    googleSignIn.attemptLightweightAuthentication();
  }

  Future<BasicResponse<int?>> logIn(String userEmail, String password) async {
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
