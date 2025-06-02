import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/navbar.dart';
import '../../themes/theme.dart';
import '../../utils/routing_utils.dart';

class Nearby extends StatefulWidget {
  final String? userEmail;
  final Position? userLocation;

  const Nearby({
    Key? key,
    this.userEmail,
    this.userLocation,
  }) : super(key: key);

  @override
  State<Nearby> createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  final unfocusNode = FocusNode();
  final int pageIndex = 2;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late MapController osmMapController;

  String? email;

  @override
  void initState() {
    super.initState();
    if (widget.userEmail != null) setState(() => email = widget.userEmail);

    osmMapController = MapController(
      initPosition: GeoPoint(
        latitude: widget.userLocation?.latitude ?? 45.815399,
        longitude: widget.userLocation?.longitude ?? 15.966568,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return GestureDetector(
        onTap: () => unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            child: Scaffold(
                key: scaffoldKey,
                resizeToAvoidBottomInset: false,
                backgroundColor: Theme.of(context).colorScheme.background,
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: OSMFlutter(
                          controller: osmMapController,
                          osmOption: OSMOption(
                              showDefaultInfoWindow: true,
                              isPicker: false,
                              showContributorBadgeForOSM: true,
                              userTrackingOption: const UserTrackingOption(
                                enableTracking: true,
                                unFollowUser: false,
                              ),
                              zoomOption: const ZoomOption(
                                initZoom: 16,
                                minZoomLevel: 2,
                                maxZoomLevel: 19,
                                stepZoom: 10,
                              ),
                              markerOption: MarkerOption(
                                  defaultMarker: const MarkerIcon(
                                      icon: Icon(
                                CupertinoIcons.location_solid,
                                color: AppThemes.accent1,
                                size: 32,
                              )))),
                        ),
                      )
                    ],
                  ),
                ),
                bottomNavigationBar: NavBar(
                  currentIndex: pageIndex,
                  onTap: (index, context) => onNavbarItemTapped(context,
                      pageIndex, index, widget.userEmail, widget.userLocation),
                ))));
  }
}
