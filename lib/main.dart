import 'package:flutter/material.dart';

import 'pages/account.dart';
import 'pages/homepage.dart';
import 'pages/landing.dart';
import 'pages/nearby.dart';
import 'pages/search.dart';
import 'pages/settings/notification_settings.dart';
import 'themes/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diplomski',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: const Landing(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/landing': (context) => const Landing(),
        '/homepage': (context) => const Homepage(),
        '/search': (context) => const Search(),
        '/nearby': (context) => const Nearby(),
        '/account': (context) => const Account(),
        '/notificationSettings': (context) => const NotificationSettings(),
      },
    );
  }
}
