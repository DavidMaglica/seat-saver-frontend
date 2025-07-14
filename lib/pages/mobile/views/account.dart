import 'package:TableReserver/api/data/user.dart';
import 'package:TableReserver/components/mobile/navbar.dart';
import 'package:TableReserver/models/mobile/account_model.dart';
import 'package:TableReserver/themes/mobile_theme.dart';
import 'package:TableReserver/utils/routes.dart';
import 'package:TableReserver/utils/routing_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  final int? userId;
  final Position? userLocation;

  const Account({super.key, this.userId, this.userLocation});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountModel(
        context: context,
        userId: userId,
        userLocation: userLocation,
      )..init(),
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
                      _buildOpenAuthentication(context, model.currentUser?.email),
                    ],
                  ),
                ),
                bottomNavigationBar: NavBar(
                  currentIndex: model.pageIndex,
                  onTap: (index, context) => onNavbarItemTapped(
                    context,
                    model.pageIndex,
                    index,
                    userId,
                    userLocation,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext ctx, String title) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
      child: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
    );
  }

  Widget _buildAccountDetails(BuildContext ctx, User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
          child: Text(
            user?.username ?? '',
            style: Theme.of(ctx).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
          child: Text(
            user?.email ?? '',
            style: Theme.of(ctx).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext ctx,
    AccountModel model,
    IconData icon,
    String text,
    String route,
    String? action,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.background,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 3,
              offset: const Offset(0, 1),
              color: Theme.of(ctx).colorScheme.outline,
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => model.openSettingsItem(route, action),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(ctx).colorScheme.onPrimary),
                const SizedBox(width: 12),
                Text(text, style: Theme.of(ctx).textTheme.titleMedium),
                const Spacer(),
                Icon(CupertinoIcons.chevron_forward,
                    size: 14, color: Theme.of(ctx).colorScheme.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySettings(BuildContext ctx, AccountModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(ctx, 'Reservations'),
        _buildSettingsItem(
          ctx,
          model,
          CupertinoIcons.doc_on_clipboard,
          'Reservation history',
          Routes.reservationHistory,
          'view your reservation history',
        ),
      ],
    );
  }

  Widget _buildAccountSettings(BuildContext ctx, AccountModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(ctx, 'Account Settings'),
        _buildSettingsItem(
          ctx,
          model,
          CupertinoIcons.person_circle_fill,
          'Edit profile',
          Routes.editProfile,
          'edit your profile',
        ),
        _buildSettingsItem(
          ctx,
          model,
          CupertinoIcons.bell_circle_fill,
          'Notification settings',
          Routes.notificationSettings,
          'edit notification settings',
        ),
      ],
    );
  }

  Widget _buildApplicationSettings(BuildContext ctx, AccountModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(ctx, 'Application Settings'),
        _buildSettingsItem(
          ctx,
          model,
          CupertinoIcons.question_circle_fill,
          'Support',
          Routes.support,
          'access support',
        ),
        _buildSettingsItem(
          ctx,
          model,
          CupertinoIcons.exclamationmark_shield_fill,
          'Terms of service',
          Routes.termsOfService,
          null,
        ),
      ],
    );
  }

  Widget _buildOpenAuthentication(BuildContext ctx, String? userEmail) {
    final isLoggedIn = userEmail != null;
    final text = isLoggedIn ? 'Log out' : 'Log in';
    final color =
        isLoggedIn ? Theme.of(ctx).colorScheme.error : MobileTheme.successColor;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 48, 12, 0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.background,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: color.withOpacity(0.8),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => Navigator.pushNamed(ctx, Routes.authentication),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  text,
                  style: Theme.of(ctx)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: color.withOpacity(0.8)),
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
