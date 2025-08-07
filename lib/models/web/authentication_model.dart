import 'package:table_reserver/pages/web/auth/authentication.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class AuthenticationModel extends FlutterFlowModel<WebAuthentication> {
  TabController? tabBarController;

  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  FocusNode signUpEmailFocusNode = FocusNode();
  TextEditingController signUpEmailTextController =
      TextEditingController();

  FocusNode signUpUsernameFocusNode = FocusNode();
  TextEditingController signUpUsernameTextController = TextEditingController();

  FocusNode signUpPasswordFocusNode = FocusNode();
  TextEditingController signUpPasswordTextController = TextEditingController();
  bool signUpPasswordVisibility = false;

  FocusNode signUpPasswordConfirmFocusNode = FocusNode();
  TextEditingController signUpPasswordConfirmTextController =
      TextEditingController();
  bool signUpPasswordConfirmVisibility = false;

  FocusNode loginEmailFocusNode = FocusNode();
  TextEditingController loginEmailTextController = TextEditingController();

  FocusNode loginPasswordFocusNode = FocusNode();
  TextEditingController loginPasswordTextController = TextEditingController();
  bool loginPasswordVisibility = false;

  final Map<String, AnimationInfo> animationsMap =
      Animations.authenticationAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();

    signUpEmailFocusNode.dispose();
    signUpEmailTextController.dispose();

    signUpUsernameFocusNode.dispose();
    signUpUsernameTextController.dispose();

    signUpPasswordFocusNode.dispose();
    signUpPasswordTextController.dispose();

    signUpPasswordConfirmFocusNode.dispose();
    signUpPasswordConfirmTextController.dispose();

    loginEmailFocusNode.dispose();
    loginEmailTextController.dispose();

    loginPasswordFocusNode.dispose();
    loginPasswordTextController.dispose();
  }
}
