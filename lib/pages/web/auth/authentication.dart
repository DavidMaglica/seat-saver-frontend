import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:seat_saver/models/web/auth/authentication_model.dart';
import 'package:seat_saver/pages/web/auth/log_in_tab.dart';
import 'package:seat_saver/pages/web/auth/sign_up_tab.dart';
import 'package:seat_saver/themes/web_theme.dart';
import 'package:seat_saver/utils/utils.dart';

class WebAuthentication extends StatefulWidget {
  const WebAuthentication({super.key});

  @override
  State<WebAuthentication> createState() => _WebAuthenticationState();
}

class _WebAuthenticationState extends State<WebAuthentication>
    with TickerProviderStateMixin {
  late AuthenticationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthenticationModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 500,
                decoration: webBackgroundGradient(context),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: webBackgroundAuxiliaryGradient(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child:
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.8,
                                  constraints: const BoxConstraints(
                                    maxWidth: 562,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16),
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
                                        Align(
                                          alignment: const Alignment(0, 0),
                                          child: _buildTabBar(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ).animateOnPageLoad(
                                  _model.animationsMap['authOnLoad']!,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      labelColor: WebTheme.accent1,
      unselectedLabelColor: Theme.of(context).colorScheme.onSecondary,
      labelStyle: Theme.of(context).textTheme.titleMedium,
      unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
      indicatorColor: WebTheme.accent1,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 3,
      dividerColor: Colors.transparent,
      tabs: const [
        Tab(key: Key('signUpTab'), text: 'Sign Up'),
        Tab(key: Key('logInTab'), text: 'Log In'),
      ],
      controller: _model.tabBarController,
      onTap: (i) async {
        [() async {}, () async {}][i]();
      },
    );
  }
}
