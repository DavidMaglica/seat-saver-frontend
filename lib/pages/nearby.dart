import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../components/appbar.dart';
import '../components/navbar.dart';
import '../themes/theme.dart';
import '../utils/routing_utils.dart';
import 'models/nearby_model.dart';

export 'models/nearby_model.dart';

class Nearby extends StatefulWidget {
  const Nearby({super.key});

  @override
  State<Nearby> createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  final int pageIndex = 2;
  late NearbyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NearbyModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  MapController osmMapController = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppbar(context: context),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            top: true,
            child: Column(
              children: [
                Expanded(
                    child: OSMFlutter(
                  controller: osmMapController,
                  osmOption: OSMOption(
                    userTrackingOption: const UserTrackingOption(
                      enableTracking: true,
                      unFollowUser: false,
                    ),
                    zoomOption: const ZoomOption(
                      initZoom: 14,
                      minZoomLevel: 2,
                      maxZoomLevel: 19,
                      stepZoom: 10,
                    ),
                    userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(
                          CupertinoIcons.location_solid,
                          color: AppThemes.accent1,
                        ),
                      ),
                      directionArrowMarker: const MarkerIcon(
                        icon: Icon(
                          CupertinoIcons.arrow_right_circle,

                          size: 48,
                        ),
                      ),
                    ),
                    roadConfiguration: const RoadOption(
                      roadColor: Colors.yellowAccent,
                    ),
                    markerOption: MarkerOption(
                        defaultMarker: const MarkerIcon(
                      icon: Icon(
                        CupertinoIcons.person_circle,
                        color: Colors.blue,
                        size: 56,
                      ),
                    )),
                  ),
                )),
              ],
            ),
          ),
          bottomNavigationBar: NavBar(
            currentIndex: pageIndex,
            context: context,
            onTap: (index, context) =>
                onNavbarItemTapped(pageIndex, index, context),
          )),
    );
  }
}
