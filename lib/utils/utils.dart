import 'package:TableReserver/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Color calculateAvailabilityColour(int maximumCapacity, int availableCapacity) {
  final ratio = maximumCapacity > 0 ? availableCapacity / maximumCapacity : 0;

  return ratio >= 0.4
      ? AppThemes.successColor
      : ratio >= 0.1
          ? AppThemes.warningColor
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
