import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(96),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.outline,
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(96),
                      child: const Image(
                        key: Key('logoImage'),
                        image: AssetImage('assets/icons/appIcon.png'),
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    key: const Key('welcomeText'),
                    'Welcome to TableReserver',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  FFButtonWidget(
                    key: const Key('getStartedButton'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MobileFadeInRoute(
                          page: const Homepage(),
                          routeName: Routes.homepage,
                        ),
                      );
                    },
                    text: 'Get Started',
                    options: FFButtonOptions(
                      width: 270,
                      height: 44,
                      color: MobileTheme.successColor,
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                      elevation: 5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
