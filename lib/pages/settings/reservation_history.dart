import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/data/reservation_details.dart';
import '../../api/data/user.dart';
import '../../api/reservation_api.dart';
import '../../components/custom_appbar.dart';
import '../../utils/constants.dart';
import 'helpers/edit_profile_helpers.dart';
import 'utils/settings_utils.dart';

class ReservationHistory extends StatefulWidget {
  final User user;
  final Position? userLocation;

  const ReservationHistory({
    Key? key,
    required this.user,
    this.userLocation,
  }) : super(key: key);

  @override
  State<ReservationHistory> createState() => _ReservationHistoryState();
}

class _ReservationHistoryState extends State<ReservationHistory> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<ReservationDetails>? reservations;

  @override
  void initState() {
    super.initState();
    _getUsersReservations(widget.user.email);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getUsersReservations(String userEmail) async {
    ReservationResponse response = await getReservations(userEmail);
    if (response.success) {
      setState(() => reservations = response.reservations);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppbar(
          title: 'Reservation History',
          routeToPush: Routes.ACCOUNT,
          args: {
            'userEmail': widget.user.email,
            'userLocation': widget.userLocation
          },
        ),
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 36, 0, 0),
                ),
                _buildReservationHistoryGroup(),
              ]),
            )));
  }

  Padding _buildReservationHistoryGroup() => Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
                offset: const Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildReservationDetails(reservations),
                ],
              )),
        ),
      );

  Divider _buildDivider() {
    return Divider(
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
      thickness: .5,
    );
  }

  Padding _buildReservationDetails(List<ReservationDetails>? reservations) {
    if (reservations == null || reservations.isEmpty) {
      return Padding(
          padding: const EdgeInsetsDirectional.all(12),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'No Reservation History',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ]));
    }

    return Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: Column(
        children: reservations.asMap().entries.map((entry) {
          int index = entry.key;
          ReservationDetails reservation = entry.value;

          return Column(
            children: [
              InkWell(
                  onTap: () {
                    _openReservationDetailsBottomSheet(
                        reservation.venueName,
                        reservation.numberOfGuests,
                        reservation.reservationDateTime);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd-MM-yyyy HH:mm')
                              .format(reservation.reservationDateTime),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 8, 0),
                              child: Text(
                                'view details',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(.6),
                                    ),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_right,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 14,
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              if (index < reservations.length - 1) _buildDivider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _openReservationDetailsBottomSheet(
          String venueName, int numberOfGuests, DateTime reservationDateTime) =>
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          builder: (BuildContext context) {
            return Padding(
                padding: modalPadding(context),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  buildModalTitle('Reservation detail', context),
                  const SizedBox(height: 16),
                  _buildDetails(venueName, numberOfGuests, reservationDateTime),
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 24),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildModalButton(
                                'Done',
                                () => {Navigator.pop(context)},
                                Theme.of(context).colorScheme.onPrimary),
                          ])),
                  const SizedBox(height: 36),
                ]));
          });

  Padding _buildDetails(
    String venueName,
    int numberOfGuests,
    DateTime reservationDateTime,
  ) =>
      Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
          child: Column(
            children: [
              _buildDetailRow('Venue', venueName),
              _buildDivider(),
              _buildDetailRow('Number of guests', numberOfGuests.toString()),
              _buildDivider(),
              _buildDetailRow('Date (dd-mm-yyyy hh:mm)',
                  DateFormat('dd-MM-yyyy HH:mm').format(reservationDateTime)),
            ],
          ));

  Padding _buildDetailRow(String label, String value) => Padding(
      padding: const EdgeInsetsDirectional.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ));
}
