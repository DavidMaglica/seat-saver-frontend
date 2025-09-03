import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/pages/mobile/auth/authentication.dart';

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
  bool passwordSignUpVisibility = false;

  final FocusNode passwordConfirmFocusNode = FocusNode();
  final TextEditingController passwordConfirmTextController =
      TextEditingController();
  bool passwordConfirmVisibility = false;

  // logIn
  final FocusNode emailAddressLogInFocusNode = FocusNode();
  final TextEditingController emailAddressLogInTextController =
      TextEditingController();

  final FocusNode passwordLogInFocusNode = FocusNode();
  final TextEditingController passwordLogInTextController =
      TextEditingController();
  bool passwordLogInVisibility = false;

  @override
  void initState(BuildContext context) {}

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
