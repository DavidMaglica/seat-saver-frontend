import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final Function() onPressed;

  const ActionButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) => Align(
    alignment: const AlignmentDirectional(0, 0),
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
      child: FFButtonWidget(
        onPressed: onPressed,
        text: title,
        icon: iconData != null ? Icon(iconData, size: 16) : null,
        options: FFButtonOptions(
          width: 270,
          height: 50,
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          color: Theme.of(context).colorScheme.primary,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
