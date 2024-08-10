import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../components/logout_button.dart';
import '../components/navbar.dart';
import '../components/settings_item.dart';
import '../utils/routing_utils.dart';
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
        body: Column(
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
                  Align(
                    alignment: const AlignmentDirectional(-1, 1),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 16),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onPrimary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 500),
                              fadeOutDuration:
                                  const Duration(milliseconds: 500),
                              imageUrl:
                                  'https://images.unsplash.com/photo-1617644558945-ea1c43e5d0a8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxQdWxhfGVufDB8fHx8MTcxOTUxNjIyMXww&ixlib=rb-4.3&q=80&w=1080',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
              child: Text(
                'Account Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
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
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.4),
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
                      Navigator.pushNamed(context, '/editProfile');
                    },
                    child: const SettingsItem(
                      icon: CupertinoIcons.person_circle_fill,
                      text: 'Edit profile',
                    ),
                  ),
                ),
              ),
            ),
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
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.4),
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
                      Navigator.pushNamed(context, '/notificationSettings');
                    },
                    child: const SettingsItem(
                      icon: CupertinoIcons.bell_circle_fill,
                      text: 'Notification settings',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
              child: Text(
                'App Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
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
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.4),
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
                      Navigator.pushNamed(
                        context,
                        '/support',
                      );
                    },
                    child: const SettingsItem(
                      icon: CupertinoIcons.question_circle_fill,
                      text: 'Support',
                    ),
                  ),
                ),
              ),
            ),
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
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.4),
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
                      Navigator.pushNamed(
                        context,
                        '/termsOfService',
                      );
                    },
                    child: const SettingsItem(
                      icon: CupertinoIcons.exclamationmark_shield_fill,
                      text: 'Terms of service',
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: LogOutButton(
                onPressed: () async {
                  Navigator.pushNamed(context, '/landing');
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavBar(
          context: context,
          currentIndex: pageIndex,
          onTap: (index, context) {
            onNavbarItemTapped(pageIndex, index, context);
          },
        ),
      ),
    );
  }
}
