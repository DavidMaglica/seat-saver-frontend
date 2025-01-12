import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/account_api.dart';
import '../../api/data/user.dart';
import '../../api/data/user_response.dart';
import '../../components/navbar.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import '../../utils/routing_utils.dart';

class Account extends StatefulWidget {
  final String? userEmail;
  final Position? userLocation;

  const Account({
    Key? key,
    this.userEmail,
    this.userLocation,
  }) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  final unfocusNode = FocusNode();
  final int pageIndex = 3;
  User? user;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    if (widget.userEmail != null && widget.userEmail != '') {
      _getUserByEmail(widget.userEmail!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    super.dispose();
  }

  Future<void> _getUserByEmail(String email) async {
    UserResponse? response = await getUser(email);
    if (response != null && response.success) {
      setState(() => user = response.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 96, 0, 0)),
                  _buildAccountDetails(user),
                  _buildHistorySettings(user),
                  _buildAccountSettings(user),
                  _buildApplicationSettings(user),
                  _buildOpenAuthentication(user?.email)
                ],
              ),
            ),
            bottomNavigationBar: NavBar(
                context: context,
                currentIndex: pageIndex,
                onTap: (index, context) {
                  onNavbarItemTapped(pageIndex, index, context,
                      widget.userEmail, widget.userLocation);
                })));
  }

  Padding _buildHistoryTitle(String title) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ));

  Column _buildHistorySettings(User? user) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildHistoryTitle('Reservations'),
        _buildSettingsItem(
            CupertinoIcons.doc_on_clipboard,
            'Reservation history',
            Routes.RESERVATION_HISTORY,
            user,
            'view your reservation history'),
      ]);

  Padding _buildSettingsTitle(String title) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ));

  Column _buildAccountSettings(User? user) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildSettingsTitle('Account Settings'),
        _buildSettingsItem(CupertinoIcons.person_circle_fill, 'Edit profile',
            Routes.EDIT_PROFILE, user, 'edit your profile'),
        _buildSettingsItem(
            CupertinoIcons.bell_circle_fill,
            'Notification settings',
            Routes.NOTIFICATION_SETTINGS,
            user,
            'edit notification settings'),
      ]);

  Column _buildApplicationSettings(User? user) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildSettingsTitle('Application Settings'),
        _buildSettingsItem(CupertinoIcons.question_circle_fill, 'Support',
            Routes.SUPPORT, user, 'access support'),
        _buildSettingsItem(CupertinoIcons.exclamationmark_shield_fill,
            'Terms of service', Routes.TERMS_OF_SERVICE, user, null),
      ]);

  Padding _buildSettingsItem(IconData icon, String text, String route,
          User? user, String? action) =>
      Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
          child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withOpacity(.3),
                    offset: const Offset(0, 0),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: InkWell(
                      onTap: () async {
                        if (route == Routes.TERMS_OF_SERVICE) {
                          Navigator.pushNamed(context, route, arguments: {
                            'userEmail': user?.email,
                            'userLocation': widget.userLocation
                          });
                          return;
                        }
                        if (user == null) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please log in to $action.'),
                              backgroundColor: AppThemes.infoColor));
                          return;
                        }
                        Navigator.pushNamed(context, route, arguments: {
                          'user': user,
                          'userLocation': widget.userLocation
                        });
                      },
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        Icon(
                          icon,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 24,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            text,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          CupertinoIcons.chevron_forward,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 14,
                        )
                      ])))));

  Column _buildAccountDetails(User? user) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
          child: Text(
            user?.username ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
          child: Text(
            user?.email ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        )
      ]);

  Widget _buildOpenAuthentication(String? userEmail) {
    return Padding(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 48),
        child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: userEmail != null
                      ? Theme.of(context).colorScheme.error.withOpacity(.5)
                      : AppThemes.successColor.withOpacity(.5),
                  offset: const Offset(0, 0),
                )
              ],
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: InkWell(
                    onTap: () async {
                      if (!mounted) return;
                      Navigator.pushNamed(context, Routes.AUTHENTICATION);
                    },
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Text(
                          userEmail != null ? 'Log out' : 'Log in',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: userEmail != null
                                        ? Theme.of(context).colorScheme.error
                                        : AppThemes.successColor,
                                  ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        CupertinoIcons.chevron_forward,
                        color: userEmail != null
                            ? Theme.of(context).colorScheme.error
                            : AppThemes.successColor,
                        size: 14,
                      )
                    ])))));
  }
}
