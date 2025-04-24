import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../api/account_api.dart';
import 'authentication.dart';

class AuthenticationModel extends FlutterFlowModel<Authentication> {
  final unfocusNode = FocusNode();

  final AccountApi accountApi = AccountApi();

  TabController? tabBarController;

  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // SignUp
  FocusNode? usernameSignUpFocusNode;
  TextEditingController? usernameSignUpTextController;

  FocusNode? emailAddressSignUpFocusNode;
  TextEditingController? emailAddressSignUpTextController;

  FocusNode? passwordSignUpFocusNode;
  TextEditingController? passwordSignUpTextController;
  late bool passwordSignUpVisibility;

  FocusNode? passwordConfirmFocusNode;
  TextEditingController? passwordConfirmTextController;
  late bool passwordConfirmVisibility;

  // logIn
  FocusNode? emailAddressLogInFocusNode;
  TextEditingController? emailAddressLogInTextController;

  FocusNode? passwordLogInFocusNode;
  TextEditingController? passwordLoInTextController;
  late bool passwordlogInVisibility;

  @override
  void initState(BuildContext context) {
    passwordSignUpVisibility = false;
    passwordConfirmVisibility = false;
    passwordlogInVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();

    usernameSignUpFocusNode?.dispose();
    usernameSignUpTextController?.dispose();

    emailAddressSignUpFocusNode?.dispose();
    emailAddressSignUpTextController?.dispose();

    passwordSignUpFocusNode?.dispose();
    passwordSignUpTextController?.dispose();

    passwordConfirmFocusNode?.dispose();
    passwordConfirmTextController?.dispose();

    emailAddressLogInFocusNode?.dispose();
    emailAddressLogInTextController?.dispose();

    passwordLogInFocusNode?.dispose();
    passwordLoInTextController?.dispose();
  }
}
