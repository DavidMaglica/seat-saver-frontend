import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/pages/web/auth/authentication.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/utils.dart';

class WebLanding extends StatefulWidget {
  const WebLanding({super.key});

  @override
  State<WebLanding> createState() => _WebLandingState();
}

class _WebLandingState extends State<WebLanding> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, AnimationInfo> animationsMap = Animations.landingAnimations;

  @override
  void initState() {
    super.initState();
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
                      _buildLogo().animateOnPageLoad(
                        animationsMap['logoOnLoad']!,
                      ),
                      const SizedBox(height: 44),
                      _buildTitle(
                        context,
                      ).animateOnPageLoad(animationsMap['textOnLoad']!),
                    ],
                  ),
                ),
              ),
            ),
            _buildButton(
              context,
            ).animateOnPageLoad(animationsMap['buttonOnLoad']!),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(shape: BoxShape.circle),
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
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Welcome to your TableReserver Admin Dashboard!',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge,
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
      ),
    );
  }
}
