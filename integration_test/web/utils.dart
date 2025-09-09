import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void setupWebIntegrationTestErrorFilters() {
  final originalOnError = FlutterError.onError;

  FlutterError.onError = (details) {
    final eStr = details.exceptionAsString();
    final exception = details.exception;

    if (eStr.contains("setSelectionRange") &&
        eStr.contains("HTMLInputElement") &&
        eStr.contains("type ('email')")) {
      return;
    }

    if (eStr.contains('object._dirtyFields == 0')) {
      return;
    }

    if (exception is GoogleSignInException &&
        exception.code == GoogleSignInExceptionCode.canceled) {
      return;
    }

    if (eStr.contains('AnimationController.dispose() called more than once')) {
      return;
    }

    if (eStr.contains('inTest is not true')) {
      return;
    }

    originalOnError?.call(details);
  };
}