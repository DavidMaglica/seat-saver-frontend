import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  FocusNode? _newNameAndSurnameFocusNode;
  TextEditingController? _newNameAndSurnameTextController;
  String? Function(BuildContext, String?)?
      _newNameAndSurnameTextControllerValidator;

  bool _oldPasswordVisibility = false;

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

  String updatedNameAndSurname = '';
  String updatedPassword = '';

  @override
  void initState() {
    super.initState();

    _newPasswordTextController = TextEditingController();
    _confirmNewPasswordTextController = TextEditingController();

    _newNameAndSurnameTextController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _newNameAndSurnameFocusNode?.dispose();
    _newNameAndSurnameTextController?.dispose();

    _newPasswordFocusNode?.dispose();
    _newPasswordTextController?.dispose();

    _confirmNewPasswordFocusNode?.dispose();
    _confirmNewPasswordTextController?.dispose();

    super.dispose();
  }

  void _changeNameAndSurname() {
    String? newName = _newNameAndSurnameTextController?.text;

    if (newName.isNullOrEmpty) {
      _showToast('Please enter a new name and surname', AppThemes.errorColor);
      return;
    }

    changeNameAndSurname(widget.user.email, newName!).then((response) {
      _showToast(response.message,
          response.success ? AppThemes.successColor : AppThemes.errorColor);

      if (response.success) {
        setState(() {
          updatedNameAndSurname = newName;
          _newNameAndSurnameTextController?.clear();
        });
        Navigator.of(context).pop();
      }
    }).catchError((error) {
      _showToast(
          'Error while changing name and surname. Please try again later.',
          AppThemes.errorColor);
    });
  }

  void _changePassword() {
    String? newPassword = _newPasswordTextController?.text;
    String? confirmNewPassword = _confirmNewPasswordTextController?.text;

    if (newPassword == null || newPassword.isEmpty) {
      _showToast('Please enter a new password', AppThemes.errorColor);
      return;
    }

    if (confirmNewPassword == null || confirmNewPassword.isEmpty) {
      _showToast("New password hasn't been confirmed", AppThemes.errorColor);
      return;
    }

    if (newPassword.length < 8) {
      _showToast(
          'Password must be at least 8 characters long', AppThemes.errorColor);
      return;
    }

    if (newPassword != confirmNewPassword) {
      _showToast('Passwords do not match', AppThemes.errorColor);
      return;
    }

    changePasswordByEmail(widget.user.email, newPassword)
        .then((response) async {
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
          args: {'userEmail': widget.user.email, 'userLocation': widget.userLocation},
        ),
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 36, 0, 0),
                ),
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: _buildAccountDetails()),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      buildOpenBottomSheetButton(
                          'Change name', _openNameModalBottomSheet, context),
                      buildOpenBottomSheetButton('Change password',
                          _openPasswordModalBottomSheet, context),
                    ])
              ]),
            )));
  }

  Padding _buildBodyText(String detail, String text,
          {bool isPassword = false}) =>
      Padding(
          padding:
              EdgeInsetsDirectional.fromSTEB(0, isPassword ? 24 : 36, 0, 0),
          child: isPassword
              ? Row(children: [
                  Expanded(
                      child: RichText(
                          text: TextSpan(
                    children: [
                      TextSpan(
                          text: '$detail: ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              _oldPasswordVisibility ? text : '•' * text.length,
                          style: Theme.of(context).textTheme.bodyLarge)
                    ],
                  ))),
                  IconButton(
                      icon: Icon(
                        _oldPasswordVisibility
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_solid,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        setState(() {
                          _oldPasswordVisibility = !_oldPasswordVisibility;
                        });
                      })
                ])
              : RichText(
                  text: TextSpan(children: [
                  TextSpan(
                    text: '$detail: ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ])));

  Padding _buildAccountDetails() => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEditProfileTitle('Your account details', context),
          _buildBodyText('Email', widget.user.email),
          _buildBodyText(
              'Name and Surname',
              updatedNameAndSurname.isNotNullAndNotEmpty
                  ? updatedNameAndSurname
                  : widget.user.nameAndSurname),
          _buildBodyText(
              'Password',
              updatedPassword.isNotNullAndNotEmpty
                  ? updatedPassword
                  : widget.user.password,
              isPassword: true),
        ],
      ));

  void _openNameModalBottomSheet() => showModalBottomSheet(
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
              buildModalTitle('Change Name and Surname', context),
              const SizedBox(height: 16),
              _buildNameInputField(
                'New name',
                'Enter a new name and surname',
                _newNameAndSurnameTextController,
                _newNameAndSurnameFocusNode,
                _newNameAndSurnameTextControllerValidator,
              ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                buildModalButton('Cancel', _cancel, AppThemes.errorColor),
                buildModalButton(
                    'Save', _changeNameAndSurname, AppThemes.successColor),
              ]),
              const SizedBox(height: 36),
            ]));
      });

  Padding _buildNameInputField(
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
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              enabledBorder:
                  outlineInputBorder(Theme.of(context).colorScheme.onPrimary),
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

  void _openPasswordModalBottomSheet() => showModalBottomSheet(
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
                          AppThemes.errorColor,
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
          textCapitalization: TextCapitalization.words,
          obscureText: !passwordVisibility,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            enabledBorder: outlineInputBorder(
              Theme.of(context).colorScheme.onPrimary,
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
