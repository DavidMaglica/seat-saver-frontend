import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void ignoreOverflowErrors() {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
      return;
    }
    originalOnError?.call(details);
  };
}

void maximizeTestWindow(WidgetTester tester) async {
  tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
  tester.binding.window.devicePixelRatioTestValue = 1.0;
}
