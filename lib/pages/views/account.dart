import 'package:TableReserver/api/data/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../api/account_api.dart';
import '../../components/navbar.dart';
import '../../utils/routing_utils.dart';

class Account extends StatefulWidget {
  final String? email;

  const Account({
    Key? key,
    this.email,
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

    if (widget.email != null) _getUserByEmail(widget.email!);
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
                  _buildLogOutButton(() async {
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.pushNamed(context, '/authentication');
                  }),
                ],
              ),
            ),
            bottomNavigationBar: NavBar(
                context: context,
                currentIndex: pageIndex,
                onTap: (index, context) {
                  onNavbarItemTapped(pageIndex, index, context, widget.email);
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
            '/editProfile', user),
        _buildSettingsItem(CupertinoIcons.bell_circle_fill,
            'Notification settings', '/notificationSettings', user),
      ]);

  Column _buildApplicationSettings(User? user) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildSettingsTitle('Application Settings'),
        _buildSettingsItem(
            CupertinoIcons.question_circle_fill, 'Support', '/support', user),
        _buildSettingsItem(CupertinoIcons.exclamationmark_shield_fill,
            'Terms of service', '/termsOfService', null),
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
                        Navigator.pushNamed(context, route,
                            arguments: user != null ? {'user': user} : {});
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

  Align _buildLogOutButton(Function() onPressed) => Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
          child: FFButtonWidget(
              onPressed: onPressed,
              text: 'Log Out',
              options: FFButtonOptions(
                width: 270,
                height: 44,
                color: Theme.of(context).colorScheme.error,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                elevation: 3,
                borderRadius: BorderRadius.circular(8),
              ))));
}
