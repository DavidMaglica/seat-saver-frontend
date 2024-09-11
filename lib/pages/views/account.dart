import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/account_api.dart';
import '../../api/data/user.dart';
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

    if (widget.userEmail != null) _getUserByEmail(widget.userEmail!);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> _getUserByEmail(String email) async {
    UserResponse? response = await getUserByEmail(email);
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
                  _buildAccountSettings(user),
                  _buildApplicationSettings(user),
                  _buildLogOutButton(user?.email, () async {
                    if (!mounted) return;
                    Navigator.pushNamed(context, Routes.AUTHENTICATION);
                  }),
                ],
              ),
            ),
            bottomNavigationBar: NavBar(
                context: context,
                currentIndex: pageIndex,
                onTap: (index, context) {
                  onNavbarItemTapped(
                      pageIndex, index, context, widget.userEmail, widget.userLocation);
                })));
  }

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
            Routes.EDIT_PROFILE, user),
        _buildSettingsItem(CupertinoIcons.bell_circle_fill,
            'Notification settings', Routes.NOTIFICATION_SETTINGS, user),
      ]);

  Column _buildApplicationSettings(User? user) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildSettingsTitle('Application Settings'),
        _buildSettingsItem(CupertinoIcons.question_circle_fill, 'Support',
            Routes.SUPPORT, user),
        _buildSettingsItem(CupertinoIcons.exclamationmark_shield_fill,
            'Terms of service', Routes.TERMS_OF_SERVICE, user),
      ]);

  Padding _buildSettingsItem(
          IconData icon, String text, String route, User? user) =>
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
                        Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
                    offset: const Offset(0, 1),
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
                          Navigator.pushNamed(context, route,
                              arguments: {'userEmail': user?.email, 'userLocation': widget.userLocation});
                          return;
                        }
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please log in to access this page'),
                                  backgroundColor: AppThemes.infoColor));
                          return;
                        }
                        Navigator.pushNamed(context, route,
                            arguments: {'user': user, 'userLocation': widget.userLocation});
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
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          CupertinoIcons.chevron_forward,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 24,
                        )
                      ])))));

  Column _buildAccountDetails(User? user) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
          child: Text(
            user?.nameAndSurname ?? '',
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

  Align _buildLogOutButton(String? email, Function() onPressed) => Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
          child: FFButtonWidget(
              onPressed: onPressed,
              text: email != null ? 'Log out' : 'Log in',
              options: FFButtonOptions(
                width: 270,
                height: 44,
                color: email != null
                    ? AppThemes.errorColor
                    : AppThemes.successColor,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                elevation: 3,
                borderRadius: BorderRadius.circular(8),
              ))));
}
