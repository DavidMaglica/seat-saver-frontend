import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/models/web/components/side_nav_model.dart';
import 'package:seat_saver/pages/mobile/views/homepage.dart';
import 'package:seat_saver/pages/mobile/views/landing.dart';
import 'package:seat_saver/pages/web/auth/authentication.dart';
import 'package:seat_saver/pages/web/views/account.dart';
import 'package:seat_saver/pages/web/views/homepage.dart';
import 'package:seat_saver/pages/web/views/landing.dart';
import 'package:seat_saver/pages/web/views/ratings_page.dart';
import 'package:seat_saver/pages/web/views/reservations.dart';
import 'package:seat_saver/pages/web/views/reservations_graphs_page.dart';
import 'package:seat_saver/pages/web/views/venue_page.dart';
import 'package:seat_saver/pages/web/views/venues.dart';
import 'package:seat_saver/themes/mobile_theme.dart';
import 'package:seat_saver/themes/web_theme.dart';
import 'package:seat_saver/utils/routes.dart';
import 'package:seat_saver/utils/sign_up_methods.dart';
import 'package:seat_saver/utils/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final String iosGoogleClientId;
late final String webGoogleClientId;

late final GoogleSignIn googleSignIn;

late SharedPreferencesWithCache sharedPreferencesCache;

int? get cachedOwnerId => sharedPreferencesCache.getInt('ownerId');

int? get cachedUserId => sharedPreferencesCache.getInt('userId');

Position? get cachedUserLocation {
  final locJson = sharedPreferencesCache.getString('lastKnownLocation');
  if (locJson == null) return null;

  final data = jsonDecode(locJson);
  return Position(
    latitude: data['lat'],
    longitude: data['lng'],
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );
}

AuthenticationMethod currentAuthMethod = AuthenticationMethod.none;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialiseGoogleSignIn();
  await initialiseSharedPreferences();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

Future<void> initialiseGoogleSignIn() async {
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

Future<void> initialiseSharedPreferences() async {
  sharedPreferencesCache = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{
        'userId',
        'lastKnownLocation',
        'ownerId',
        'ownerName',
        'ownerEmail',
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      title: 'SeatSaver',
      theme: MobileTheme.lightTheme,
      darkTheme: MobileTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: cachedUserId != null
          ? Homepage(userId: cachedUserId, userLocation: cachedUserLocation)
          : const Landing(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildWebMaterialApp() {
    int? ownerId = sharedPreferencesCache.getInt('ownerId');
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'SeatSaver',
          theme: WebTheme.lightTheme,
          darkTheme: WebTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: ownerId != null
              ? WebHomepage(ownerId: ownerId)
              : const WebLanding(),
          debugShowCheckedModeBanner: false,
          routes: {
            Routes.webLanding: (context) => const WebLanding(),
            Routes.webAuthentication: (context) => const WebAuthentication(),
            Routes.webHomepage: (context) =>
                WebHomepage(ownerId: getOptionalArg(context, 'ownerId')),
            Routes.webVenues: (context) => const WebVenuesPage(),
            Routes.webAccount: (context) => const WebAccount(),
          },
          onGenerateRoute: (settings) {
            final uri = Uri.parse(settings.name ?? '');

            if (uri.path == Routes.webReservationsGraphs) {
              final ownerId = int.tryParse(
                uri.queryParameters['ownerId'] ?? '',
              );

              if (ownerId == null) {
                throw Exception("Missing or invalid ownerId in URL");
              }

              return MaterialPageRoute(
                settings: settings,
                builder: (_) => ReservationsGraphsPage(ownerId: ownerId),
              );
            }

            if (uri.path == Routes.webReservations) {
              final venueId = int.tryParse(
                uri.queryParameters['venueId'] ?? '',
              );
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => WebReservations(venueId: venueId),
              );
            }

            if (uri.path == Routes.webRatingsPage) {
              final ownerId = int.tryParse(
                uri.queryParameters['ownerId'] ?? '',
              );

              if (ownerId == null) {
                throw Exception("Missing or invalid ownerId in URL");
              }

              return MaterialPageRoute(
                settings: settings,
                builder: (_) => WebRatingsPage(ownerId: ownerId),
              );
            }

            if (uri.path == Routes.webVenue) {
              final venueId = int.tryParse(
                uri.queryParameters['venueId'] ?? '',
              );
              final shouldReturnToHomepage =
                  uri.queryParameters['shouldReturnToHomepage'] == 'true';

              if (venueId == null) {
                throw Exception("Missing or invalid venueId in URL");
              }

              return MaterialPageRoute(
                settings: settings,
                builder: (_) => WebVenuePage(
                  venueId: venueId,
                  shouldReturnToHomepage: shouldReturnToHomepage,
                ),
              );
            }

            return null;
          },
        );
      },
    );
  }
}
