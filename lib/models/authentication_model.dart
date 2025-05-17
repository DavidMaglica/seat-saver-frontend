import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../api/account_api.dart';
import '../pages/auth/authentication.dart';

class AuthenticationModel extends FlutterFlowModel<Authentication> {
  final unfocusNode = FocusNode();

  final AccountApi accountApi = AccountApi();

  TabController? tabBarController;

  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // SignUp
  final FocusNode usernameSignUpFocusNode = FocusNode();
  final TextEditingController usernameSignUpTextController =
      TextEditingController();

  final FocusNode emailAddressSignUpFocusNode = FocusNode();
  final TextEditingController emailAddressSignUpTextController =
      TextEditingController();

  final FocusNode passwordSignUpFocusNode = FocusNode();
  final TextEditingController passwordSignUpTextController =
      TextEditingController();
  late bool passwordSignUpVisibility;

  final FocusNode passwordConfirmFocusNode = FocusNode();
  final TextEditingController passwordConfirmTextController =
      TextEditingController();
  late bool passwordConfirmVisibility;

  // logIn
  final FocusNode emailAddressLogInFocusNode = FocusNode();
  final TextEditingController emailAddressLogInTextController =
      TextEditingController();

  final FocusNode passwordLogInFocusNode = FocusNode();
  final TextEditingController passwordLogInTextController =
      TextEditingController();
  late bool passwordLogInVisibility;

  @override
  void initState(BuildContext context) {
    passwordSignUpVisibility = false;
    passwordConfirmVisibility = false;
    passwordLogInVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();

    usernameSignUpFocusNode.dispose();
    usernameSignUpTextController.dispose();

    emailAddressSignUpFocusNode.dispose();
    emailAddressSignUpTextController.dispose();

    passwordSignUpFocusNode.dispose();
    passwordSignUpTextController.dispose();

    passwordConfirmFocusNode.dispose();
    passwordConfirmTextController.dispose();

    emailAddressLogInFocusNode.dispose();
    emailAddressLogInTextController.dispose();

    passwordLogInFocusNode.dispose();
    passwordLogInTextController.dispose();
  }
}
