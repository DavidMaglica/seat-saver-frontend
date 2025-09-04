import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final String keyName;
  final IconData? iconData;
  final Function() onPressed;

  const ActionButton({
    super.key,
    required this.title,
    required this.keyName,
    required this.onPressed,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) => Align(
    alignment: const AlignmentDirectional(0, 0),
    child: FFButtonWidget(
      key: Key(keyName),
      onPressed: onPressed,
      text: title,
      icon: iconData != null ? Icon(iconData, size: 16) : null,
      options: FFButtonOptions(
        width: 270,
        height: 50,
        color: Theme.of(context).colorScheme.primary,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
        ),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
