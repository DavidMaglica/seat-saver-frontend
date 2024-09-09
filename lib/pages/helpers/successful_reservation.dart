import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class SuccessfulReservation extends StatefulWidget {
  final String venueName;
  final int numberOfPeople;
  final String reservationDate;
  final String reservationTime;

  const SuccessfulReservation({
    Key? key,
    required this.venueName,
    required this.numberOfPeople,
    required this.reservationDate,
    required this.reservationTime,
  }) : super(key: key);

  @override
  State<SuccessfulReservation> createState() => _SuccessfulReservationState();
}

class _SuccessfulReservationState extends State<SuccessfulReservation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _timer;
  int _start = 15;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _start == 0
          ? {timer.cancel(), Navigator.pop(context)}
          : setState(() => _start--);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      _buildIcon(),
                      _buildText(widget.venueName, widget.numberOfPeople,
                          widget.reservationDate, widget.reservationTime),
                      _buildCountdown(),
                      _buildBackButton()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildText(
    String venueName,
    int numberOfPeople,
    String reservationDate,
    String reservationTime,
  ) =>
      Padding(
        padding: const EdgeInsets.all(16), // Adjust the padding as needed
        child: Align(
          alignment: const AlignmentDirectional(0, -1),
          child: Text(
            'Your reservation was successfully placed.\n\n'
            '$venueName will be preparing a table for $numberOfPeople at $reservationTime on $reservationDate.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );

  Align _buildIcon() => Align(
        alignment: const AlignmentDirectional(0, -1),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 36, 0, 36),
          child: Container(
            width: 196,
            height: 196,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 4,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Icon(
                CupertinoIcons.check_mark,
                color: Theme.of(context).colorScheme.primary,
                size: 72,
              ),
            ),
          ),
        ),
      );

  Align _buildTitle() => Align(
      alignment: const AlignmentDirectional(0, -1),
      child: Text(
        'Successful Reservation',
        style: Theme.of(context).textTheme.titleLarge,
      ));

  Align _buildCountdown() => Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
        child: Text(
          'Navigating back in $_start seconds...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ));

  Align _buildBackButton() => Align(
        alignment: const AlignmentDirectional(0, 0),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
          child: FFButtonWidget(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Back',
            options: FFButtonOptions(
              width: 270,
              height: 50,
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              color: Theme.of(context).colorScheme.background,
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
              ),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary,
                width: 2,
              ),
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
