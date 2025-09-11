import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seat_saver/themes/web_theme.dart';
import 'package:toastification/toastification.dart';

class WebToaster {
  static ToastificationItem _display({
    required BuildContext context,
    required String title,
    required String message,
    required ToastificationType type,
    required Icon icon,
    required Color progressBarColor,
  }) {
    return toastification.show(
      context: context,
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: progressBarColor),
      ),
      description: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: progressBarColor),
      ),
      type: type,
      style: ToastificationStyle.flatColored,
      borderRadius: BorderRadius.circular(8),
      showIcon: true,
      icon: icon,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: progressBarColor,
        linearTrackColor: WebTheme.offWhite,
      ),
      autoCloseDuration: const Duration(seconds: 5),
      applyBlurEffect: false,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static ToastificationItem displaySuccess(
    BuildContext context,
    String message,
  ) {
    return _display(
      context: context,
      title: 'Success',
      message: message,
      type: ToastificationType.success,
      icon: const Icon(
        CupertinoIcons.check_mark_circled,
        color: WebTheme.successColor,
      ),
      progressBarColor: WebTheme.successColor,
    );
  }

  static ToastificationItem displayInfo(BuildContext context, String message) {
    return _display(
      context: context,
      title: 'Info',
      message: message,
      type: ToastificationType.info,
      icon: const Icon(CupertinoIcons.info_circle, color: WebTheme.infoColor),
      progressBarColor: WebTheme.infoColor,
    );
  }

  static ToastificationItem displayWarning(
    BuildContext context,
    String message,
  ) {
    return _display(
      context: context,
      title: 'Warning',
      message: message,
      type: ToastificationType.warning,
      icon: const Icon(
        CupertinoIcons.exclamationmark_triangle,
        color: WebTheme.warningColor,
      ),
      progressBarColor: WebTheme.warningColor,
    );
  }

  static ToastificationItem displayError(BuildContext context, String message) {
    return _display(
      context: context,
      title: 'Error',
      message: message,
      type: ToastificationType.error,
      icon: const Icon(CupertinoIcons.xmark_circle, color: WebTheme.errorColor),
      progressBarColor: WebTheme.errorColor,
    );
  }
}
