import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/components/web/modals/change_password_modal.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class ChangePasswordModel extends FlutterFlowModel<ChangePasswordModal>
    with ChangeNotifier {
  FocusNode newPasswordFocusNode = FocusNode();
  TextEditingController newPasswordTextController = TextEditingController();
  bool newPasswordVisibility = false;
  String? newPasswordErrorText;

  FocusNode confirmPasswordFocusNode = FocusNode();
  TextEditingController confirmPasswordTextController = TextEditingController();
  bool confirmPasswordVisibility = false;
  String? confirmPasswordErrorText;

  final AccountApi accountApi = AccountApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
    newPasswordFocusNode.dispose();
    newPasswordTextController.dispose();

    confirmPasswordFocusNode.dispose();
    confirmPasswordTextController.dispose();
  }

  Future<void> changePassword(BuildContext context) async {
    final newPassword = newPasswordTextController.text;
    final confirmPassword = confirmPasswordTextController.text;

    if (!isValidPassword(newPassword, confirmPassword)) {
      notifyListeners();
      return;
    }

    int userId = prefsWithCache.getInt('userId')!;

    BasicResponse response = await accountApi.changePassword(
      userId,
      newPassword,
    );

    if (response.success) {
      if (!context.mounted) return;

      newPasswordTextController.clear();
      confirmPasswordTextController.clear();
      WebToaster.displaySuccess(context, response.message);

      if (!context.mounted) return;
      Navigator.of(context).pop();
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }

    newPasswordErrorText = null;
    confirmPasswordErrorText = null;

    notifyListeners();
    return;
  }

  bool isValidPassword(String newPassword, String confirmPassword) {
    if (newPassword.isEmpty) {
      newPasswordErrorText = 'New password is required';
      return false;
    } else if (newPassword.length < 8) {
      newPasswordErrorText = 'New password must be at least 8 characters';
      return false;
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordErrorText = 'Confirm password is required';
      return false;
    } else if (confirmPassword != newPassword) {
      confirmPasswordErrorText = 'Passwords do not match';
      return false;
    }

    return true;
  }
}
