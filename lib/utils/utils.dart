import 'package:TableReserver/themes/theme.dart';
import 'package:flutter/material.dart';

Color calculateAvailabilityColour(int maximumCapacity, int availableCapacity) {
  final ratio = maximumCapacity > 0 ? availableCapacity / maximumCapacity : 0.0;

  return ratio >= 0.4
      ? AppThemes.successColor
      : ratio >= 0.1
          ? AppThemes.warningColor
          : Colors.red;
}
