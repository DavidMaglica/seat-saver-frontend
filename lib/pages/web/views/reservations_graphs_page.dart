import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/api/data/reservation_details.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/components/mobile/custom_appbar.dart';
import 'package:seat_saver/components/web/chart_card.dart';
import 'package:seat_saver/components/web/timer_dropdown.dart';
import 'package:seat_saver/models/web/views/reservations_graphs_page_model.dart';
import 'package:seat_saver/pages/web/views/homepage.dart';
import 'package:seat_saver/themes/web_theme.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';

class ReservationsGraphsPage extends StatefulWidget {
  final int ownerId;
  final ReservationsGraphsPageModel? modelOverride;

  const ReservationsGraphsPage({
    super.key,
    required this.ownerId,
    this.modelOverride,
  });

  @override
  State<ReservationsGraphsPage> createState() => _ReservationsGraphsPageState();
}

class _ReservationsGraphsPageState extends State<ReservationsGraphsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          widget.modelOverride ??
                ReservationsGraphsPageModel(ownerId: widget.ownerId)
            ..init(),
      child: Consumer<ReservationsGraphsPageModel>(
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppbar(
              title: 'Reservation Graphs',
              onBack: () {
                Navigator.of(context).push(
                  FadeInRoute(
                    page: WebHomepage(ownerId: widget.ownerId),
                    routeName: Routes.webHomepage,
                  ),
                );
              },
            ),
            body: SafeArea(
              top: true,
              child: Container(
                width: 1920,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: SingleChildScrollView(
                  child: Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderRow(context, model).animateOnPageLoad(
                              model.animationsMap['titleRowOnLoad']!,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              color: WebTheme.transparentColour,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                child: _buildMasonryGrid(context, model)
                                    .animateOnPageLoad(
                                      model.animationsMap['gridOnLoad']!,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderRow(
    BuildContext context,
    ReservationsGraphsPageModel model,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildToggleContainer(context, model),
          const SizedBox(width: 24),
          TimerDropdown(
            key: const Key('timerDropdown'),
            selectedInterval: model.selectedInterval,
            onChanged: (value) {
              setState(() {
                model.selectedInterval = value;
              });
              model.startTimer();
            },
          ),
          const SizedBox(width: 8),
          FFButtonWidget(
            key: const Key('refreshButton'),
            onPressed: () {
              model.init();
            },
            text: 'Refresh data',
            icon: const Icon(CupertinoIcons.refresh, size: 18),
            options: FFButtonOptions(
              height: 40,
              iconColor: Theme.of(context).colorScheme.primary,
              color: WebTheme.infoColor,
              textStyle: const TextStyle(
                fontSize: 16,
                color: WebTheme.offWhite,
              ),
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleContainer(
    BuildContext context,
    ReservationsGraphsPageModel model,
  ) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption(
              context,
              model,
              const Key('dailyOption'),
              label: "Daily",
              icon: Icons.calendar_today,
              selected: !model.isWeekly,
              onTap: () {
                model.toggleGraphType(false);
              },
            ),
            _buildOption(
              context,
              model,
              const Key('weeklyOption'),
              label: "Weekly",
              icon: Icons.calendar_month,
              selected: model.isWeekly,
              onTap: () {
                model.toggleGraphType(true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    ReservationsGraphsPageModel model,
    Key key, {
    required String label,
    required IconData icon,
    required bool selected,
    required Function onTap,
  }) {
    return GestureDetector(
      key: key,
      onTap: () => onTap(),
      child: AnimatedContainer(
        height: 40,
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? WebTheme.accent1
              : Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? WebTheme.offWhite
                  : Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: selected
                    ? WebTheme.offWhite
                    : Theme.of(context).colorScheme.onPrimary,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasonryGrid(
    BuildContext context,
    ReservationsGraphsPageModel model,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: MasonryGridView.builder(
        key: const Key('graphsMasonryGrid'),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        crossAxisSpacing: 24,
        mainAxisSpacing: 12,
        itemCount: model.venues.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (model.venues.isEmpty) {
            return const Center(child: Text("No venues available"));
          }

          Venue venue = model.venues[index];
          List<ReservationDetails> reservations =
              model.reservationsByVenueId[venue.id] ?? [];
          return ChartCard(
            context: context,
            venue: venue,
            reservations: reservations,
            isWeekly: model.isWeekly,
          );
        },
      ),
    );
  }
}
