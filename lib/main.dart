import 'package:flutter/material.dart';

import 'pages/auth/authentication.dart';
import 'pages/settings/edit_profile.dart';
import 'pages/settings/notification_settings.dart';
import 'pages/settings/support.dart';
import 'pages/settings/terms_of_service.dart';
import 'pages/views/account.dart';
import 'pages/views/homepage.dart';
import 'pages/views/landing.dart';
import 'pages/views/nearby.dart';
import 'pages/views/venue_page.dart';
import 'pages/views/search.dart';
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
        '/support': (context) => const Support(),
        '/editProfile': (context) => const EditProfile(),
        '/termsOfService': (context) => const TermsOfService(),
        '/authentication': (context) => const Authentication(),
        '/venue': (context) => VenuePage(
              name: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['name'],
              location: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['location'],
              workingHours: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['workingHours'],
              rating: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['rating'],
              type: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['type'],
              description: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['description'],
            ),
      },
    );
  }
}
