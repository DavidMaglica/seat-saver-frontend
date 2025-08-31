// This file is ONLY compiled on the web platform
import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart';

Widget buildGoogleButton() {
  return Align(
    alignment: const AlignmentDirectional(0, 0),
    child: renderButton(
      configuration: GSIButtonConfiguration(
        type: GSIButtonType.icon,
        theme: GSIButtonTheme.outline,
        shape: GSIButtonShape.pill,
      ),
    ),
  );
}
