import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/themes/mobile_theme.dart';

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
        color: MobileTheme.successColor,
        textStyle: TextStyle(color: MobileTheme.offWhite, fontSize: 16),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
