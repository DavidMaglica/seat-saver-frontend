import 'package:TableReserver/api/account_api.dart';
import 'package:TableReserver/api/data/user.dart';
import 'package:TableReserver/themes/mobile_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geolocator/geolocator.dart';

class EditProfileModel extends ChangeNotifier {
  final BuildContext context;
  final int userId;
  final Position? userLocation;

  EditProfileModel({
    required this.context,
    required this.userId,
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

  User? currentUser;

  @override
  void dispose() {
    disposeFields();
    super.dispose();
  }

  void init() {
    _getUser();
  }

  Future<void> _getUser() async {
    final response = await accountApi.getUser(userId);
    if (response != null && response.success && response.user != null) {
      currentUser = response.user!;
    } else {
      _showToast('Failed to load user data', MobileTheme.errorColor);
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

  Future<void> changeUsername() async {
    final newName = updatedUsername ?? newUsernameTextController.text;

    if (newName.isEmpty) {
      _hideKeyboard();
      _showToast('Please enter a new username', MobileTheme.errorColor);
      return;
    }

    final response = await accountApi.changeUsername(userId, newName);

    if (!response.success) {
      _hideKeyboard();
      _showToast(response.message, MobileTheme.errorColor);
      return;
    }

    _hideKeyboard();
    _showToast(response.message,
        response.success ? MobileTheme.successColor : MobileTheme.errorColor);

    if (response.success) {
      updatedUsername = newName;
      newUsernameTextController.clear();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  Future<void> changeEmail() async {
    final newEmail = newEmailTextController.text;

    if (newEmail.isEmpty) {
      _hideKeyboard();
      _showToast('Please enter a new email', MobileTheme.errorColor);
      return;
    }

    final response = await accountApi.changeEmail(userId, newEmail);

    if (!response.success) {
      _hideKeyboard();
      _showToast(response.message, MobileTheme.errorColor);
      return;
    }

    _hideKeyboard();
    _showToast(response.message,
        response.success ? MobileTheme.successColor : MobileTheme.errorColor);

    if (response.success) {
      updatedEmail = newEmail;
      newEmailTextController.clear();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  Future<void> changePassword() async {
    final newPassword = newPasswordTextController.text;
    final confirmNewPassword = confirmNewPasswordTextController.text;

    if (newPassword.isEmpty) {
      _hideKeyboard();
      _showToast('Please enter a new password', MobileTheme.errorColor);
      return;
    }

    if (confirmNewPassword.isEmpty) {
      _hideKeyboard();
      _showToast("New password hasn't been confirmed", MobileTheme.errorColor);
      return;
    }

    if (newPassword.length < 8) {
      _hideKeyboard();
      _showToast(
          'Password must be at least 8 characters long', MobileTheme.errorColor);
      return;
    }

    if (newPassword != confirmNewPassword) {
      _hideKeyboard();
      _showToast('Passwords do not match', MobileTheme.errorColor);
      return;
    }

    final response = await accountApi.changePassword(userId, newPassword);

    if (!response.success) {
      _hideKeyboard();
      _showToast(response.message, MobileTheme.errorColor);
      return;
    }

    _hideKeyboard();
    _showToast(response.message,
        response.success ? MobileTheme.successColor : MobileTheme.errorColor);

    if (response.success) {
      updatedPassword = newPassword;
      newPasswordTextController.clear();
      confirmNewPasswordTextController.clear();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  void cancel() => Navigator.of(context).pop();

  void _showToast(String message, Color color) {
    showToast(
      message,
      context: context,
      backgroundColor: color,
      textStyle: const TextStyle(color: Colors.white, fontSize: 16),
      borderRadius: BorderRadius.circular(8),
      textPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      alignment: Alignment.bottomLeft,
      duration: const Duration(seconds: 4),
    );
  }

  void _hideKeyboard() =>
      SystemChannels.textInput.invokeMethod('TextInput.hide');
}
