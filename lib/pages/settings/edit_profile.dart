import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../api/data/user.dart';
import '../../components/custom_appbar.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import '../../models/edit_profile_model.dart';
import 'utils/settings_utils.dart';

class EditProfile extends StatelessWidget {
  final User user;
  final Position? userLocation;

  const EditProfile({
    Key? key,
    required this.user,
    this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileModel(
        user: user,
        context: context,
        userLocation: userLocation,
      ),
      child: Consumer<EditProfileModel>(
        builder: (context, model, _) {
          return Scaffold(
            key: model.scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppbar(
              title: 'Edit Profile',
              onBack: () => Navigator.of(context).pushNamed(
                Routes.ACCOUNT,
                arguments: {
                  'userEmail': model.updatedEmail ?? user.email,
                  'userLocation': userLocation,
                },
              ),
            ),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 36),
                    _buildChangeDetailGroup(context, model),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChangeDetailGroup(BuildContext context, EditProfileModel model) {
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
              _buildChangeUsername(context, model),
              _buildDivider(context),
              _buildChangeEmail(context, model),
              _buildDivider(context),
              _buildChangePassword(context, model),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
      thickness: .5,
    );
  }

  Widget _buildChangeUsername(BuildContext context, EditProfileModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
        onTap: () => _openChangeUsernameBottomSheet(context, model),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Change Username',
                style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: Text(
                    model.updatedUsername ?? model.user.username,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeEmail(BuildContext context, EditProfileModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
        onTap: () => _openChangeEmailBottomSheet(context, model),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Change Email',
                style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: Text(
                    model.updatedEmail ?? model.user.email,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePassword(BuildContext context, EditProfileModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
        onTap: () => _openChangePasswordBottomSheet(context, model),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Change Password',
                style: Theme.of(context).textTheme.titleMedium),
            Icon(
              CupertinoIcons.chevron_right,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _openChangeUsernameBottomSheet(
    BuildContext context,
    EditProfileModel model,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: modalPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildModalTitle('Change Username', context),
              const SizedBox(height: 16),
              _buildInputField('New Username', 'Enter a new username',
                  model.newUsernameTextController, model.newUsernameFocusNode),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildModalButton('Cancel', model.cancel,
                      Theme.of(context).colorScheme.onPrimary),
                  buildModalButton(
                      'Save', model.changeUsername, AppThemes.successColor),
                ],
              ),
              const SizedBox(height: 36),
            ],
          ),
        );
      },
    );
  }

  void _openChangeEmailBottomSheet(
    BuildContext context,
    EditProfileModel model,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: modalPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildModalTitle('Change Email', context),
              const SizedBox(height: 16),
              _buildInputField('New Email', 'Enter your new email',
                  model.newEmailTextController, model.newEmailFocusNode),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildModalButton('Cancel', model.cancel,
                      Theme.of(context).colorScheme.onPrimary),
                  buildModalButton(
                      'Save', model.changeEmail, AppThemes.successColor),
                ],
              ),
              const SizedBox(height: 36),
            ],
          ),
        );
      },
    );
  }

  void _openChangePasswordBottomSheet(
    BuildContext context,
    EditProfileModel model,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: modalPadding(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildModalTitle('Change Password', context),
                  const SizedBox(height: 16),
                  _buildPasswordInputField(
                      'New Password',
                      'Enter a new password',
                      model.newPasswordTextController,
                      model.newPasswordFocusNode,
                      model.newPasswordVisibility, () {
                    setModalState(() => model.newPasswordVisibility =
                        !model.newPasswordVisibility);
                  }),
                  _buildPasswordInputField(
                      'Confirm New Password',
                      'Confirm your password',
                      model.confirmNewPasswordTextController,
                      model.confirmNewPasswordFocusNode,
                      model.confirmNewPasswordVisibility, () {
                    setModalState(() => model.confirmNewPasswordVisibility =
                        !model.confirmNewPasswordVisibility);
                  }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildModalButton('Cancel', model.cancel,
                          Theme.of(context).colorScheme.onPrimary),
                      buildModalButton(
                          'Save', model.changePassword, AppThemes.successColor),
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
  }

  Widget _buildInputField(String labelText, String hint,
      TextEditingController controller, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _buildPasswordInputField(
    String labelText,
    String hint,
    TextEditingController controller,
    FocusNode focusNode,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hint,
          suffixIcon: IconButton(
            icon: Icon(isVisible
                ? CupertinoIcons.eye_solid
                : CupertinoIcons.eye_slash_fill),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
