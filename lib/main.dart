import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_reserver/models/web/side_nav_model.dart';
import 'package:table_reserver/pages/mobile/auth/authentication.dart';
import 'package:table_reserver/pages/mobile/settings/edit_profile.dart';
import 'package:table_reserver/pages/mobile/settings/notification_settings.dart';
import 'package:table_reserver/pages/mobile/settings/reservation_history.dart';
import 'package:table_reserver/pages/mobile/settings/support.dart';
import 'package:table_reserver/pages/mobile/settings/terms_of_service.dart';
import 'package:table_reserver/pages/mobile/views/account.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/pages/mobile/views/landing.dart';
import 'package:table_reserver/pages/mobile/views/nearby.dart';
import 'package:table_reserver/pages/mobile/views/ratings_page.dart';
import 'package:table_reserver/pages/mobile/views/search.dart';
import 'package:table_reserver/pages/mobile/views/successful_reservation.dart';
import 'package:table_reserver/pages/mobile/views/venue_page.dart';
import 'package:table_reserver/pages/mobile/views/venues_by_type.dart';
import 'package:table_reserver/pages/web/auth/authentication.dart';
import 'package:table_reserver/pages/web/views/account.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/pages/web/views/landing.dart';
import 'package:table_reserver/pages/web/views/reservations.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/pages/web/views/venues.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/theme_provider.dart';

late final String iosGoogleClientId;
late final String webGoogleClientId;

late final GoogleSignIn googleSignIn;

late SharedPreferencesWithCache prefsWithCache;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initialiseGoogleSignIn();
  initialiseSharedPreferences();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

void initialiseGoogleSignIn() {
  iosGoogleClientId = const String.fromEnvironment('IOS_GOOGLE_CLIENT_ID');
  webGoogleClientId = const String.fromEnvironment('WEB_GOOGLE_CLIENT_ID');

  if (iosGoogleClientId.isEmpty || webGoogleClientId.isEmpty) {
    throw Exception(
      'Missing required environment variable. Google client Ids must be provided for both iOS and Web.',
    );
  }

  googleSignIn = GoogleSignIn.instance;
  googleSignIn.initialize(
    clientId: kIsWeb ? webGoogleClientId : iosGoogleClientId,
  );
}

void initialiseSharedPreferences() async {
  prefsWithCache = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{'userId', 'userName', 'userEmail'},
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
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SideNavModel()..init()),
        ],
        child: _buildWebMaterialApp(),
      );
    }
    return _buildMobileMaterialApp();
  }

  Widget _buildMobileMaterialApp() {
    return MaterialApp(
      title: 'Table Reserver',
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
          reservationDateTime: getRequiredArg<DateTime>(
            context,
            'reservationDateTime',
          ),
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
          title: 'Table Reserver',
          theme: WebTheme.lightTheme,
          darkTheme: WebTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const WebLanding(),
          debugShowCheckedModeBanner: false,
          routes: {
            Routes.webLanding: (context) => const WebLanding(),
            Routes.webAuthentication: (context) => const WebAuthentication(),
            Routes.webHomepage: (context) => const WebHomepage(),
            Routes.webVenues: (context) => const WebVenuesPage(),
            Routes.webVenue: (context) => WebVenuePage(
              venueId: getOptionalArg<int>(context, 'venueId') ?? 1,
            ),
            Routes.webReservations: (context) => const WebReservations(),
            Routes.webAccount: (context) => const WebAccount(),
          },
        );
      },
    );
  }
}
