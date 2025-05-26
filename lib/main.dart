import 'package:flutter/material.dart';

import 'pages/auth/authentication.dart';
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
import 'pages/views/successful_reservation.dart';
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
        Routes.landing: (context) => const Landing(),
        Routes.homepage: (context) => Homepage(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.search: (context) => Search(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.nearby: (context) => Nearby(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.account: (context) => Account(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.reservationHistory: (context) => ReservationHistory(
              user: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['user'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.notificationSettings: (context) => NotificationSettings(
              user: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['user'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.support: (context) => Support(
              user: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['user'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.editProfile: (context) => EditProfile(
              user: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['user'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.termsOfService: (context) => TermsOfService(
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.authentication: (context) => const Authentication(),
        Routes.venue: (context) => VenuePage(
              venueId: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['venueId'],
              userEmail: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userEmail'],
              userLocation: (ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>)['userLocation'],
            ),
        Routes.successfulReservation: (context) => SuccessfulReservation(
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
