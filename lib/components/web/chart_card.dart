import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_reserver/_patched_packages/flutterflow_ui/lib/flutterflow_ui.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/pages/web/views/reservations.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class ChartCard extends StatelessWidget {
  final BuildContext context;
  final Venue venue;
  final List<ReservationDetails> reservations;
  final bool isWeekly;

  const ChartCard({
    super.key,
    required this.context,
    required this.venue,
    required this.reservations,
    required this.isWeekly,
  });

  @override
  Widget build(BuildContext context) {
    final bins = isWeekly
        ? List<int>.generate(7, (i) => i)
        : List<int>.generate(6, (i) => i * 4);

    final values = isWeekly
        ? countReservationsPerDay(reservations)
        : countReservationsPerHourBins(reservations, bins);

    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleRow(context),
              const SizedBox(height: 8),
              Text(
                'Working hours: ${venue.workingHours}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 64),
              Expanded(child: _buildBarChart(values, bins)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(venue.name, style: Theme.of(context).textTheme.titleMedium),
        FFButtonWidget(
          text: 'View reservations',
          onPressed: () {
            Navigator.of(context).push(
              FadeInRoute(
                page: WebReservations(venueId: venue.id),
                routeName: '${Routes.webReservations}?venueId=${venue.id}',
              ),
            );
          },
          options: FFButtonOptions(
            width: 150,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: WebTheme.infoColor,
            textStyle: const TextStyle(color: WebTheme.offWhite, fontSize: 14),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List<int> values, List<int> bins) {
    final List<List<int>> workingRanges = isWeekly
        ? <List<int>>[]
        : parseWorkingHours(venue.workingHours);
    return BarChart(
      BarChartData(
        barTouchData: _barTouchData(),
        titlesData: _flTitlesData(),
        borderData: FlBorderData(show: false),
        barGroups: _barGroups(values, bins, workingRanges),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
      ),
    );
  }

  BarTouchData _barTouchData() {
    return BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => WebTheme.transparentColour,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 8,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final bins = isWeekly
              ? List<int>.generate(7, (i) => i)
              : List<int>.generate(6, (i) => i * 4);

          if (!isWeekly) {
            final workingRanges = parseWorkingHours(venue.workingHours);
            final startHour = bins[group.x.toInt()];
            final endHour = startHour + 4;
            final isOpen = isBinInWorkingHours(
              startHour,
              endHour,
              workingRanges,
            );

            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: isOpen ? 1.0 : 0.4),
                fontWeight: isOpen ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }

          return BarTooltipItem(
            rod.toY.round().toString(),
            TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }

  FlTitlesData _flTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          getTitlesWidget: (value, meta) {
            final workingRanges = parseWorkingHours(venue.workingHours);

            String text;
            if (isWeekly) {
              text = [
                'Mon',
                'Tue',
                'Wed',
                'Thu',
                'Fri',
                'Sat',
                'Sun',
              ][value.toInt()];
            } else {
              final start = (value.toInt() * 4);
              final end = ((value.toInt() + 1) * 4).clamp(0, 24);
              text =
                  '${start.toString().padLeft(2, '0')}-${end.toString().padLeft(2, '0')}';

              final isOpen = isBinInWorkingHours(start, end, workingRanges);

              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Text(
                  text,
                  style: TextStyle(
                    color: isOpen
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(
                            context,
                          ).colorScheme.onPrimary.withValues(alpha: 0.5),
                    fontWeight: isOpen ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              );
            }

            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 4,
              child: Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            );
          },
        ),
      ),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  List<BarChartGroupData> _barGroups(
    List<int> values,
    List<int> bins,
    List<List<int>> workingRanges,
  ) {
    return List.generate(values.length, (i) {
      final bool isOpen;
      if (isWeekly) {
        isOpen = true;
      } else {
        final startHour = bins[i];
        final endHour = startHour + 4;
        isOpen = isBinInWorkingHours(startHour, endHour, workingRanges);
      }

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: values[i].toDouble(),
            color: isOpen
                ? WebTheme.accent1
                : WebTheme.accent1.withValues(alpha: 0.3),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  List<int> countReservationsPerDay(List<ReservationDetails> reservations) {
    List<int> counts = List.filled(7, 0);
    for (final reservation in reservations) {
      counts[reservation.datetime.weekday - 1]++;
    }
    return counts;
  }

  List<int> countReservationsPerHourBins(
    List<ReservationDetails> reservations,
    List<int> bins, {
    int binSize = 4,
  }) {
    List<int> counts = List.filled(bins.length, 0);
    for (final reservation in reservations) {
      final hour = reservation.datetime.hour;
      for (int i = 0; i < bins.length; i++) {
        if (hour >= bins[i] && hour < bins[i] + binSize) {
          counts[i]++;
          break;
        }
      }
    }
    return counts;
  }

  List<List<int>> parseWorkingHours(String workingHours) {
    final match = RegExp(
      r'^(?:[01]\d|2[0-3]):[0-5]\d\s*-\s*(?:[01]\d|2[0-3]):[0-5]\d$',
    ).firstMatch(workingHours);

    if (match == null) return [];

    final parts = workingHours.split('-');
    int startHour = int.parse(parts[0].split(':')[0]);
    int endHour = int.parse(parts[1].split(':')[0]);

    if (startHour < endHour) {
      return [
        [startHour, endHour],
      ];
    } else {
      return [
        [startHour, 24],
        [0, endHour],
      ];
    }
  }

  bool isBinInWorkingHours(int startHour, int endHour, List<List<int>> ranges) {
    for (final range in ranges) {
      if (startHour < range[1] && endHour > range[0]) {
        return true;
      }
    }
    return false;
  }
}
