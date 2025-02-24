import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../api/data/venue.dart';
import '../api/venue_api.dart';
import '../themes/theme.dart';
import '../utils/constants.dart';

class VenueSuggestedCard extends StatefulWidget {
  final String venueName;
  final String location;
  final String workingHours;
  final double rating;
  final VenueType type;
  final String description;
  final String? userEmail;
  final Position? userLocation;

  const VenueSuggestedCard({
    Key? key,
    required this.venueName,
    required this.location,
    required this.workingHours,
    required this.rating,
    required this.type,
    required this.description,
    this.userEmail,
    this.userLocation,
  }) : super(key: key);

  @override
  State<VenueSuggestedCard> createState() => _VenueSuggestedCardState();
}

class _VenueSuggestedCardState extends State<VenueSuggestedCard> {
  List<String>? _venueImages;

  VenueApi venueApi = VenueApi();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    List<String> venueImages = venueApi.getVenueImages(widget.venueName);
    setState(() => _venueImages = venueImages);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openVenue() => Navigator.pushNamed(context, Routes.VENUE, arguments: {
        'venueName': widget.venueName,
        'location': widget.location,
        'workingHours': widget.workingHours,
        'rating': widget.rating,
        'type': widget.type.toString(),
        'description': widget.description,
        'imageLinks': _venueImages,
        'userEmail': widget.userEmail,
        'userLocation': widget.userLocation,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async => _openVenue(),
        child: Container(
          width: 224,
          height: 196,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                blurRadius: 6,
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(),
                    _buildNameAndType(widget.venueName, widget.type),
                    _buildLocationAndWorkingHours(
                        widget.location, widget.workingHours),
                    _buildRatingBar(widget.rating),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Hero _buildImage() => Hero(
      tag: 'locationCardImage${randomDouble(0, 100)}',
      transitionOnUserGestures: true,
      child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: Image.asset(
            _venueImages!.first,
            width: double.infinity,
            height: 110,
            fit: BoxFit.cover,
          )));

  Padding _buildNameAndType(String name, VenueType type) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppThemes.accent1)),
          Text(type.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 10,
              )),
        ],
      ));

  Padding _buildLocationAndWorkingHours(String location, String workingHours) =>
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(location,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                )),
            Text(workingHours,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 9)),
          ],
        ),
      );

  Padding _buildRatingBar(double rating) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(08, 8, 0, 0),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        RatingBarIndicator(
          itemBuilder: (context, index) => Icon(
            CupertinoIcons.star_fill,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          direction: Axis.horizontal,
          rating: rating,
          unratedColor: const Color(0xFF57636C).withOpacity(0.5),
          itemCount: 5,
          itemSize: 14,
        )
      ]));
}
