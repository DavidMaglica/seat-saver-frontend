import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_reserver/api/common/api_routes.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/extensions.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/theme_provider.dart';
import 'package:table_reserver/utils/toaster.dart';
import 'package:table_reserver/utils/utils.dart';

void main() {
  group('Animations', () {
    test('Landing animations map contains required keys', () {
      expect(Animations.landingAnimations, contains('logoOnLoad'));
      expect(Animations.landingAnimations, contains('textOnLoad'));
      expect(Animations.landingAnimations, contains('buttonOnLoad'));
    });

    test('Authentication animations map contains required keys', () {
      expect(Animations.authenticationAnimations, contains('authOnLoad'));
      expect(Animations.authenticationAnimations, contains('tabOnLoad'));
    });

    test('Homepage animations map contains required keys', () {
      expect(Animations.homepageAnimations, contains('titleRowOnLoad'));
      expect(Animations.homepageAnimations, contains('circularStatsOnLoad'));
      expect(Animations.homepageAnimations, contains('tableOnLoad'));
      expect(Animations.homepageAnimations, contains('performanceOnLoad'));
    });

    test('Venues page animations map contains required keys', () {
      expect(Animations.venuesAnimations, contains('gridOnLoad'));
    });

    test('Venue page animations map contains required keys', () {
      expect(Animations.venuePageAnimations, contains('headerImageOnLoad'));
      expect(Animations.venuePageAnimations, contains('fadeInOnLoad'));
      expect(Animations.venuePageAnimations, contains('fadeMoveUpOnLoad'));
    });

    test('Account page animations map contains required keys', () {
      expect(Animations.accountAnimations, contains('accountDetailsOnLoad'));
      expect(Animations.accountAnimations, contains('actionsOnLoad'));
      expect(Animations.accountAnimations, contains('buttonOnLoad'));
    });

    test('Reservations page animations map contains required keys', () {
      expect(Animations.reservationsAnimations, contains('reservationsOnLoad'));
    });

    test('Utility pages animations map contains required keys', () {
      expect(Animations.utilityPagesAnimations, contains('titleRowOnLoad'));
      expect(Animations.utilityPagesAnimations, contains('gridOnLoad'));
    });

    test('Modals animations map contains required keys', () {
      expect(Animations.modalAnimations, contains('modalOnLoad'));
    });
  });

  group('Routes', () {
    test('Mobile routes navigate to correct route constant', () {
      expect(Routes.webAuthentication, '/authentication');
      expect(Routes.landing, '/landing');
      expect(Routes.homepage, '/homepage');
      expect(Routes.search, '/search');
      expect(Routes.nearby, '/nearby');
      expect(Routes.account, '/account');
      expect(Routes.reservationHistory, '/reservationHistory');
      expect(Routes.notificationSettings, '/notificationSettings');
      expect(Routes.support, '/support');
      expect(Routes.editProfile, '/editProfile');
      expect(Routes.termsOfService, '/termsOfService');
      expect(Routes.authentication, '/authentication');
      expect(Routes.venue, '/venue');
      expect(Routes.venueRatings, '/venueRatings');
      expect(Routes.venuesByType, '/venuesByType');
      expect(Routes.successfulReservation, '/successfulReservation');
    });

    test('Web routes navigate to correct route constant', () {
      expect(Routes.webLanding, '/landing');
      expect(Routes.webAuthentication, '/authentication');
      expect(Routes.webHomepage, '/homepage');
      expect(Routes.webVenues, '/venues');
      expect(Routes.webVenue, '/venue');
      expect(Routes.webReservations, '/reservations');
      expect(Routes.webAccount, '/account');
      expect(Routes.webRatingsPage, '/ratings');
      expect(Routes.webReservationsGraphs, '/reservationsGraphs');
    });
  });

  group('Utils', () {
    group('calculateAvailabilityColour', () {
      test('returns successColor when ratio >= 0.4', () {
        final color = calculateAvailabilityColour(100, 50);
        expect(color, MobileTheme.successColor);
      });

      test('returns warningColor when ratio >= 0.1 but < 0.4', () {
        final color = calculateAvailabilityColour(100, 20);
        expect(color, MobileTheme.warningColor);
      });

      test('returns red when ratio < 0.1', () {
        final color = calculateAvailabilityColour(100, 5);
        expect(color, Colors.red);
      });

      test('returns red when maxCapacity is 0', () {
        final color = calculateAvailabilityColour(0, 0);
        expect(color, Colors.red);
      });
    });

    group('getPositionFromLatAndLong', () {
      test('returns null if latitude or longitude is null', () {
        expect(getPositionFromLatAndLong(null, 10), isNull);
        expect(getPositionFromLatAndLong(52.5, null), isNull);
      });

      test('returns a valid Position when lat/long provided', () {
        final pos = getPositionFromLatAndLong(52.5, 13.4);
        expect(pos, isA<Position>());
        expect(pos!.latitude, 52.5);
        expect(pos.longitude, 13.4);
      });
    });

    group('Gradients', () {
      testWidgets('fallbackImageGradient returns correct gradient', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final gradient = fallbackImageGradient();
                expect(gradient, isA<LinearGradient>());
                expect(gradient, isNotNull);
                expect(gradient.stops, [0.0, 0.5, 0.9, 1.0]);
                expect(gradient.begin, Alignment.bottomLeft);
                expect(gradient.end, Alignment.topRight);
                expect(gradient.colors.length, 4);
                expect(
                  gradient.colors[0],
                  Color(0xFF1B5E20).withValues(alpha: 0.8),
                );
                expect(
                  gradient.colors[1],
                  Color(0xFF43A047).withValues(alpha: 0.8),
                );
                expect(
                  gradient.colors[2],
                  Color(0xFFFF7043).withValues(alpha: 0.8),
                );
                expect(
                  gradient.colors[3],
                  Color(0xFFFF5722).withValues(alpha: 0.8),
                );

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('fallbackImageGradientReverted returns correct decoration', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final gradient = fallbackImageGradientReverted();
                expect(gradient, isA<LinearGradient>());
                expect(gradient, isNotNull);
                expect(gradient.stops, [0.0, 0.5, 0.9, 1.0]);
                expect(gradient.begin, Alignment.bottomLeft);
                expect(gradient.end, Alignment.topRight);
                expect(gradient.colors.length, 4);
                expect(
                  gradient.colors[0],
                  Color(0xFFFF5722).withValues(alpha: 0.8),
                );
                expect(
                  gradient.colors[1],
                  Color(0xFFFF7043).withValues(alpha: 0.8),
                );
                expect(
                  gradient.colors[2],
                  Color(0xFF43A047).withValues(alpha: 0.8),
                );
                expect(
                  gradient.colors[3],
                  Color(0xFF1B5E20).withValues(alpha: 0.8),
                );

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('webBackgroundGradient returns correct decoration', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final decoration = webBackgroundGradient(context);
                expect(decoration, isA<BoxDecoration>());
                final gradient = decoration.gradient as LinearGradient;
                expect((decoration).gradient, isNotNull);
                expect(gradient.colors.length, 3);
                expect(gradient.stops, [0, 0.5, 1]);
                expect(gradient.begin, const AlignmentDirectional(-1, -1));
                expect(gradient.end, const AlignmentDirectional(1, 1));
                expect(gradient.colors.length, 3);
                expect(gradient.colors, contains(WebTheme.successColor));
                expect(gradient.colors, contains(WebTheme.accent1));
                expect(
                  gradient.colors,
                  contains(Theme.of(context).colorScheme.surface),
                );

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('webBackgroundAuxiliaryGradient returns correct decoration', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final decoration = webBackgroundAuxiliaryGradient(context);
                expect(decoration, isA<BoxDecoration>());
                final gradient = decoration.gradient as LinearGradient;
                expect((decoration).gradient, isNotNull);
                expect(gradient.colors.length, 3);
                expect(gradient.stops, [0, 0.8, 1]);
                expect(gradient.begin, const AlignmentDirectional(0, -1));
                expect(gradient.end, const AlignmentDirectional(0, 1));
                expect(gradient.colors.length, 3);
                expect(gradient.colors, contains(WebTheme.transparentColour));
                expect(
                  gradient.colors,
                  contains(
                    Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.8),
                  ),
                );
                expect(
                  gradient.colors,
                  contains(Theme.of(context).colorScheme.surface),
                );
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('isWithinWorkingHours', () {
      test('returns true when reservation is inside working hours', () {
        final now = DateTime(2025, 8, 31, 15, 0);
        final result = isWithinWorkingHours(now, '10:00 - 18:00');
        expect(result, isTrue);
      });

      test('returns false when reservation is before working hours', () {
        final now = DateTime(2025, 8, 31, 8, 0);
        final result = isWithinWorkingHours(now, '10:00 - 18:00');
        expect(result, isFalse);
      });

      test('returns false when reservation is after working hours', () {
        final now = DateTime(2025, 8, 31, 20, 0);
        final result = isWithinWorkingHours(now, '10:00 - 18:00');
        expect(result, isFalse);
      });

      test('returns false when workingHours format is invalid', () {
        final now = DateTime(2025, 8, 31, 12, 0);
        final result = isWithinWorkingHours(now, '10:00');
        expect(result, isFalse);
      });
    });
  });

  group('StringCaseExtensions', () {
    test('toTitleCase converts snake_case to Title Case', () {
      expect('my_enum_value'.toTitleCase(), 'My Enum Value');
    });

    test('toTitleCase converts UPPERCASE to Title Case', () {
      expect('ANOTHER_EXAMPLE'.toTitleCase(), 'Another Example');
    });

    test('toTitleCase handles single word', () {
      expect('hello'.toTitleCase(), 'Hello');
    });

    test('converts snake_case to formatted uppercase', () {
      expect('my_enum_value'.toFormattedUpperCase(), 'MY ENUM VALUE');
    });

    test('keeps uppercase words uppercase and replaces underscores', () {
      expect('ALREADY_UPPER'.toFormattedUpperCase(), 'ALREADY UPPER');
    });
  });

  group('NullableStringExtension', () {
    test('isNullOrEmpty returns true for null', () {
      String? str;
      expect(str.isNullOrEmpty, isTrue);
    });

    test('isNullOrEmpty returns true for empty string', () {
      String? str = '';
      expect(str.isNullOrEmpty, isTrue);
    });

    test('isNullOrEmpty returns false for non-empty string', () {
      String? str = 'test';
      expect(str.isNullOrEmpty, isFalse);
    });

    test('isNotNullAndNotEmpty returns false for null', () {
      String? str;
      expect(str.isNotNullAndNotEmpty, isFalse);
    });

    test('isNotNullAndNotEmpty returns false for empty string', () {
      String? str = '';
      expect(str.isNotNullAndNotEmpty, isFalse);
    });

    test('isNotNullAndNotEmpty returns true for non-empty string', () {
      String? str = 'test';
      expect(str.isNotNullAndNotEmpty, isTrue);
    });
  });

  group('ThemeProvider', () {
    test('default theme is system and isDarkMode is false', () {
      final provider = ThemeProvider();
      expect(provider.themeMode, ThemeMode.system);
      expect(provider.isDarkMode, false);
    });

    test('toggleDarkTheme sets dark mode', () {
      final provider = ThemeProvider();
      provider.toggleDarkTheme(true);
      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.isDarkMode, true);
    });

    test('toggleDarkTheme sets light mode', () {
      final provider = ThemeProvider();
      provider.toggleDarkTheme(false);
      expect(provider.themeMode, ThemeMode.light);
      expect(provider.isDarkMode, false);
    });
  });

  group('Toaster', () {
    testWidgets(
      'Toaster displays SnackBar with correct text and success color',
      (tester) async {
        const testMessage = 'Hello, world!';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Toaster.displaySuccess(context, testMessage);
                  });
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text(testMessage), findsOneWidget);

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, Toaster.successColor);
      },
    );

    testWidgets(
      'Toaster displays SnackBar with correct text and warning color',
      (tester) async {
        const testMessage = 'Hello, world!';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Toaster.displayWarning(context, testMessage);
                  });
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text(testMessage), findsOneWidget);

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, Toaster.warningColor);
      },
    );

    testWidgets('Toaster displays SnackBar with correct text and info color', (
      tester,
    ) async {
      const testMessage = 'Hello, world!';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Toaster.displayInfo(context, testMessage);
                });
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(testMessage), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Toaster.infoColor);
    });

    testWidgets('Toaster displays SnackBar with correct text and error color', (
      tester,
    ) async {
      const testMessage = 'Hello, world!';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Toaster.displayError(context, testMessage);
                });
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(testMessage), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Toaster.errorColor);
    });
  });

  group('Api Routes', () {
    test('Base paths are correct', () {
      expect(ApiRoutes.apiBase, '/api/v1');
      expect(ApiRoutes.users, '/api/v1/users');
      expect(ApiRoutes.venues, '/api/v1/venues');
      expect(ApiRoutes.reservations, '/api/v1/reservations');
      expect(ApiRoutes.geolocation, '/api/v1/geolocation');
      expect(ApiRoutes.support, '/api/v1/support');
    });

    test('Static endpoint are correct', () {
      expect(ApiRoutes.signUp, '/api/v1/users/signup');
      expect(ApiRoutes.logIn, '/api/v1/users/login');
      expect(ApiRoutes.usersByIds, '/api/v1/users/by-ids');
      expect(ApiRoutes.allVenueTypes, '/api/v1/venues/types');
      expect(
        ApiRoutes.reservationWithEmail,
        '/api/v1/reservations/create-with-email',
      );
      expect(ApiRoutes.getNearbyCities, '/api/v1/geolocation/nearby-cities');
      expect(ApiRoutes.sendEmail, '/api/v1/support/send-email');
    });

    test('Dynamic endpoint functions return correct paths', () {
      expect(ApiRoutes.userById(1), '/api/v1/users/1');
      expect(ApiRoutes.userNotifications(1), '/api/v1/users/1/notifications');
      expect(ApiRoutes.userLocation(1), '/api/v1/users/1/location');
      expect(ApiRoutes.updateEmail(1), '/api/v1/users/1/email');
      expect(ApiRoutes.updateUsername(1), '/api/v1/users/1/username');
      expect(ApiRoutes.updatePassword(1), '/api/v1/users/1/password');
      expect(ApiRoutes.updateLocation(1), '/api/v1/users/1/location');
      expect(ApiRoutes.updateNotifications(1), '/api/v1/users/1/notifications');
      expect(ApiRoutes.venueById(1), '/api/v1/venues/1');
      expect(ApiRoutes.venuesByOwnerId(1), '/api/v1/venues/owner/1');
      expect(ApiRoutes.venuesCountByOwnerId(1), '/api/v1/venues/owner/1/count');
      expect(ApiRoutes.venueHeaderImage(1), '/api/v1/venues/1/header-image');
      expect(ApiRoutes.venueImages(1), '/api/v1/venues/1/venue-images');
      expect(ApiRoutes.menuImages(1), '/api/v1/venues/1/menu-images');
      expect(
        ApiRoutes.venueAverageRating(1),
        '/api/v1/venues/1/average-rating',
      );
      expect(ApiRoutes.allVenueRatings(1), '/api/v1/venues/1/ratings');
      expect(ApiRoutes.venueRatingsCount(1), '/api/v1/venues/ratings/count/1');
      expect(ApiRoutes.overallRating(1), '/api/v1/venues/overall-rating/1');
      expect(
        ApiRoutes.venueUtilisationRate(1),
        '/api/v1/venues/utilisation-rate/1',
      );
      expect(ApiRoutes.rateVenue(1), '/api/v1/venues/1/rate');
      expect(ApiRoutes.venueType(1), '/api/v1/venues/type/1');
      expect(ApiRoutes.reservationById(1), '/api/v1/reservations/1');
      expect(ApiRoutes.userReservations(1), '/api/v1/reservations/user/1');
      expect(ApiRoutes.ownerReservations(1), '/api/v1/reservations/owner/1');
      expect(ApiRoutes.venueReservations(1), '/api/v1/reservations/venue/1');
      expect(ApiRoutes.reservationCount(1), '/api/v1/reservations/count/1');
    });
  });
}
