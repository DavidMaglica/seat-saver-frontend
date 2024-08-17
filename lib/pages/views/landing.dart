import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final unfocusNode = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
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
        body: SafeArea(
          top: true,
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
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(.4),
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
                  'Welcome to Our App',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                FFButtonWidget(
                  onPressed: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.pushNamed(
                      context,
                      '/homepage',
                    );
                  },
                  text: 'Get Started',
                  options: FFButtonOptions(
                    width: 270,
                    height: 44,
                    color: Theme.of(context).colorScheme.primary,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 16,
                    ),
                    elevation: 3,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
