import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../themes/theme.dart';

export 'models/location_card_model.dart';

class LocationCard extends StatefulWidget {
  const LocationCard({super.key});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          _onTap();
        },
        child: Container(
          width: 128,
          height: 128,
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
                        _buildName(context),
                        _buildLocation(),
                        _buildRatingBar(),
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

  Widget _buildLocation() => const Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Text('Firenze',
            style: TextStyle(
              color: AppThemes.accent1,
              fontWeight: FontWeight.w900,
              fontSize: 8,
            )),
      ]));

  Widget _buildName(BuildContext context) => Text('Giardino Bardini',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 10,
      ));

  Widget _buildImage() => Hero(
      tag: 'locationCardImage${randomDouble(0, 100)}',
      transitionOnUserGestures: true,
      child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: Image.network(
            'https://images.unsplash.com/photo-1528114039593-4366cc08227d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8aXRhbHl8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
            width: 128,
            height: 72,
            fit: BoxFit.cover,
          )));

  void _onTap() => Navigator.pushNamed(context, '/objectLocation', arguments: {
        'name': 'Mele Melinda',
        'location': '123 Main St',
        'workingHours': '8:00 AM - 10:00 PM',
        'rating': 4.5,
        'type': 'Restaurant',
        'description': 'A lovely place to eat.',
      });

  Widget _buildRatingBar() => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        RatingBarIndicator(
          itemBuilder: (context, index) => const Icon(
            CupertinoIcons.star_fill,
            color: AppThemes.warningColor,
          ),
          direction: Axis.horizontal,
          rating: 4,
          unratedColor: const Color(0xFF57636C),
          itemCount: 5,
          itemSize: 10,
        )
      ]));
}
