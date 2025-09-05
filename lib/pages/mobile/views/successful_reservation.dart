import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/models/mobile/views/successful_reservation_model.dart';

class SuccessfulReservation extends StatelessWidget {
  final String venueName;
  final int numberOfGuests;
  final DateTime reservationDateTime;

  const SuccessfulReservation({
    super.key,
    required this.venueName,
    required this.numberOfGuests,
    required this.reservationDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SuccessfulReservationModel(
        venueName: venueName,
        numberOfGuests: numberOfGuests,
        reservationDateTime: reservationDateTime,
      )..startCountdown(context),
      child: Consumer<SuccessfulReservationModel>(
        builder: (context, model, _) {
          var brightness = Theme.of(context).brightness;
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: brightness == Brightness.dark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: SafeArea(
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
                                key: const Key('titleText'),
                                'Successful Reservation',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 36),
                              _buildIcon(context),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  key: const Key('messageText'),
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
                                  key: const Key('backButton'),
                                  onPressed: () {
                                    model.cancelCountdown();
                                    model.navigateToHomepage(context);
                                  },
                                  text: 'Back',
                                  options: FFButtonOptions(
                                    width: 270,
                                    height: 50,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    textStyle: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontSize: 16,
                                    ),
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(BuildContext ctx) {
    return Container(
      width: 196,
      height: 196,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(ctx).colorScheme.primary, width: 4),
      ),
      child: Icon(
        key: const Key('icon'),
        CupertinoIcons.check_mark,
        color: Theme.of(ctx).colorScheme.primary,
        size: 72,
      ),
    );
  }
}
