import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Padding buildModalTitle(String title, BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 8),
    child: Align(
        alignment: Alignment.centerLeft,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ])));

Align buildModalButton(String text, Function() onPressed, Color buttonColour) =>
    Align(
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
