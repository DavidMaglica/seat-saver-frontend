import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../api/account_api.dart';
import '../themes/theme.dart';
import '../utils/constants.dart';

class LocationPermissionPopUp extends StatefulWidget {
  final String userEmail;

  const LocationPermissionPopUp({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<LocationPermissionPopUp> createState() =>
      _LocationPermissionPopUpState();
}

class _LocationPermissionPopUpState extends State<LocationPermissionPopUp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission locationPermission;

    if (!await Geolocator.isLocationServiceEnabled()) return false;

    locationPermission = await Geolocator.checkPermission();

    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      if (await Geolocator.requestPermission() == LocationPermission.denied) {
        return false;
      }
    }

    if (locationPermission == LocationPermission.deniedForever) return false;

    updateLocationServices(widget.userEmail, true);

    return true;
  }

  Future<String?> _getCityFromLatLng(Position? position) async {
    String? currentCity;
    await placemarkFromCoordinates(position!.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      currentCity = placemarks[0].locality;
    }).catchError((e) {
      debugPrint(e);
    });

    return currentCity;
  }

  Future<void> _getCurrentPosition() async {
    if (!await _handleLocationPermission()) return;

    Position? userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String? currentCity = await _getCityFromLatLng(userLocation);
    if (currentCity == null || currentCity.isEmpty) {
      if (!mounted) return;
      showToast('Failed to get current location',
          context: context,
          animation: StyledToastAnimation.scale,
          position: StyledToastPosition.center,
          duration: const Duration(seconds: 4));
    }

    updateUserLocation(widget.userEmail, userLocation);

    if (!mounted) return;
    Navigator.popAndPushNamed(context, Routes.HOMEPAGE, arguments: {
      'userEmail': widget.userEmail,
      'userLocation': userLocation,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: AlignmentDirectional(0, -1),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                child: Icon(CupertinoIcons.location_solid,
                    color: AppThemes.warningColor, size: 64),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 12),
                child: Text(
                  'Our app works best with location enabled',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 96),
                child: Text(
                    'Find your favourite spots! Activate location services to easily locate venues near you!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 1),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: FFButtonWidget(
                  onPressed: _getCurrentPosition,
                  text: 'Enable location',
                  options: FFButtonOptions(
                    width: 270,
                    height: 40,
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Theme.of(context).colorScheme.primary,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 16,
                    ),
                    elevation: 3,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
              child: FFButtonWidget(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                    Routes.HOMEPAGE,
                    arguments: {
                      'userEmail': widget.userEmail,
                      'userLocation': null
                    },
                  );
                },
                text: 'No, thanks',
                options: FFButtonOptions(
                  width: 270,
                  height: 40,
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: Theme.of(context).colorScheme.background,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                  ),
                  elevation: 3,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
