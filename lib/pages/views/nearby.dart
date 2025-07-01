import 'package:TableReserver/components/navbar.dart';
import 'package:TableReserver/utils/routing_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Builds Google Map with the user's location. If no location is provided, uses a default location (Zagreb).
/// Google Map is currently commented out as it consumes tokens which i as a student do not want to spend until necessary.
class Nearby extends StatefulWidget {
  final int? userId;
  final Position? userLocation;

  const Nearby({
    Key? key,
    this.userId,
    this.userLocation,
  }) : super(key: key);

  @override
  State<Nearby> createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  final unfocusNode = FocusNode();
  final int pageIndex = 2;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late GoogleMapController googleMapController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    googleMapController.dispose();
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: const SafeArea(
            child: Column(
              children: [
                Expanded(child: SizedBox.shrink()
                    // GoogleMap(
                    //   onMapCreated: (controller) {
                    //     setState(() {
                    //       googleMapController = controller;
                    //     });
                    //   },
                    //   initialCameraPosition: CameraPosition(
                    //     target: LatLng(
                    //       widget.userLocation?.latitude ?? 45.815399,
                    //       widget.userLocation?.longitude ?? 15.966568,
                    //     ),
                    //     zoom: 14.0,
                    //   ),
                    //   markers: {
                    //     Marker(
                    //       markerId: const MarkerId('userLocation'),
                    //       position: LatLng(
                    //         widget.userLocation?.latitude ?? 45.815399,
                    //         widget.userLocation?.longitude ?? 15.966568,
                    //       ),
                    //       infoWindow: const InfoWindow(title: 'Your Location'),
                    //     )
                    //   },
                    // ),
                    )
              ],
            ),
          ),
          bottomNavigationBar: NavBar(
            currentIndex: pageIndex,
            onTap: (index, context) => onNavbarItemTapped(
                context, pageIndex, index, widget.userId, widget.userLocation),
          ),
        ),
      ),
    );
  }
}
