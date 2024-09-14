import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../authentication.dart';

class AuthenticationModel extends FlutterFlowModel<Authentication> {
  final unfocusNode = FocusNode();

  TabController? tabBarController;

  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Signup
  FocusNode? usernameSignupFocusNode;
  TextEditingController? usernameSignupTextController;

  FocusNode? emailAddressSignupFocusNode;
  TextEditingController? emailAddressSignupTextController;

  FocusNode? passwordSignupFocusNode;
  TextEditingController? passwordSignupTextController;
  late bool passwordSignupVisibility;

  FocusNode? passwordConfirmFocusNode;
  TextEditingController? passwordConfirmTextController;
  late bool passwordConfirmVisibility;

  // Login
  FocusNode? emailAddressLoginFocusNode;
  TextEditingController? emailAddressLoginTextController;

  FocusNode? passwordLoginFocusNode;
  TextEditingController? passwordLoginTextController;
  late bool passwordLoginVisibility;

  @override
  void initState(BuildContext context) {
    passwordSignupVisibility = false;
    passwordConfirmVisibility = false;
    passwordLoginVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();

    usernameSignupFocusNode?.dispose();
    usernameSignupTextController?.dispose();

    emailAddressSignupFocusNode?.dispose();
    emailAddressSignupTextController?.dispose();

    passwordSignupFocusNode?.dispose();
    passwordSignupTextController?.dispose();

    passwordConfirmFocusNode?.dispose();
    passwordConfirmTextController?.dispose();

    emailAddressLoginFocusNode?.dispose();
    emailAddressLoginTextController?.dispose();

    passwordLoginFocusNode?.dispose();
    passwordLoginTextController?.dispose();
  }
}
