import 'package:TableReserver/models/mobile/landing_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LandingModel(context: context),
      builder: (context, _) {
        final model = context.watch<LandingModel>();
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
                key: model.scaffoldKey,
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
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(96),
                            child: const Image(
                              image: AssetImage('assets/icons/appIcon.png'),
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          'Welcome to TableReserver',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        FFButtonWidget(
                          onPressed: () => model.sendToMainPage(),
                          text: 'Get Started',
                          options: FFButtonOptions(
                            width: 270,
                            height: 44,
                            color: AppThemes.successColor,
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.background,
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
            ));
      },
    );
  }
}
