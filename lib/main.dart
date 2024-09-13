import 'package:flutter/material.dart';

import 'pages/auth/authentication.dart';
import 'pages/helpers/successful_reservation.dart';
import 'pages/settings/edit_profile.dart';
import 'pages/settings/notification_settings.dart';
import 'pages/settings/reservation_history.dart';
import 'pages/settings/support.dart';
import 'pages/settings/terms_of_service.dart';
import 'pages/views/account.dart';
import 'pages/views/homepage.dart';
import 'pages/views/landing.dart';
import 'pages/views/nearby.dart';
import 'pages/views/search.dart';
import 'pages/views/venue_page.dart';
import 'themes/theme.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableReserver',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: const Landing(),
      debugShowCheckedModeBanner: false,
      routes: {
        Routes.LANDING: (context) => const Landing(),
        Routes.HOMEPAGE: (context) => Homepage(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.SEARCH: (context) => Search(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.NEARBY: (context) => Nearby(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.ACCOUNT: (context) => Account(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.RESERVATION_HISTORY: (context) => ReservationHistory(
              user: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['user'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.NOTIFICATION_SETTINGS: (context) => NotificationSettings(
              user: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['user'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.SUPPORT: (context) => Support(
              user: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['user'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.EDIT_PROFILE: (context) => EditProfile(
              user: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['user'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.TERMS_OF_SERVICE: (context) => TermsOfService(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.AUTHENTICATION: (context) => const Authentication(),
        Routes.VENUE: (context) => VenuePage(
              venueName: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['venueName'],
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
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.SUCCESSFUL_RESERVATION: (context) => SuccessfulReservation(
              venueName: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['venueName'],
              numberOfGuests: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['numberOfGuests'],
              reservationDateTime: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['reservationDateTime'],
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
      },
    );
  }
}
