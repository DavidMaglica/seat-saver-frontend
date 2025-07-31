import 'package:TableReserver/models/web/landing_model.dart';
import 'package:TableReserver/pages/web/auth/authentication.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:TableReserver/utils/fade_in_route.dart';
import 'package:TableReserver/utils/routes.dart';
import 'package:TableReserver/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class WebLanding extends StatefulWidget {
  const WebLanding({super.key});

  @override
  State<WebLanding> createState() => _WebLandingState();
}

class _WebLandingState extends State<WebLanding> with TickerProviderStateMixin {
  late LandingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LandingModel());
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
                      _buildLogo(),
                      _buildTitle(context),
                    ],
                  ),
                ),
              ).animateOnPageLoad(
                _model.animationsMap['containerOnPageLoadAnimation1']!,
              ),
            ),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/icons/appIcon.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ).animateOnPageLoad(_model.animationsMap['containerOnPageLoadAnimation2']!);
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
      child: Text(
        'Welcome to your TableReserver Admin Dashboard!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ).animateOnPageLoad(
        _model.animationsMap['textOnPageLoadAnimation']!,
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 128),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: FFButtonWidget(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    FadeInRoute(
                      routeName: Routes.webAuthentication,
                      page: const WebAuthentication(),
                    ),
                  );
                },
                text: 'Get Started',
                options: FFButtonOptions(
                  width: 230,
                  height: 52,
                  color: WebTheme.successColor,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontFamily: 'Oswald',
                    fontSize: 18,
                  ),
                  elevation: 3,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ).animateOnPageLoad(_model.animationsMap['rowOnPageLoadAnimation']!),
    );
  }
}
