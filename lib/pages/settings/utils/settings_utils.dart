import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

Align buildActionButton(BuildContext context, String title,
        Function() onPressed, IconData? iconData) =>
    Align(
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
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 16,
                  ),
                  elevation: 3,
                  borderRadius: BorderRadius.circular(8),
                ))));

OutlineInputBorder outlineInputBorder(Color colour) => OutlineInputBorder(
      borderSide: BorderSide(color: colour, width: .5),
      borderRadius: BorderRadius.circular(8),
    );

EdgeInsets modalPadding(BuildContext context) => EdgeInsets.only(
  bottom: MediaQuery.of(context).viewInsets.bottom,
  left: 16,
  right: 16,
  top: 16,
);

RoundedRectangleBorder modalRectangleBorder() => const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)));