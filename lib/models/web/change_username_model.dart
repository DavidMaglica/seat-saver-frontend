import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/components/web/modals/change_username_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ChangeUsernameModel extends FlutterFlowModel<ChangeUsernameModal> {
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailTextController = TextEditingController();

  final AccountApi accountApi = AccountApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFocusNode.dispose();
    emailTextController.dispose();
  }

  void closeModal(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> updateUsername() async {
    debugPrint('Changing password...');
  }
}
