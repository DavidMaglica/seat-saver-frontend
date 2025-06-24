import 'package:TableReserver/pages/auth/authentication.dart';
import 'package:TableReserver/pages/settings/edit_profile.dart';
import 'package:TableReserver/pages/settings/notification_settings.dart';
import 'package:TableReserver/pages/settings/reservation_history.dart';
import 'package:TableReserver/pages/settings/support.dart';
import 'package:TableReserver/pages/settings/terms_of_service.dart';
import 'package:TableReserver/pages/views/account.dart';
import 'package:TableReserver/pages/views/homepage.dart';
import 'package:TableReserver/pages/views/landing.dart';
import 'package:TableReserver/pages/views/nearby.dart';
import 'package:TableReserver/pages/views/ratings_page.dart';
import 'package:TableReserver/pages/views/search.dart';
import 'package:TableReserver/pages/views/successful_reservation.dart';
import 'package:TableReserver/pages/views/venue_page.dart';
import 'package:TableReserver/pages/views/venues_by_type.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  T getRequiredArg<T>(BuildContext context, String key) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final value = args?[key];
    if (value is T) return value;
    throw Exception("Missing or invalid argument '$key'");
  }

  T? getOptionalArg<T>(BuildContext context, String key) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final value = args?[key];
    return value is T ? value : null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableReserver',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      home: const Landing(),
      debugShowCheckedModeBanner: false,
      routes: {
        Routes.landing: (context) => const Landing(),
        Routes.homepage: (context) => Homepage(
              userId: getOptionalArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.search: (context) => Search(
              userId: getOptionalArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.nearby: (context) => Nearby(
              userId: getOptionalArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.account: (context) => Account(
              userId: getOptionalArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.reservationHistory: (context) => ReservationHistory(
              userId: getRequiredArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.notificationSettings: (context) => NotificationSettings(
              userId: getRequiredArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.support: (context) => Support(
              userId: getRequiredArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.editProfile: (context) => EditProfile(
              userId: getRequiredArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.termsOfService: (context) => TermsOfService(
              userId: getOptionalArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.authentication: (context) => const Authentication(),
        Routes.venue: (context) => VenuePage(
              venueId: getRequiredArg<int>(context, 'venueId'),
              userId: getOptionalArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.venueRatings: (context) => RatingsPage(
              venueId: getRequiredArg<int>(context, 'venueId'),
              userId: getOptionalArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
        Routes.venuesByType: (context) => VenuesByType(
              type: getRequiredArg<String>(context, 'type'),
              userId: getOptionalArg<int>(context, 'userId'),
              position: getOptionalArg<Position>(context, 'position'),
            ),
        Routes.successfulReservation: (context) => SuccessfulReservation(
              venueName: getRequiredArg<String>(context, 'venueName'),
              numberOfGuests: getRequiredArg<int>(context, 'numberOfGuests'),
              reservationDateTime:
                  getRequiredArg<DateTime>(context, 'reservationDateTime'),
              userId: getRequiredArg<int>(context, 'userId'),
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
            ),
      },
    );
  }
}
