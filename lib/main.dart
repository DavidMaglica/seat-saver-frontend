import 'package:TableReserver/pages/mobile/auth/authentication.dart';
import 'package:TableReserver/pages/mobile/settings/edit_profile.dart';
import 'package:TableReserver/pages/mobile/settings/notification_settings.dart';
import 'package:TableReserver/pages/mobile/settings/reservation_history.dart';
import 'package:TableReserver/pages/mobile/settings/support.dart';
import 'package:TableReserver/pages/mobile/settings/terms_of_service.dart';
import 'package:TableReserver/pages/mobile/views/account.dart';
import 'package:TableReserver/pages/mobile/views/homepage.dart';
import 'package:TableReserver/pages/mobile/views/landing.dart';
import 'package:TableReserver/pages/mobile/views/nearby.dart';
import 'package:TableReserver/pages/mobile/views/ratings_page.dart';
import 'package:TableReserver/pages/mobile/views/search.dart';
import 'package:TableReserver/pages/mobile/views/successful_reservation.dart';
import 'package:TableReserver/pages/mobile/views/venue_page.dart';
import 'package:TableReserver/pages/mobile/views/venues_by_type.dart';
import 'package:TableReserver/pages/web/auth/authentication.dart';
import 'package:TableReserver/pages/web/views/account.dart';
import 'package:TableReserver/pages/web/views/homepage.dart';
import 'package:TableReserver/pages/web/views/landing.dart';
import 'package:TableReserver/pages/web/views/reservations.dart';
import 'package:TableReserver/themes/mobile_theme.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:TableReserver/utils/routes.dart';
import 'package:TableReserver/utils/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
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
    if (kIsWeb) {
      return _buildWebMaterialApp();
    }
    return _buildMobileMaterialApp();
  }

  Widget _buildMobileMaterialApp() {
    return MaterialApp(
      title: 'TableReserver',
      theme: MobileTheme.lightTheme,
      darkTheme: MobileTheme.darkTheme,
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
              userLocation: getOptionalArg<Position>(context, 'userLocation'),
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

  Widget _buildWebMaterialApp() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'TableReserver',
          theme: WebTheme.lightTheme,
          darkTheme: WebTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const WebLanding(),
          debugShowCheckedModeBanner: false,
          routes: {
            Routes.webLanding: (context) => const WebLanding(),
            Routes.webAuthentication: (context) => const WebAuthentication(),
            Routes.webHomepage: (context) => const WebHomepage(),
            Routes.webReservations: (context) => const WebReservations(),
            Routes.webAccount: (context) => const WebAccount(),
          },
        );
      },
    );
  }
}
