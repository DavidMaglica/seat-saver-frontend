import 'package:table_reserver/components/web/modals/change_password_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ChangePasswordModel extends FlutterFlowModel<ChangePasswordModal> {
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordTextController = TextEditingController();
  bool passwordVisibility = false;

  FocusNode newPasswordFocusNode = FocusNode();
  TextEditingController newPasswordTextController = TextEditingController();
  bool newPasswordVisibility = false;

  FocusNode passwordConfirmFocusNode = FocusNode();
  TextEditingController passwordConfirmTextController = TextEditingController();
  bool passwordConfirmVisibility = false;

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    passwordFocusNode.dispose();
    passwordTextController.dispose();

    newPasswordFocusNode.dispose();
    newPasswordTextController.dispose();

    passwordConfirmFocusNode.dispose();
    passwordConfirmTextController.dispose();
  }

  Future<void> changePassword() async {
    debugPrint('Changing password...');
  }
}
