import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../api/geolocation_api.dart';
import '../themes/theme.dart';

class LocationPermissionPopUp extends StatefulWidget {
  const LocationPermissionPopUp({super.key});

  @override
  State<LocationPermissionPopUp> createState() =>
      _LocationPermissionPopUpState();
}

class _LocationPermissionPopUpState extends State<LocationPermissionPopUp> {
  Position? _currentPosition;
  String? _currentCity;
  List<String>? _nearbyCities;

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

    return true;
  }

  Future<String?> _getAddressFromLatLng(Position? position) async {
    String? currentCity;
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      currentCity = place.locality;
    }).catchError((e) {
      debugPrint(e);
    });

    return currentCity;
  }

  Future<void> _getCurrentPosition() async {
    if (!await _handleLocationPermission()) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });

    if (_currentPosition == null) return;

    await _getAddressFromLatLng(_currentPosition).then((currentCity) {
      setState(() {
        _currentCity = currentCity;
      });
    }).catchError((e) {
      debugPrint(e);
    });
    await getNearbyCities(_currentPosition!).then((nearbyCities) {
      debugPrint('Cities on FE: $nearbyCities');
      setState(() {
        _nearbyCities = nearbyCities;
      });
    }).catchError((e) {
      debugPrint(e);
    });

    Navigator.of(context).pop([_currentCity, _nearbyCities]);
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
                  Navigator.of(context).pop();
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
