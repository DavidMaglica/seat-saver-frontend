import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/mobile/custom_appbar.dart';
import 'package:table_reserver/components/mobile/modal_widgets.dart';
import 'package:table_reserver/models/mobile/views/edit_profile_model.dart';
import 'package:table_reserver/pages/mobile/views/account.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class EditProfile extends StatelessWidget {
  final int userId;
  final EditProfileModel? modelOverride;

  const EditProfile({super.key, required this.userId, this.modelOverride});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => modelOverride ?? EditProfileModel(userId: userId)
        ..init(context),
      child: Consumer<EditProfileModel>(
        builder: (context, model, _) {
          if (model.currentUser == null) {
            return LoadingAnimationWidget.threeArchedCircle(
              color: MobileTheme.accent1,
              size: 75,
            );
          }
          return Scaffold(
            key: model.scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppbar(
              title: 'Edit Profile',
              onBack: () {
                Navigator.of(context).push(
                  MobileFadeInRoute(
                    page: const Account(),
                    routeName: Routes.account,
                  ),
                );
              },
            ),
            body: SafeArea(
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
          color: Theme.of(context).colorScheme.onSurface,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 2,
              color: Theme.of(context).colorScheme.outline,
              offset: const Offset(0, 1),
            ),
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
      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
      thickness: .5,
    );
  }

  Widget _buildChangeUsername(BuildContext context, EditProfileModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: InkWell(
        key: const Key('changeUsernameButton'),
        onTap: () => _openChangeUsernameBottomSheet(context, model),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Change Username',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: Text(
                    model.updatedUsername ?? model.currentUser!.username,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.6),
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
        key: const Key('changeEmailButton'),
        onTap: () => _openChangeEmailBottomSheet(context, model),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Change Email',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: Text(
                    model.updatedEmail ?? model.currentUser!.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.6),
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
        key: const Key('changePasswordButton'),
        onTap: () => _openChangePasswordBottomSheet(context, model),
        child: Row(
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
            ),
          ],
        ),
      ),
    );
  }

  void _openChangeUsernameBottomSheet(BuildContext context,
    EditProfileModel model,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          key: const Key('changeUsernameModal'),
          padding: modalPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              buildModalTitle(
                context,
                'changeUsernameModalTitle',
                'Change Username',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                context,
                'newUsernameField',
                'New Username',
                'Enter a new username',
                model.newUsernameTextController,
                model.newUsernameFocusNode,
                TextInputType.text,
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildModalButton(
                    'cancelModalButton',
                    'Cancel',
                    () => model.cancel(context),
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                  buildModalButton(
                    'saveModalButton',
                    'Save',
                    () => model.changeUsername(context),
                    MobileTheme.successColor,
                  ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          key: const Key('changeEmailModal'),
          padding: modalPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildModalTitle(context, 'changeEmailModalTitle', 'Change Email'),
              const SizedBox(height: 16),
              _buildInputField(
                context,
                'newEmailField',
                'New Email',
                'Enter your new email',
                model.newEmailTextController,
                model.newEmailFocusNode,
                TextInputType.emailAddress,
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildModalButton(
                    'cancelModalButton',
                    'Cancel',
                    () => model.cancel(context),
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                  buildModalButton(
                    'saveModalButton',
                    'Save',
                    () => model.changeEmail(context),
                    MobileTheme.successColor,
                  ),
                ],
              ),
              const SizedBox(height: 36),
            ],
          ),
        );
      },
    );
  }

  void _openChangePasswordBottomSheet(BuildContext context,
    EditProfileModel model,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              key: const Key('changePasswordModal'),
              padding: modalPadding(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildModalTitle(
                    context,
                    'changePasswordModalTitle',
                    'Change Password',
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordInputField(
                    context,
                    'newPasswordField',
                    'New Password',
                    'Enter a new password',
                    model.newPasswordTextController,
                    model.newPasswordFocusNode,
                    model.newPasswordVisibility,
                    () {
                      setModalState(
                        () => model.newPasswordVisibility =
                            !model.newPasswordVisibility,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordInputField(
                    context,
                    'confirmNewPasswordField',
                    'Confirm New Password',
                    'Confirm your password',
                    model.confirmNewPasswordTextController,
                    model.confirmNewPasswordFocusNode,
                    model.confirmNewPasswordVisibility,
                    () {
                      setModalState(
                        () => model.confirmNewPasswordVisibility =
                            !model.confirmNewPasswordVisibility,
                      );
                    },
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildModalButton(
                        'cancelModalButton',
                        'Cancel',
                        () => model.cancel(context),
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                      buildModalButton(
                        'saveModalButton',
                        'Save',
                        () => model.changePassword(context),
                        MobileTheme.successColor,
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
  }

  Widget _buildInputField(BuildContext context,
    String key,
    String labelText,
    String hint,
    TextEditingController controller,
    FocusNode focusNode,
    TextInputType keyboardType,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        key: Key(key),
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hint,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildPasswordInputField(BuildContext context,
    String key,
    String labelText,
    String hint,
    TextEditingController controller,
    FocusNode focusNode,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        key: Key(key),
        controller: controller,
        focusNode: focusNode,
        obscureText: !isVisible,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          hintText: hint,
          suffixIcon: IconButton(
            icon: Icon(
              isVisible
                  ? CupertinoIcons.eye_solid
                  : CupertinoIcons.eye_slash_fill,
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
