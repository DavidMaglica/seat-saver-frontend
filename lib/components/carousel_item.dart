import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/carousel_item_model.dart';
import '../themes/theme.dart';
import 'toaster.dart';

class CarouselItem extends StatelessWidget {
  final String currentCity;

  const CarouselItem(this.currentCity, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CarouselItemModel>(
      create: (_) => CarouselItemModel(currentCity),
      builder: (context, child) {
        final model = context.watch<CarouselItemModel>();

        return Container(
          height: 256,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 0.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                blurRadius: 6,
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
                if (model.imageLink != null)
                  _buildImage(model.imageLink!)
                else
                  const SizedBox(height: 128),
                _buildText(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(String imagePath) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: 128,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildText(BuildContext ctx) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Align(
              alignment: const AlignmentDirectional(-1, 0),
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Text(currentCity,
                      style: const TextStyle(
                        color: AppThemes.accent1,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )))),
          Align(
              alignment: const AlignmentDirectional(-1, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Text('Discover new restaurants in $currentCity!',
                    style: Theme.of(ctx).textTheme.bodyMedium),
              ))
        ]));
  }
}
