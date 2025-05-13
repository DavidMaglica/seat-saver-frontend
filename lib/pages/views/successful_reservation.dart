import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../models/successful_reservation_model.dart';

class SuccessfulReservation extends StatelessWidget {
  final String venueName;
  final int numberOfGuests;
  final DateTime reservationDateTime;
  final String userEmail;
  final Position? userLocation;

  const SuccessfulReservation({
    Key? key,
    required this.venueName,
    required this.numberOfGuests,
    required this.reservationDateTime,
    required this.userEmail,
    this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SuccessfulReservationModel(
        context: context,
        venueName: venueName,
        numberOfGuests: numberOfGuests,
        reservationDateTime: reservationDateTime,
        userEmail: userEmail,
        userLocation: userLocation,
      )..startCountdown(),
      child: Consumer<SuccessfulReservationModel>(
        builder: (context, model, _) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SafeArea(
                top: true,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0, -1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Successful Reservation',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 36),
                            _buildIcon(context),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Your reservation was successfully placed.\n\n'
                                '${model.venueName} will be preparing a table for ${model.numberOfGuests} '
                                'at ${DateFormat('HH:mm').format(model.reservationDateTime)} hours '
                                'on date ${DateFormat('dd-MM-yyyy').format(model.reservationDateTime)}.',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                'Navigating back in ${model.countdown} seconds...',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: FFButtonWidget(
                                onPressed: () {
                                  model.cancelCountdown();
                                  model.navigateToHomepage();
                                },
                                text: 'Back',
                                options: FFButtonOptions(
                                  width: 270,
                                  height: 50,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  textStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 16,
                                  ),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    width: 2,
                                  ),
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildIcon(BuildContext context) {
    return Container(
      width: 196,
      height: 196,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 4,
        ),
      ),
      child: Icon(
        CupertinoIcons.check_mark,
        color: Theme.of(context).colorScheme.primary,
        size: 72,
      ),
    );
  }
}
