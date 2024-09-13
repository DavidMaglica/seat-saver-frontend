import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../api/data/venue.dart';
import '../themes/theme.dart';
import '../utils/constants.dart';

class VenueCard extends StatefulWidget {
  final String venueName;
  final String location;
  final String workingHours;
  final double rating;
  final VenueType type;
  final String description;
  final String? userEmail;
  final Position? userLocation;

  const VenueCard({
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
  State<VenueCard> createState() => _VenueCardState();
}

class _VenueCardState extends State<VenueCard> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTap() => Navigator.pushNamed(context, Routes.VENUE, arguments: {
        'venueName': widget.venueName,
        'location': widget.location,
        'workingHours': widget.workingHours,
        'rating': widget.rating,
        'type': widget.type.toString(),
        'description': widget.description,
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
        onTap: () async {
          _onTap();
        },
        child: Container(
          width: 148,
          height: 148,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary,
              width: .2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImage(),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildName(widget.venueName),
                        _buildLocation(widget.location),
                        _buildRatingBar(widget.rating),
                      ],
                    ),
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
          child: Image.network(
            'https://images.unsplash.com/photo-1528114039593-4366cc08227d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8aXRhbHl8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
            width: double.infinity,
            height: 80,
            fit: BoxFit.cover,
          )));

  Text _buildName(String name) => Text(name,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(color: AppThemes.infoColor, fontSize: 12));

  Padding _buildLocation(String location) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Text(location,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            )),
      ]));

  Padding _buildRatingBar(double rating) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        RatingBarIndicator(
          itemBuilder: (context, index) => Icon(
            CupertinoIcons.star_fill,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          direction: Axis.horizontal,
          rating: rating,
          unratedColor: const Color(0xFF57636C),
          itemCount: 5,
          itemSize: 12,
        )
      ]));
}
