import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/extension.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/account_api.dart';
import '../../api/data/user.dart';
import '../../components/custom_appbar.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import 'helpers/edit_profile_helpers.dart';
import 'utils/settings_utils.dart';

class EditProfile extends StatefulWidget {
  final User user;
  final Position? userLocation;

  const EditProfile({
    Key? key,
    required this.user,
    this.userLocation,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FocusNode? _newUsernameFocusNode;
  TextEditingController? _newUsernameTextController;
  String? Function(BuildContext, String?)? _newUsernameTextControllerValidator;

  FocusNode? _newEmailFocusNode;
  TextEditingController? _newEmailTextController;
  String? Function(BuildContext, String?)? _newEmailTextControllerValidator;

  FocusNode? _newPasswordFocusNode;
  TextEditingController? _newPasswordTextController;
  bool _newPasswordVisibility = false;
  String? Function(BuildContext, String?)? _newPasswordTextControllerValidator;

  FocusNode? _confirmNewPasswordFocusNode;
  TextEditingController? _confirmNewPasswordTextController;
  bool _confirmNewPasswordVisibility = false;
  String? Function(BuildContext, String?)?
      _confirmNewPasswordTextControllerValidator;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? updatedUsername;
  String? updatedPassword;
  String? updatedEmail;

  @override
  void initState() {
    super.initState();
    _newUsernameTextController = TextEditingController();
    _newEmailTextController = TextEditingController();
    _newPasswordTextController = TextEditingController();
    _confirmNewPasswordTextController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _newUsernameFocusNode?.dispose();
    _newUsernameTextController?.dispose();

    _newEmailFocusNode?.dispose();
    _newEmailTextController?.dispose();

    _newPasswordFocusNode?.dispose();
    _newPasswordTextController?.dispose();

    _confirmNewPasswordFocusNode?.dispose();
    _confirmNewPasswordTextController?.dispose();

    super.dispose();
  }

  void _changeUsername() {
    String? newName = updatedEmail ?? _newUsernameTextController?.text;

    if (newName.isNullOrEmpty) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast('Please enter a new username', AppThemes.errorColor);
      return;
    }

    changeUsername(widget.user.email, newName!).then((response) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast(response.message,
          response.success ? AppThemes.successColor : AppThemes.errorColor);

      if (response.success) {
        setState(() {
          updatedUsername = newName;
          _newUsernameTextController?.clear();
        });
        Navigator.of(context).pop();
      }
    }).catchError((error) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast('Error while changing username. Please try again later.',
          AppThemes.errorColor);
    });
  }

  void _changeEmail() {
    String? newEmail = _newEmailTextController?.text;

    if (newEmail.isNullOrEmpty) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast('Please enter a new email', AppThemes.errorColor);
      return;
    }

    changeEmail(widget.user.email, newEmail!).then((response) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast(response.message,
          response.success ? AppThemes.successColor : AppThemes.errorColor);

      if (response.success) {
        setState(() {
          updatedEmail = newEmail;
          _newEmailTextController?.clear();
        });
        Navigator.of(context).pop();
      }
    }).catchError((error) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast('Error while changing email. Please try again later.',
          AppThemes.errorColor);
    });
  }

  void _changePassword() {
    String? newPassword = _newPasswordTextController?.text;
    String? confirmNewPassword = _confirmNewPasswordTextController?.text;

    if (newPassword == null || newPassword.isEmpty) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast('Please enter a new password', AppThemes.errorColor);
      return;
    }

    if (confirmNewPassword == null || confirmNewPassword.isEmpty) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast("New password hasn't been confirmed", AppThemes.errorColor);
      return;
    }

    if (newPassword.length < 8) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast(
          'Password must be at least 8 characters long', AppThemes.errorColor);
      return;
    }

    if (newPassword != confirmNewPassword) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast('Passwords do not match', AppThemes.errorColor);
      return;
    }

    String email = updatedEmail ?? widget.user.email;
    changePassword(email, newPassword).then((response) async {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast(response.message,
          response.success ? AppThemes.successColor : AppThemes.errorColor);

      if (response.success) {
        setState(() {
          updatedPassword = newPassword;
          _newPasswordTextController?.clear();
          _confirmNewPasswordTextController?.clear();
        });
        Navigator.of(context).pop();
      }
    }).catchError((error) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showToast('Error while changing password. Please try again later.',
          AppThemes.errorColor);
    });
  }

  void _cancel() => Navigator.of(context).pop();

  void _showToast(String message, Color colour) => showToast(
        message,
        context: context,
        backgroundColor: colour,
        textStyle: const TextStyle(color: Colors.white, fontSize: 16.0),
        borderRadius: BorderRadius.circular(8),
        textPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        alignment: Alignment.bottomLeft,
        duration: const Duration(seconds: 4),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: CustomAppbar(
          title: 'Edit Profile',
          routeToPush: Routes.ACCOUNT,
          args: {
            'userEmail': updatedEmail ?? widget.user.email,
            'userLocation': widget.userLocation
          },
        ),
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 36, 0, 0),
                ),
                _buildChangeDetailGroup(),
              ]),
            )));
  }

  Widget _buildChangeDetailGroup() {
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
              offset: const Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildChangeUsername(),
                _buildDivider(),
                _buildChangeEmail(),
                _buildDivider(),
                _buildChangePassword(),
              ],
            )),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
      thickness: .5,
    );
  }

  Padding _buildChangeUsername() => Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
          onTap: () {
            _openChangeUsernameBottomSheet();
          },
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Change Username',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                    child: Text(
                      updatedUsername ?? widget.user.username,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(.6),
                          ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 14,
                  )
                ])
              ])));

  void _openChangeUsernameBottomSheet() => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
            padding: modalPadding(context),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              buildModalTitle('Change Username', context),
              const SizedBox(height: 16),
              _buildUsernameInputField(
                'New Username',
                'Enter a new username',
                _newUsernameTextController,
                _newUsernameFocusNode,
                _newUsernameTextControllerValidator,
              ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                buildModalButton(
                    'Cancel', _cancel, Theme.of(context).colorScheme.onPrimary),
                buildModalButton(
                    'Save', _changeUsername, AppThemes.successColor),
              ]),
              const SizedBox(height: 36),
            ]));
      });

  Padding _buildUsernameInputField(
    String labelText,
    String hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(BuildContext, String?)? validator,
  ) =>
      Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              enabledBorder: outlineInputBorder(
                Theme.of(context).colorScheme.onPrimary.withOpacity(.4),
              ),
              focusedBorder: outlineInputBorder(AppThemes.infoColor),
              errorBorder:
                  outlineInputBorder(Theme.of(context).colorScheme.error),
              focusedErrorBorder: outlineInputBorder(AppThemes.infoColor),
              contentPadding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
            ),
            keyboardType: TextInputType.name,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            style: Theme.of(context).textTheme.bodyMedium,
            validator: validator.asValidator(context),
          ));

  Padding _buildChangeEmail() => Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
          onTap: () {
            _openChangeEmailBottomSheet();
          },
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Change Email',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                    child: Text(
                      updatedEmail ?? widget.user.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(.6),
                          ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 14,
                  )
                ])
              ])));

  void _openChangeEmailBottomSheet() => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
            padding: modalPadding(context),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              buildModalTitle('Change Email', context),
              const SizedBox(height: 16),
              _buildEmailInputField(
                'New email',
                'Enter your new email',
                _newEmailTextController,
                _newEmailFocusNode,
                _newEmailTextControllerValidator,
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                buildModalButton(
                    'Cancel', _cancel, Theme.of(context).colorScheme.onPrimary),
                buildModalButton('Save', _changeEmail, AppThemes.successColor),
              ]),
              const SizedBox(height: 36),
            ]));
      });

  Padding _buildEmailInputField(
    String labelText,
    String hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(BuildContext, String?)? validator,
  ) =>
      Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              enabledBorder: outlineInputBorder(
                Theme.of(context).colorScheme.onPrimary.withOpacity(.4),
              ),
              focusedBorder: outlineInputBorder(AppThemes.infoColor),
              errorBorder:
                  outlineInputBorder(Theme.of(context).colorScheme.error),
              focusedErrorBorder: outlineInputBorder(AppThemes.infoColor),
              contentPadding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
            ),
            keyboardType: TextInputType.emailAddress,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            style: Theme.of(context).textTheme.bodyMedium,
            validator: validator.asValidator(context),
          ));

  Padding _buildChangePassword() => Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
          onTap: () {
            _openChangePasswordBottomSheet();
          },
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Change Password',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 14,
                )
              ])));

  void _openChangePasswordBottomSheet() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: modalRectangleBorder(),
        builder: (
          BuildContext context,
        ) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: modalPadding(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildModalTitle('Change Password', context),
                    const SizedBox(height: 16),
                    _buildPasswordInputField(
                      'New password',
                      'Enter a new password',
                      _newPasswordTextController,
                      _newPasswordFocusNode,
                      _newPasswordTextControllerValidator,
                      _newPasswordVisibility,
                      false,
                      setModalState,
                    ),
                    _buildPasswordInputField(
                      'Confirm new password',
                      'Confirm new password',
                      _confirmNewPasswordTextController,
                      _confirmNewPasswordFocusNode,
                      _confirmNewPasswordTextControllerValidator,
                      _confirmNewPasswordVisibility,
                      true,
                      setModalState,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildModalButton(
                          'Cancel',
                          () => Navigator.of(context).pop(),
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                        buildModalButton(
                          'Save',
                          _changePassword,
                          AppThemes.successColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              );
            },
          );
        },
      );

  Padding _buildPasswordInputField(
    String labelText,
    String hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(BuildContext, String?)? validator,
    bool passwordVisibility,
    bool isConfirmedPassword,
    StateSetter setModalState,
  ) =>
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textCapitalization: TextCapitalization.none,
          obscureText: !passwordVisibility,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            enabledBorder: outlineInputBorder(
              Theme.of(context).colorScheme.onPrimary.withOpacity(.6),
            ),
            focusedBorder: outlineInputBorder(AppThemes.infoColor),
            errorBorder: outlineInputBorder(
              Theme.of(context).colorScheme.error,
            ),
            focusedErrorBorder: outlineInputBorder(AppThemes.infoColor),
            contentPadding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
            suffixIcon: InkWell(
              onTap: () {
                setModalState(() {
                  if (isConfirmedPassword) {
                    _confirmNewPasswordVisibility = !passwordVisibility;
                  } else {
                    _newPasswordVisibility = !passwordVisibility;
                  }
                });
              },
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                passwordVisibility
                    ? CupertinoIcons.eye_solid
                    : CupertinoIcons.eye_slash_fill,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 18,
              ),
            ),
          ),
          keyboardType: TextInputType.visiblePassword,
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
}
