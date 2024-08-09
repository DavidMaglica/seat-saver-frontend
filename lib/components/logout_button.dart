import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class LogOutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogOutButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 36.0, 0.0, 0.0),
      child: FFButtonWidget(
        onPressed: onPressed,
        text: 'Log Out',
        options: FFButtonOptions(
          width: 150.0,
          height: 44.0,
          color: Theme.of(context).colorScheme.onError,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontSize: 16,
          ),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
