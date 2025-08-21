import 'dart:typed_data';

import 'package:table_reserver/components/common/full_image_view.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class VenueImagesTab extends StatelessWidget {
  final List<Uint8List>? venueImages;
  final List<Uint8List>? menuImages;

  const VenueImagesTab({
    Key? key,
    required this.venueImages,
    required this.menuImages,
  }) : super(key: key);

  double calculateTabHeight(List<Uint8List>? images) {
    if (images == null || images.isEmpty) {
      return 196;
    }
    final int rows = (images.skip(1).length / 2).ceil();

    final double imageGridHeight = rows * 170 + (rows - 1) * 12;

    const double outerPadding = 12 + 96;

    return imageGridHeight + outerPadding;
  }

  @override
  Widget build(BuildContext context) {
    double venueTabHeight = calculateTabHeight(venueImages);
    double menuTabHeight = calculateTabHeight(menuImages);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: MobileTheme.accent1,
            indicatorColor: MobileTheme.accent1,
            labelStyle: Theme.of(context).textTheme.titleMedium,
            unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
            unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: const [
              Tab(text: 'Venue Images'),
              Tab(text: 'Menu Images'),
            ],
          ),
          SizedBox(
            height:
                venueTabHeight > menuTabHeight ? venueTabHeight : menuTabHeight,
            child: TabBarView(
              children: [
                _buildMasonryGrid(context, venueImages, 'venue'),
                _buildMasonryGrid(context, menuImages, 'menu'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasonryGrid(
    BuildContext context,
    List<Uint8List>? images,
    String tagPrefix,
  ) {
    if (images == null || images.isEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'No images available',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    final imageList = images.skip(1).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 96),
      child: MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        crossAxisSpacing: 24,
        mainAxisSpacing: 12,
        itemCount: imageList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final imageBytes = imageList[index];
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FullScreenImageView(
                  imageBytes: imageBytes,
                  heroTag: '$tagPrefix-$index',
                ),
              ),
            ),
            child: Hero(
              tag: '$tagPrefix-$index',
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  imageBytes,
                  width: 160,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
