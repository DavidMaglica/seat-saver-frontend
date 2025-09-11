import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seat_saver/themes/mobile_theme.dart';
import 'package:seat_saver/themes/web_theme.dart';

Color calculateAvailabilityColour(int maximumCapacity, int availableCapacity) {
  final ratio = maximumCapacity > 0 ? availableCapacity / maximumCapacity : 0.0;

  return ratio >= 0.4
      ? MobileTheme.successColor
      : ratio >= 0.1
      ? MobileTheme.warningColor
      : Colors.red;
}

Position? getPositionFromLatAndLong(
  double? lastKnownLatitude,
  double? lastKnownLongitude,
) {
  if (lastKnownLatitude == null || lastKnownLongitude == null) {
    return null;
  }
  return Position(
    latitude: lastKnownLatitude,
    longitude: lastKnownLongitude,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

LinearGradient fallbackImageGradient() {
  return LinearGradient(
    colors: [
      const Color(0xFF1B5E20).withValues(alpha: 0.8),
      const Color(0xFF43A047).withValues(alpha: 0.8),
      const Color(0xFFFF7043).withValues(alpha: 0.8),
      const Color(0xFFFF5722).withValues(alpha: 0.8),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: const [0.0, 0.5, 0.9, 1.0],
  );
}

LinearGradient fallbackImageGradientReverted() {
  return LinearGradient(
    colors: [
      const Color(0xFFFF5722).withValues(alpha: 0.8),
      const Color(0xFFFF7043).withValues(alpha: 0.8),
      const Color(0xFF43A047).withValues(alpha: 0.8),
      const Color(0xFF1B5E20).withValues(alpha: 0.8),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: const [0.0, 0.5, 0.9, 1.0],
  );
}

BoxDecoration webBackgroundGradient(BuildContext context) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        WebTheme.successColor,
        WebTheme.accent1,
        Theme.of(context).colorScheme.surface,
      ],
      stops: const [0, 0.5, 1],
      begin: const AlignmentDirectional(-1, -1),
      end: const AlignmentDirectional(1, 1),
    ),
  );
}

BoxDecoration webBackgroundAuxiliaryGradient(BuildContext context) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        WebTheme.transparentColour,
        Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        Theme.of(context).colorScheme.surface,
      ],
      stops: const [0, 0.8, 1],
      begin: const AlignmentDirectional(0, -1),
      end: const AlignmentDirectional(0, 1),
    ),
  );
}

bool isWithinWorkingHours(DateTime reservationDate, String workingHours) {
  final parts = workingHours.split('-').map((s) => s.trim()).toList();
  if (parts.length != 2) return false;

  final startParts = parts[0].split(':');
  final endParts = parts[1].split(':');

  final startHour = int.parse(startParts[0]);
  final startMinute = int.parse(startParts[1]);
  final endHour = int.parse(endParts[0]);
  final endMinute = int.parse(endParts[1]);

  final startTime = DateTime(
    reservationDate.year,
    reservationDate.month,
    reservationDate.day,
    startHour,
    startMinute,
  );
  final endTime = DateTime(
    reservationDate.year,
    reservationDate.month,
    reservationDate.day,
    endHour,
    endMinute,
  );

  return reservationDate.isAfter(startTime) &&
      reservationDate.isBefore(endTime);
}

Future<Position> getTestPosition() async {
  return Position(
    latitude: 45.23,
    longitude: 13.61,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 1,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );
}