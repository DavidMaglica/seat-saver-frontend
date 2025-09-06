import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/components/mobile/navbar.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/models/mobile/views/account_model.dart';
import 'package:table_reserver/pages/mobile/auth/authentication.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/routing_utils.dart';

class Account extends StatelessWidget {
  final int? userId;
  final AccountModel? modelOverride;

  const Account({super.key, this.userId, this.modelOverride});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => modelOverride ?? AccountModel(userId: userId)
        ..init(),
      child: Consumer<AccountModel>(
        builder: (context, model, _) {
          var brightness = Theme.of(context).brightness;
          return GestureDetector(
            onTap: () {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.unfocus();
              }
            },
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: brightness == Brightness.dark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              child: Scaffold(
                key: model.scaffoldKey,
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (model.userId != null) const SizedBox(height: 94),
                      _buildAccountDetails(context, model.currentUser),
                      _buildHistorySettings(context, model),
                      _buildAccountSettings(context, model),
                      _buildApplicationSettings(context, model),
                      const SizedBox(height: 48),
                      _buildOpenAuthentication(context),
                    ],
                  ),
                ),
                bottomNavigationBar: NavBar(
                  currentIndex: model.pageIndex,
                  onTap: (index, context) =>
                      onNavbarItemTapped(context, model.pageIndex, index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String key, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Text(
        key: Key(key),
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context, User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            key: const Key('usernameText'),
            user?.username ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            key: const Key('emailText'),
            user?.email ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context,
    AccountModel model,
    String key,
    IconData icon,
    String text,
    String route,
    String? action,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 3,
              offset: const Offset(0, 1),
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          key: Key(key),
          onTap: () => model.openSettingsItem(context, route, action),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
                const SizedBox(width: 12),
                Text(text, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 14,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySettings(BuildContext context, AccountModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildTitle(context, 'reservationHistoryTitle', 'Reservations'),
        const SizedBox(height: 12),
        _buildSettingsItem(
          context,
          model,
          'reservationHistoryButton',
          CupertinoIcons.doc_on_clipboard,
          'Reservation history',
          Routes.reservationHistory,
          'view your reservation history',
        ),
      ],
    );
  }

  Widget _buildAccountSettings(BuildContext context, AccountModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildTitle(context, 'accountSettingsTitle', 'Account Settings'),
        const SizedBox(height: 12),
        _buildSettingsItem(
          context,
          model,
          'editProfileButton',
          CupertinoIcons.person_circle_fill,
          'Edit profile',
          Routes.editProfile,
          'edit your profile',
        ),
        const SizedBox(height: 12),
        _buildSettingsItem(
          context,
          model,
          'notificationSettingsButton',
          CupertinoIcons.bell_circle_fill,
          'Notification settings',
          Routes.notificationSettings,
          'edit notification settings',
        ),
      ],
    );
  }

  Widget _buildApplicationSettings(BuildContext context, AccountModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildTitle(
          context,
          'applicationSettingsTitle',
          'Application Settings',
        ),
        const SizedBox(height: 12),
        _buildSettingsItem(
          context,
          model,
          'supportButton',
          CupertinoIcons.question_circle_fill,
          'Support',
          Routes.support,
          'access support',
        ),
        const SizedBox(height: 12),
        _buildSettingsItem(
          context,
          model,
          'termsOfServiceButton',
          CupertinoIcons.exclamationmark_shield_fill,
          'Terms of service',
          Routes.termsOfService,
          null,
        ),
      ],
    );
  }

  Widget _buildOpenAuthentication(BuildContext context) {
    final isLoggedIn = userId != null;
    final text = isLoggedIn ? 'Log out' : 'Log in';
    final color = isLoggedIn
        ? Theme.of(context).colorScheme.error
        : MobileTheme.successColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          boxShadow: [
            BoxShadow(blurRadius: 10, color: color.withValues(alpha: 0.8)),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          key: isLoggedIn
              ? const Key('logoutButton')
              : const Key('loginButton'),
          onTap: () {
            if (isLoggedIn) {
              sharedPreferencesCache.remove('userId');
              sharedPreferencesCache.remove('userLocation');
            }
            Navigator.of(context).push(
              MobileFadeInRoute(
                page: const Authentication(),
                routeName: Routes.authentication,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color.withValues(alpha: 0.8),
                  ),
                ),
                const Spacer(),
                Icon(CupertinoIcons.chevron_forward, color: color, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
