import 'package:TableReserver/models/web/authentication_model.dart';
import 'package:TableReserver/pages/web/auth/log_in_tab.dart';
import 'package:TableReserver/pages/web/auth/sign_up_tab.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:TableReserver/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

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
      initialIndex: 1,
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
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.sizeOf(context).height * 0.8,
                              constraints: const BoxConstraints(
                                maxWidth: 562,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
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
                            ).animateOnPageLoad(_model.animationsMap[
                                'containerOnPageLoadAnimation']!),
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
      labelColor: Theme.of(context).colorScheme.onPrimary,
      unselectedLabelColor: Theme.of(context).colorScheme.onSecondary,
      labelStyle: Theme.of(context).textTheme.titleMedium,
      unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
      indicatorColor: WebTheme.successColor,
      indicatorWeight: 3,
      tabs: const [
        Tab(
          text: 'Sign Up',
        ),
        Tab(
          text: 'Log In',
        ),
      ],
      controller: _model.tabBarController,
      onTap: (i) async {
        [() async {}, () async {}][i]();
      },
    );
  }
}
