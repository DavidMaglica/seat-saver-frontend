import 'package:diplomski/pages/homepage.dart';
import 'package:diplomski/pages/landing.dart';
import 'package:diplomski/pages/nearby.dart';
import 'package:diplomski/themes/theme.dart';
import 'package:flutter/material.dart';

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
        '/nearby': (context) => const Nearby(),
      },
    );
  }
}
