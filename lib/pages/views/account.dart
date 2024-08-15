import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../components/navbar.dart';
import '../../utils/routing_utils.dart';
import '../settings/utils/settings_utils.dart';
import 'models/account_model.dart';

export 'models/account_model.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<Account> with TickerProviderStateMixin {
  late AccountModel _model;
  final int pageIndex = 3;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        buildProfilePicture(context)
                      ],
                    ),
                  ),
                  _buildAccountDetails(
                      'name surname', 'name.surname@email.com'),
                  _buildAccountSettings(),
                  _buildApplicationSettings(),
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
                  onNavbarItemTapped(pageIndex, index, context);
                })));
  }

  Padding _buildSettingsTitle(String title) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ));

  Column _buildAccountSettings() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildSettingsTitle('Account Settings'),
        _buildSettingsItem(
            CupertinoIcons.person_circle_fill, 'Edit profile', '/editProfile'),
        _buildSettingsItem(CupertinoIcons.bell_circle_fill,
            'Notification settings', '/notificationSettings'),
      ]);

  Column _buildApplicationSettings() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildSettingsTitle('Application Settings'),
        _buildSettingsItem(
            CupertinoIcons.question_circle_fill, 'Support', '/support'),
        _buildSettingsItem(CupertinoIcons.exclamationmark_shield_fill,
            'Terms of service', '/termsOfService'),
      ]);

  Padding _buildSettingsItem(IconData icon, String text, String route) =>
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
                        Navigator.pushNamed(context, route);
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

  Column _buildAccountDetails(String username, String email) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
          child: Text(
            'Name Surname',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
          child: Text(
            'name.surname@email.com',
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
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 16,
                ),
                elevation: 3,
                borderRadius: BorderRadius.circular(8),
              ))));
}
