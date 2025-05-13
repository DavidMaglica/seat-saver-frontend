import 'package:flutter/material.dart';

import '../themes/theme.dart';

class Toaster {
  static void display(BuildContext ctx, String text, Color colour) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
          content: Text(text),
          backgroundColor: colour,
          duration: const Duration(seconds: 2)),
    );
  }

  static void displaySuccess(BuildContext ctx, String text) {
    display(ctx, text, AppThemes.successColor);
  }

  static void displayInfo(BuildContext ctx, String text) {
    display(ctx, text, AppThemes.infoColor);
  }

  static void displayWarning(BuildContext ctx, String text) {
    display(ctx, text, AppThemes.warningColor);
  }

  static void displayError(BuildContext ctx, String text) {
    display(ctx, text, AppThemes.errorColor);
  }
}
