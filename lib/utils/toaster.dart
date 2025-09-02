import 'package:flutter/material.dart';
import 'package:table_reserver/themes/mobile_theme.dart';

/// A utility class for displaying toast-style messages using Flutter's [SnackBar].
///
/// The `Toaster` provides convenient static methods to show snack bars with
/// pre-defined color themes for different types of messages:
/// success, info, warning, and error.
class Toaster {
  /// The background color used for success messages, same for mobile and web themes.
  static const Color successColor = Color(0xFF2E7D32);

  /// The background color used for error messages, same for mobile and web themes.
  static const Color errorColor = Color(0xFF800020);

  /// The background color used for warning messages, same for mobile and web themes.
  static const Color warningColor = Color(0xFFFF8F00);

  /// The background color used for informational messages, same for mobile and web themes.
  static const Color infoColor = Color(0xFF4392E1);

  /// Displays a [SnackBar] with the provided [text] and [colour].
  ///
  /// This method ensures any currently visible snack bar is hidden
  /// before showing a new one.
  ///
  /// - [ctx]: The current [BuildContext].
  /// - [text]: The message to display.
  /// - [colour]: The background color of the [SnackBar].
  static void display(BuildContext ctx, String text, Color colour) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(color: MobileTheme.offWhite)),
        elevation: 3,
        backgroundColor: colour,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Displays a success message using [successColor].
  static void displaySuccess(BuildContext ctx, String text) {
    display(ctx, text, successColor);
  }

  /// Displays an informational message using [infoColor].
  static void displayInfo(BuildContext ctx, String text) {
    display(ctx, text, infoColor);
  }

  /// Displays a warning message using [warningColor].
  static void displayWarning(BuildContext ctx, String text) {
    display(ctx, text, warningColor);
  }

  /// Displays an error message using [errorColor].
  static void displayError(BuildContext ctx, String text) {
    display(ctx, text, errorColor);
  }
}
