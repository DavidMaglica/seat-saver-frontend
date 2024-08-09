import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const SettingsItem({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const Spacer(),
        Icon(
          CupertinoIcons.chevron_forward,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
      ],
    );
  }
}
