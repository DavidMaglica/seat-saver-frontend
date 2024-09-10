import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

Padding buildEditProfileTitle(String title, BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
    child: Text(title, style: Theme.of(context).textTheme.titleLarge));

Align buildOpenBottomSheetButton(
        String title, Function() onPressed, BuildContext context) =>
    Align(
        alignment: const AlignmentDirectional(0, 0),
        child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 72, 8, 0),
            child: FFButtonWidget(
                onPressed: onPressed,
                showLoadingIndicator: false,
                text: title,
                options: FFButtonOptions(
                  width: 196,
                  height: 40,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 1,
                  ),
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: Theme.of(context).colorScheme.background,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                  ),
                  elevation: 3,
                  borderRadius: BorderRadius.circular(8),
                ))));

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

Align buildModalButton(
        String title, Function() onPressed, Color buttonColour) =>
    Align(
        alignment: const AlignmentDirectional(-1, 0),
        child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
            child: FFButtonWidget(
                onPressed: onPressed,
                showLoadingIndicator: false,
                text: title,
                options: FFButtonOptions(
                  width: 142,
                  height: 40,
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: buttonColour,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  elevation: 3,
                  borderRadius: BorderRadius.circular(8),
                ))));
