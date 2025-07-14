import 'package:flutter/material.dart';

// Light theme colors
const Color lightPrimaryColor = Color(0xFF4CAF50);
const Color lightSecondaryColor = Color(0xFFFF9800);
const Color lightTertiaryColor = Color(0xFF03A9F4);
const Color lightAlternateColor = Color(0xFFFFC107);

const Color lightPrimaryTextColor = Color(0xFF212121);
const Color lightSecondaryTextColor = Color(0xFF757575);
const Color lightPrimaryBackgroundColor = Color(0xFFFFFFFF);
const Color lightSecondaryBackgroundColor = Color(0xFFFFFBF4);
const Color mutedLightSecondaryBackgroundColor = Color(0x40E0DDDD);

const Color lightShadowColor = Color(0x80CDCDCD);

const Color lightErrorColor = Color(0xFF800020);

// Dark theme colors
const Color darkPrimaryColor = Color(0xFF4CAF50);
const Color darkSecondaryColor = Color(0xFFFFB74D);
const Color darkTertiaryColor = Color(0xFF4FC3F7);
const Color darkAlternateColor = Color(0xFFFFD54F);

const Color darkPrimaryTextColor = Color(0xFFE0E0E0);
const Color darkSecondaryTextColor = Color(0xFFBDBDBD);
const Color darkPrimaryBackgroundColor = Color(0xFF212121);
const Color darkSecondaryBackgroundColor = Color(0xFF282828);
const Color mutedDarkSecondaryBackgroundColor = Color(0xB3424242);

const Color darkShadowColor = Color(0xFF1B1B1B);


const Color darkErrorColor = Color(0xFFB70031);

class WebTheme {
  static const transparentColour = Color(0x00000000);

  static const Color successColor = Color(0xFF2E7D32);
  static const Color errorColor = Color(0xFF800020);
  static const Color warningColor = Color(0xFFFF8F00);
  static const Color infoColor = Color(0xFF4392E1);

  static const Color accent1 = Color(0xFFFF5722);
  static const Color accent2 = Color(0xFFE91E63);
  static const Color accent3 = Color(0xFFBA68C8);
  static const Color accent4 = Color(0xFF4DD0E1);

  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: lightPrimaryColor,
      onPrimary: lightPrimaryTextColor,
      secondary: lightSecondaryColor,
      onSecondary: lightSecondaryTextColor,
      tertiary: lightTertiaryColor,
      onTertiary: lightAlternateColor,
      surface: lightSecondaryBackgroundColor,
      onSurface: lightPrimaryTextColor,
      surfaceVariant: mutedLightSecondaryBackgroundColor,
      background: lightPrimaryBackgroundColor,
      onBackground: lightPrimaryTextColor,
      error: lightErrorColor,
      onError: errorColor,
      outline: lightShadowColor,
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
          color: lightPrimaryTextColor, fontSize: 8, fontFamily: 'Roboto'),
      bodyMedium: TextStyle(
          color: lightPrimaryTextColor, fontSize: 12, fontFamily: 'Roboto'),
      bodyLarge: TextStyle(
          color: lightPrimaryTextColor, fontSize: 16, fontFamily: 'Roboto'),
      titleSmall: TextStyle(
          color: lightPrimaryTextColor,
          fontSize: 14,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: lightPrimaryTextColor,
          fontSize: 18,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold),
      titleLarge: TextStyle(
          color: lightPrimaryTextColor,
          fontSize: 24,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold),
      labelLarge: TextStyle(
          color: lightPrimaryBackgroundColor,
          fontSize: 22,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: lightPrimaryTextColor, fontSize: 14, fontFamily: 'Roboto'),
      headlineMedium: TextStyle(
          color: lightPrimaryBackgroundColor,
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: lightPrimaryBackgroundColor,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      tertiary: darkTertiaryColor,
      onTertiary: darkAlternateColor,
      surface: darkSecondaryBackgroundColor,
      surfaceVariant: mutedDarkSecondaryBackgroundColor,
      background: darkPrimaryBackgroundColor,
      onPrimary: darkPrimaryTextColor,
      onSecondary: darkSecondaryTextColor,
      onSurface: darkPrimaryTextColor,
      onBackground: darkPrimaryTextColor,
      error: darkErrorColor,
      onError: errorColor,
      outline: darkShadowColor,
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
          color: darkPrimaryTextColor, fontSize: 8, fontFamily: 'Roboto'),
      bodyMedium: TextStyle(
          color: darkPrimaryTextColor, fontSize: 12, fontFamily: 'Roboto'),
      bodyLarge: TextStyle(
          color: darkPrimaryTextColor, fontSize: 16, fontFamily: 'Roboto'),
      titleSmall: TextStyle(
          color: darkPrimaryTextColor,
          fontSize: 14,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: darkPrimaryTextColor,
          fontSize: 18,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold),
      titleLarge: TextStyle(
          color: darkPrimaryTextColor,
          fontSize: 24,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold),
      labelLarge: TextStyle(
          color: darkPrimaryBackgroundColor,
          fontSize: 22,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: darkPrimaryTextColor, fontSize: 16, fontFamily: 'Roboto'),
      headlineMedium: TextStyle(
          color: lightPrimaryBackgroundColor,
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: darkPrimaryBackgroundColor,
  );
}
