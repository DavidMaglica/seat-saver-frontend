import 'package:TableReserver/themes/mobile_theme.dart';
import 'package:flutter/material.dart';

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
    display(ctx, text, MobileTheme.successColor);
  }

  static void displayInfo(BuildContext ctx, String text) {
    display(ctx, text, MobileTheme.infoColor);
  }

  static void displayWarning(BuildContext ctx, String text) {
    display(ctx, text, MobileTheme.warningColor);
  }

  static void displayError(BuildContext ctx, String text) {
    display(ctx, text, MobileTheme.errorColor);
  }
}
