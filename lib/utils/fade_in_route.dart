import 'package:flutter/material.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/pages/mobile/auth/authentication.dart';
import 'package:seat_saver/pages/mobile/settings/edit_profile.dart';
import 'package:seat_saver/pages/mobile/settings/notification_settings.dart';
import 'package:seat_saver/pages/mobile/settings/reservation_history.dart';
import 'package:seat_saver/pages/mobile/settings/support.dart';
import 'package:seat_saver/pages/mobile/settings/terms_of_service.dart';
import 'package:seat_saver/pages/mobile/views/account.dart';
import 'package:seat_saver/pages/mobile/views/homepage.dart';
import 'package:seat_saver/pages/mobile/views/landing.dart';
import 'package:seat_saver/pages/mobile/views/nearby.dart';
import 'package:seat_saver/pages/mobile/views/ratings_page.dart';
import 'package:seat_saver/pages/mobile/views/search.dart';
import 'package:seat_saver/pages/mobile/views/successful_reservation.dart';
import 'package:seat_saver/pages/mobile/views/venue_page.dart';
import 'package:seat_saver/pages/mobile/views/venues_by_type.dart';
import 'package:seat_saver/utils/routes.dart';

class FadeInRoute extends PageRouteBuilder {
  final Widget page;
  final Map<String, dynamic>? arguments;

  FadeInRoute({required this.page, required String routeName, this.arguments})
    : super(
        settings: RouteSettings(name: routeName, arguments: arguments),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) => page,
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) => FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      );
}

class MobileFadeInRoute extends PageRouteBuilder {
  final Widget page;
  final Map<String, dynamic>? arguments;

  MobileFadeInRoute({
    required this.page,
    required String routeName,
    this.arguments,
  }) : super(
         settings: RouteSettings(name: routeName, arguments: arguments),
         pageBuilder: (context, animation, secondaryAnimation) {
           final page = resolveRoute(routeName, context, args: arguments);
           return page;
         },
         transitionsBuilder: (context, animation, secondaryAnimation, child) =>
             FadeTransition(opacity: animation, child: child),
         transitionDuration: const Duration(milliseconds: 400),
       );

  static Widget resolveRoute(
    String routeName,
    BuildContext context, {
    Map<String, dynamic>? args,
  }) {
    switch (routeName) {
      case Routes.landing:
        return const Landing();
      case Routes.homepage:
        return Homepage(userId: cachedUserId, userLocation: cachedUserLocation);

      case Routes.search:
        return Search(
          userId: cachedUserId,
          locationQuery: getOptionalArg(context, 'locationQuery'),
        );

      case Routes.nearby:
        return Nearby(userId: cachedUserId, userLocation: cachedUserLocation);

      case Routes.account:
        return Account(userId: cachedUserId);

      case Routes.reservationHistory:
        return ReservationHistory(userId: cachedUserId!);

      case Routes.notificationSettings:
        return NotificationSettings(userId: cachedUserId!);

      case Routes.support:
        return Support(userId: cachedUserId!);

      case Routes.editProfile:
        return EditProfile(userId: cachedUserId!);

      case Routes.termsOfService:
        return const TermsOfService();

      case Routes.authentication:
        return const Authentication();

      case Routes.venue:
        return VenuePage(
          userId: cachedUserId,
          venueId: getRequiredArg<int>(context, 'venueId'),
        );

      case Routes.venueRatings:
        return RatingsPage(
          userId: cachedUserId,
          venueId: getRequiredArg<int>(context, 'venueId'),
        );

      case Routes.venuesByType:
        return VenuesByType(
          userLocation: cachedUserLocation,
          type: getRequiredArg<String>(context, 'type'),
        );

      case Routes.successfulReservation:
        return SuccessfulReservation(
          venueName: getRequiredArg<String>(context, 'venueName'),
          numberOfGuests: getRequiredArg<int>(context, 'numberOfGuests'),
          reservationDateTime: getRequiredArg<DateTime>(
            context,
            'reservationDateTime',
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  static T getRequiredArg<T>(BuildContext context, String key) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final value = args?[key];
    if (value is T) return value;
    throw Exception("Missing or invalid argument '$key'");
  }

  static T? getOptionalArg<T>(BuildContext context, String key) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final value = args?[key];
    return value is T ? value : null;
  }
}
