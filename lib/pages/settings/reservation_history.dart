import 'package:TableReserver/api/data/reservation_details.dart';
import 'package:TableReserver/components/custom_appbar.dart';
import 'package:TableReserver/components/modal_widgets.dart';
import 'package:TableReserver/models/reservation_history_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ReservationHistory extends StatelessWidget {
  final int userId;
  final Position? userLocation;

  const ReservationHistory({
    Key? key,
    required this.userId,
    this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReservationHistoryModel(
        context: context,
        userId: userId,
        userLocation: userLocation,
      )..init(),
      child: Builder(
        builder: (context) {
          final model = context.watch<ReservationHistoryModel>();

          return Scaffold(
            key: model.scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppbar(
              title: 'Reservation History',
              onBack: () => Navigator.of(context).pushNamed(
                Routes.account,
                arguments: {
                  'userId': userId,
                  'userLocation': model.userLocation,
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 36),
                    Padding(
                      padding: const EdgeInsetsDirectional.all(16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(.5),
                              offset: const Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _buildReservationHistory(context, model),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _buildReservationHistory(
    BuildContext ctx,
    ReservationHistoryModel model,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: model.reservations == null || model.reservations!.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'No Reservation History',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            )
          : _buildReservation(ctx, model),
    );
  }

  Widget _buildReservation(
    BuildContext ctx,
    ReservationHistoryModel model,
  ) {
    return Column(
      children: model.reservations!.asMap().entries.map((entry) {
        int index = entry.key;
        var reservation = entry.value;

        return Column(
          children: [
            InkWell(
              onTap: () => _openReservationDetailsBottomSheet(
                ctx,
                model,
                reservation,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.getVenueName(reservation.venueId),
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            'view details',
                            style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(ctx)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(.6),
                                ),
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_right,
                          color: Theme.of(ctx).colorScheme.onPrimary,
                          size: 14,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (index < model.reservations!.length - 1) _buildDivider(ctx),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDivider(BuildContext ctx) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Theme.of(ctx).colorScheme.onPrimary.withOpacity(0.5),
    );
  }

  void _openReservationDetailsBottomSheet(
    BuildContext ctx,
    ReservationHistoryModel model,
    ReservationDetails reservation,
  ) {
    final String venueName = model.getVenueName(reservation.venueId);

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: modalPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildModalTitle(context, 'Reservation Detail'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildDetailRow(context, 'Venue name', venueName),
                    Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.5),
                      thickness: 0.5,
                    ),
                    _buildDetailRow(
                      context,
                      'Number of Guests',
                      reservation.numberOfGuests.toString(),
                    ),
                    Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.5),
                      thickness: 0.5,
                    ),
                    _buildDetailRow(
                      context,
                      'Date (dd-MM-yyyy HH:mm)',
                      DateFormat('dd-MM-yyyy HH:mm')
                          .format(reservation.datetime),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildModalButton(
                    'Cancel',
                    () => Navigator.pop(context),
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                  buildModalButton(
                    'Delete',
                    () => model.deleteReservation(reservation.id),
                    AppThemes.errorColor,
                  )
                ],
              ),
              const SizedBox(height: 36),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext ctx, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(ctx).textTheme.titleSmall,
          ),
          Text(
            value,
            style: Theme.of(ctx).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
