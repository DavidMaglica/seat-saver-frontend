import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

OutlineInputBorder outlineInputBorder(Color colour) => OutlineInputBorder(
      borderSide: BorderSide(color: colour, width: .5),
      borderRadius: BorderRadius.circular(8),
    );

EdgeInsets modalPadding(BuildContext ctx) => EdgeInsets.only(
      bottom: MediaQuery.of(ctx).viewInsets.bottom,
      left: 16,
      right: 16,
      top: 16,
    );

Widget buildModalTitle(BuildContext ctx, String title) {
  return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 8),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(
              title,
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
          ])));
}

Widget buildModalButton(String text, Function() onPressed, Color buttonColour) {
  return Align(
      alignment: const AlignmentDirectional(-1, 0),
      child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
          child: CupertinoButton(
              onPressed: onPressed,
              child: Text(text,
                  style: TextStyle(
                    color: buttonColour,
                    fontWeight: FontWeight.bold,
                  )))));
}
