import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

Widget buildModalTitle(BuildContext context, String key, String title) {
  return Padding(
    key: Key(key),
    padding: const EdgeInsets.only(left: 24, bottom: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(title, style: Theme.of(context).textTheme.titleMedium)],
      ),
    ),
  );
}

Widget buildModalButton(
  String key,
  String text,
  Function() onPressed,
  Color buttonColour,
) {
  return Align(
    alignment: const AlignmentDirectional(-1, 0),
    child: CupertinoButton(
      key: Key(key),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: buttonColour, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
