import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_reserver/utils/toaster.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/utils.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  final String currentCity;
  final String? imageUri;

  const CarouselItem(this.currentCity, this.imageUri, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline,
            blurRadius: 2,
            spreadRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          Toaster.displayInfo(
              context, 'Searching by location currently unavailable');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (imageUri != null)
              _buildImage(context, imageUri)
            else
              const SizedBox(height: 128),
            _buildText(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext ctx, String? imageUri) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: imageUri != null
          ? Image.network(
              imageUri,
              width: double.infinity,
              height: 128,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: MobileTheme.accent1,
                    size: 75,
                  ),
                );
              },
            )
          : _buildFallbackImage(ctx),
    );
  }

  Widget _buildText(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: Text(
                currentCity,
                style: const TextStyle(
                  color: MobileTheme.accent1,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: Text('Discover new restaurants in $currentCity!',
                  style: Theme.of(ctx).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage(BuildContext ctx) {
    return Container(
      width: double.infinity,
      height: 128,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: fallbackImageGradientReverted(),
      ),
      child: Text(
        currentCity.toUpperCase(),
        style: Theme.of(ctx).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
