import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/models/mobile/auth/authentication_model.dart';
import 'package:table_reserver/pages/mobile/auth/log_in_tab.dart';
import 'package:table_reserver/pages/mobile/auth/sign_up_tab.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication>
    with TickerProviderStateMixin {
  late AuthenticationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final AccountApi accountApi = AccountApi();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthenticationModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height,
                      constraints: const BoxConstraints(maxWidth: 530),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          0,
                          16,
                          0,
                          0,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: TabBarView(
                                controller: _model.tabBarController,
                                children: [
                                  SignUpTab(model: _model),
                                  LogInTab(model: _model),
                                ],
                              ),
                            ),
                            MediaQuery.of(context).viewInsets.bottom == 0
                                ? Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                          horizontal: 0,
                                          vertical: 36,
                                        ),
                                    child: CupertinoButton(
                                      child: const Text(
                                        'Continue without account.',
                                        style: TextStyle(
                                          color: MobileTheme.infoColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MobileFadeInRoute(
                                            page: const Homepage(),
                                            routeName: Routes.homepage,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                            Align(
                              alignment: const Alignment(0, 0),
                              child: TabBar(
                                labelColor: MobileTheme.accent1,
                                unselectedLabelColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                labelStyle: Theme.of(
                                  context,
                                ).textTheme.titleMedium,
                                unselectedLabelStyle: Theme.of(
                                  context,
                                ).textTheme.titleSmall,
                                indicatorColor: MobileTheme.accent1,
                                indicatorWeight: 3,
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  16,
                                  0,
                                  16,
                                  0,
                                ),
                                tabs: const [
                                  Tab(text: 'Create Account'),
                                  Tab(text: 'Log In'),
                                ],
                                controller: _model.tabBarController,
                                onTap: (i) async {
                                  SystemChannels.textInput.invokeMethod(
                                    'TextInput.hide',
                                  );
                                  [() async {}, () async {}][i]();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
