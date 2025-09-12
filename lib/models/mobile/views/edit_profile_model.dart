import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/themes/mobile_theme.dart';
import 'package:seat_saver/utils/toaster.dart';

class EditProfileModel extends ChangeNotifier {
  final int userId;

  final AccountApi accountApi;

  EditProfileModel({required this.userId, AccountApi? accountApi})
    : accountApi = accountApi ?? AccountApi();

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

  User? currentUser;

  @override
  void dispose() {
    disposeFields();
    super.dispose();
  }

  Future<void> init(BuildContext context) async {
    _getUser(context);
  }

  Future<void> _getUser(BuildContext context) async {
    final response = await accountApi.getUser(userId);
    if (response.success && response.data != null) {
      currentUser = response.data!;
    } else {
      _showToast(context, 'Failed to load user data', MobileTheme.errorColor);
    }
    notifyListeners();
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

  Future<void> changeUsername(BuildContext context) async {
    final newName = updatedUsername ?? newUsernameTextController.text;

    if (newName.isEmpty) {
      _hideKeyboard();
      _showToast(
        context,
        'Please enter a new username',
        MobileTheme.errorColor,
      );
      return;
    }

    final response = await accountApi.changeUsername(userId, newName);

    if (!response.success) {
      _hideKeyboard();
      _showToast(context, response.message, MobileTheme.errorColor);
      return;
    }

    _hideKeyboard();
    _showToast(
      context,
      response.message,
      response.success ? MobileTheme.successColor : MobileTheme.errorColor,
    );

    if (response.success) {
      updatedUsername = newName;
      newUsernameTextController.clear();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  Future<void> changeEmail(BuildContext context) async {
    final newEmail = newEmailTextController.text;

    if (newEmail.isEmpty) {
      _hideKeyboard();
      _showToast(context, 'Please enter a new email', MobileTheme.errorColor);
      return;
    }

    final response = await accountApi.changeEmail(userId, newEmail);

    if (!response.success) {
      _hideKeyboard();
      _showToast(context, response.message, MobileTheme.errorColor);
      return;
    }

    _hideKeyboard();
    _showToast(
      context,
      response.message,
      response.success ? MobileTheme.successColor : MobileTheme.errorColor,
    );

    if (response.success) {
      updatedEmail = newEmail;
      newEmailTextController.clear();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  Future<void> changePassword(BuildContext context) async {
    final newPassword = newPasswordTextController.text;
    final confirmNewPassword = confirmNewPasswordTextController.text;

    if (newPassword.isEmpty) {
      _hideKeyboard();
      _showToast(
        context,
        'Please enter a new password',
        MobileTheme.errorColor,
      );
      return;
    }

    if (confirmNewPassword.isEmpty) {
      _hideKeyboard();
      _showToast(
        context,
        'New password hasn\'t been confirmed',
        MobileTheme.errorColor,
      );
      return;
    }

    if (newPassword.length < 8) {
      _hideKeyboard();
      _showToast(
        context,
        'Password must be at least 8 characters long',
        MobileTheme.errorColor,
      );
      return;
    }

    if (newPassword != confirmNewPassword) {
      _hideKeyboard();
      _showToast(context, 'Passwords do not match', MobileTheme.errorColor);
      return;
    }

    final response = await accountApi.changePassword(userId, newPassword);

    if (!response.success) {
      _hideKeyboard();
      _showToast(context, response.message, MobileTheme.errorColor);
      return;
    }

    _hideKeyboard();
    _showToast(
      context,
      response.message,
      response.success ? MobileTheme.successColor : MobileTheme.errorColor,
    );

    if (response.success) {
      updatedPassword = newPassword;
      newPasswordTextController.clear();
      confirmNewPasswordTextController.clear();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  void cancel(BuildContext context) => Navigator.of(context).pop();

  void _showToast(BuildContext context, String message, Color color) {
    Toaster.display(context, message, color);
  }

  void _hideKeyboard() =>
      SystemChannels.textInput.invokeMethod('TextInput.hide');
}
