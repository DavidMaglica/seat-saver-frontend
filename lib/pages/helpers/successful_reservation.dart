import 'dart:async';

import 'package:TableReserver/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

class SuccessfulReservation extends StatefulWidget {
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
  State<SuccessfulReservation> createState() => _SuccessfulReservationState();
}

class _SuccessfulReservationState extends State<SuccessfulReservation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? timer;
  int _start = 15;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _start == 0
          ? {
              timer.cancel(),
              Navigator.popAndPushNamed(context, Routes.HOMEPAGE, arguments: {
                'userEmail': widget.userEmail,
                'userLocation': widget.userLocation
              })
            }
          : setState(() => _start--);
    });
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
                      _buildText(widget.venueName, widget.numberOfGuests,
                          widget.reservationDateTime),
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
    DateTime reservationDateTime,
  ) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateFormat timeFormat = DateFormat('HH:mm');

    String formattedDate = dateFormat.format(reservationDateTime);
    String formattedTime = timeFormat.format(reservationDateTime);

    return Padding(
      padding: const EdgeInsets.all(16), // Adjust the padding as needed
      child: Align(
        alignment: const AlignmentDirectional(0, -1),
        child: Text(
          'Your reservation was successfully placed.\n\n'
          '$venueName will be preparing a table for $numberOfPeople at $formattedTime hours on date $formattedDate.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

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
              setState(() {
                timer?.cancel();
              });
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
