import 'package:diplomski/pages/homepage.dart';
import 'package:diplomski/pages/landing.dart';
import 'package:diplomski/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diplomski',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/landing': (context) => const LandingPage(),
        '/homepage': (context) => const Homepage(),
      },
    );
  }
}
