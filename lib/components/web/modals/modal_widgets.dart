import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/themes/web_theme.dart';

enum SupportModalType { featureRequest, bugReport }

enum DeleteModalType { venue, reservation }

Widget buildButtons(BuildContext context, VoidCallback onSubmit, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FFButtonWidget(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Cancel',
          options: FFButtonOptions(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: WebTheme.errorColor,
            textStyle: const TextStyle(
              color: WebTheme.offWhite,
              fontFamily: 'Oswald',
              fontSize: 18,
            ),
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        FFButtonWidget(
          onPressed: () => onSubmit(),
          text: label,
          options: FFButtonOptions(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: WebTheme.successColor,
            textStyle: const TextStyle(
              color: WebTheme.offWhite,
              fontFamily: 'Oswald',
              fontSize: 18,
            ),
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    ),
  );
}

Widget buildTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 24, top: 24),
    child: Text(title, style: Theme.of(context).textTheme.titleLarge),
  );
}
