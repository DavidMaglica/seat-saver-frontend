import 'package:TableReserver/pages/web/auth/authentication.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class AuthenticationModel extends FlutterFlowModel<WebAuthentication> {
  TabController? tabBarController;

  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  FocusNode emailAddressCreateFocusNode = FocusNode();
  TextEditingController emailAddressCreateTextController =
      TextEditingController();

  FocusNode passwordCreateFocusNode = FocusNode();
  TextEditingController passwordCreateTextController = TextEditingController();
  bool passwordCreateVisibility = false;

  FocusNode passwordCreateConfirmFocusNode = FocusNode();
  TextEditingController passwordCreateConfirmTextController =
      TextEditingController();
  bool passwordCreateConfirmVisibility = false;

  FocusNode emailAddressFocusNode = FocusNode();
  TextEditingController emailAddressTextController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordTextController = TextEditingController();
  bool passwordVisibility = false;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState(BuildContext context) {
    _initAnimations();
  }

  void _initAnimations() {
    return animationsMap.addAll(Animations.authenticationAnimations);
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    emailAddressCreateFocusNode.dispose();
    emailAddressCreateTextController.dispose();

    passwordCreateFocusNode.dispose();
    passwordCreateTextController.dispose();

    passwordCreateConfirmFocusNode.dispose();
    passwordCreateConfirmTextController.dispose();

    emailAddressFocusNode.dispose();
    emailAddressTextController.dispose();

    passwordFocusNode.dispose();
    passwordTextController.dispose();
  }
}
