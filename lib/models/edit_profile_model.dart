import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geolocator/geolocator.dart';

import '../api/account_api.dart';
import '../api/data/user.dart';
import '../themes/theme.dart';

class EditProfileModel extends ChangeNotifier {
  final User user;
  final Position? userLocation;
  final BuildContext context;

  EditProfileModel({
    required this.user,
    required this.context,
    this.userLocation,
  });

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final newUsernameFocusNode = FocusNode();
  final newUsernameTextController = TextEditingController();

  final newEmailFocusNode = FocusNode();
  final newEmailTextController = TextEditingController();

  final newPasswordFocusNode = FocusNode();
  final newPasswordTextController = TextEditingController();
  bool newPasswordVisibility = false;

  final confirmNewPasswordFocusNode = FocusNode();
  final confirmNewPasswordTextController = TextEditingController();
  bool confirmNewPasswordVisibility = false;

  String? updatedUsername;
  String? updatedPassword;
  String? updatedEmail;

  final AccountApi accountApi = AccountApi();

  @override
  void dispose() {
    disposeFields();
    super.dispose();
  }

  void disposeFields() {
    newUsernameFocusNode.dispose();
    newUsernameTextController.dispose();
    newEmailFocusNode.dispose();
    newEmailTextController.dispose();
    newPasswordFocusNode.dispose();
    newPasswordTextController.dispose();
    confirmNewPasswordFocusNode.dispose();
    confirmNewPasswordTextController.dispose();
  }

  Future<void> changeUsername() async {
    final newName = updatedUsername ?? newUsernameTextController.text;

    if (newName.isEmpty) {
      _hideKeyboard();
      _showToast('Please enter a new username', AppThemes.errorColor);
      return;
    }

    final response = await accountApi.changeUsername(user.email, newName);
    _hideKeyboard();
    _showToast(response.message,
        response.success ? AppThemes.successColor : AppThemes.errorColor);

    if (response.success) {
      updatedUsername = newName;
      newUsernameTextController.clear();
      notifyListeners();
      Navigator.of(context).pop();
    }
  }

  Future<void> changeEmail() async {
    final newEmail = newEmailTextController.text;

    if (newEmail.isEmpty) {
      _hideKeyboard();
      _showToast('Please enter a new email', AppThemes.errorColor);
      return;
    }

    final response = await accountApi.changeEmail(user.email, newEmail);
    _hideKeyboard();
    _showToast(response.message,
        response.success ? AppThemes.successColor : AppThemes.errorColor);

    if (response.success) {
      updatedEmail = newEmail;
      newEmailTextController.clear();
      notifyListeners();
      Navigator.of(context).pop();
    }
  }

  Future<void> changePassword() async {
    final newPassword = newPasswordTextController.text;
    final confirmNewPassword = confirmNewPasswordTextController.text;

    if (newPassword.isEmpty) {
      _hideKeyboard();
      _showToast('Please enter a new password', AppThemes.errorColor);
      return;
    }

    if (confirmNewPassword.isEmpty) {
      _hideKeyboard();
      _showToast("New password hasn't been confirmed", AppThemes.errorColor);
      return;
    }

    if (newPassword.length < 8) {
      _hideKeyboard();
      _showToast(
          'Password must be at least 8 characters long', AppThemes.errorColor);
      return;
    }

    if (newPassword != confirmNewPassword) {
      _hideKeyboard();
      _showToast('Passwords do not match', AppThemes.errorColor);
      return;
    }

    final email = updatedEmail ?? user.email;
    final response = await accountApi.changePassword(email, newPassword);
    _hideKeyboard();
    _showToast(response.message,
        response.success ? AppThemes.successColor : AppThemes.errorColor);

    if (response.success) {
      updatedPassword = newPassword;
      newPasswordTextController.clear();
      confirmNewPasswordTextController.clear();
      notifyListeners();
      Navigator.of(context).pop();
    }
  }

  void cancel() => Navigator.of(context).pop();

  void _showToast(String message, Color color) {
    showToast(
      message,
      context: context,
      backgroundColor: color,
      textStyle: const TextStyle(color: Colors.white, fontSize: 16.0),
      borderRadius: BorderRadius.circular(8),
      textPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      alignment: Alignment.bottomLeft,
      duration: const Duration(seconds: 4),
    );
  }

  void _hideKeyboard() =>
      SystemChannels.textInput.invokeMethod('TextInput.hide');
}
