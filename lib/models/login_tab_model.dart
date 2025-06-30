import 'package:TableReserver/api/account_api.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/pages/auth/login_tab.dart';
import 'package:TableReserver/utils/sign_up_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class LogInTabModel extends FlutterFlowModel<LogInTab> {
  final AccountApi accountApi = AccountApi();

  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void dispose() {}

  @override
  void initState(BuildContext context) {}

  Future<BasicResponse<int>> logIn(SignUpMethodEnum? signUpMethod) async {
    switch (signUpMethod) {
      case SignUpMethodEnum.apple:
        return _appleLogIn();

      case SignUpMethodEnum.google:
        return _googleLogIn();

      case SignUpMethodEnum.custom:
        return _customLogIn(
          widget.model.emailAddressLogInTextController.text,
          widget.model.passwordLogInTextController.text,
        );

      default:
        return BasicResponse(success: false, message: 'Unknown sign up method');
    }
  }

  BasicResponse<int> _appleLogIn() {
    return BasicResponse(success: false, message: 'Currently unavailable');
  }

  BasicResponse<int> _googleLogIn() {
    return BasicResponse(success: false, message: 'Currently unavailable');
  }

  Future<BasicResponse<int>> _customLogIn(
    String userEmail,
    String password,
  ) async {
    if (userEmail.isEmpty || password.isEmpty) {
      return BasicResponse(
          success: false, message: 'Please fill in all fields');
    }

    if (!emailRegex.hasMatch(userEmail)) {
      return BasicResponse(
          success: false, message: 'Please enter a valid email address');
    }

    return await accountApi.logIn(userEmail, password);
  }
}
