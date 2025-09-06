import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:table_reserver/components/mobile/custom_appbar.dart';
import 'package:table_reserver/components/mobile/modal_widgets.dart';
import 'package:table_reserver/models/mobile/views/ratings_model.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/toaster.dart';

class RatingsPage extends StatelessWidget {
  final int venueId;
  final int? userId;
  final Position? userLocation;
  final RatingsPageModel? modelOverride;

  const RatingsPage({
    super.key,
    required this.venueId,
    this.userId,
    this.userLocation,
    this.modelOverride,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => modelOverride ?? RatingsPageModel(venueId: venueId)
        ..init(context),
      child: Consumer<RatingsPageModel>(
        builder: (context, model, _) {
          bool isAtBottom = false;

          while (model.ratings == null) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: MobileTheme.accent1,
                size: 75,
              ),
            );
          }

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: model.scaffoldKey,
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: CustomAppbar(onBack: () => Navigator.of(context).pop()),
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildContainer(context, model),
                    Expanded(
                      child: Stack(
                        alignment: const AlignmentDirectional(-1, -1),
                        children: [
                          NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification.metrics.pixels >=
                                  notification.metrics.maxScrollExtent - 20) {
                                if (!isAtBottom) {
                                  isAtBottom = true;
                                }
                              } else {
                                if (isAtBottom) {
                                  isAtBottom = false;
                                }
                              }
                              return true;
                            },
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 80),
                              child: Column(
                                children: [
                                  _buildRatingSummary(context, model),
                                  ..._buildRatings(context, model),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: isAtBottom ? 72 : 16,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _buildLeaveReviewButton(context, model),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingSummary(BuildContext context, RatingsPageModel model) {
    int fiveStars =
        model.ratings?.where((element) => element.rating == 5.0).length ?? 0;
    int fourStars =
        model.ratings?.where((element) => element.rating == 4.0).length ?? 0;
    int threeStars =
        model.ratings?.where((element) => element.rating == 3.0).length ?? 0;
    int twoStars =
        model.ratings?.where((element) => element.rating == 2.0).length ?? 0;
    int oneStar =
        model.ratings?.where((element) => element.rating == 1.0).length ?? 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Theme.of(context).colorScheme.outline,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: RatingSummary(
          key: const Key('ratingSummary'),
          counter: model.ratings?.length ?? 0,
          showAverage: false,
          counterFiveStars: fiveStars,
          counterFourStars: fourStars,
          counterThreeStars: threeStars,
          counterTwoStars: twoStars,
          counterOneStars: oneStar,
          color: MobileTheme.accent1,
          labelCounterOneStars: Text(
            '1',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          labelCounterTwoStars: Text(
            '2',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          labelCounterThreeStars: Text(
            '3',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          labelCounterFourStars: Text(
            '4',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          labelCounterFiveStars: Text(
            '5',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRatings(BuildContext context, RatingsPageModel model) {
    return model.ratings!.map((rating) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          key: const Key('ratingEntryContainer'),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Theme.of(context).colorScheme.outline,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.venue.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: RatingBarIndicator(
                              itemBuilder: (context, index) => const Icon(
                                Icons.star_rounded,
                                color: MobileTheme.accent1,
                              ),
                              direction: Axis.horizontal,
                              rating: rating.rating.roundToDouble(),
                              unratedColor: const Color(
                                0xFF57636C,
                              ).withValues(alpha: 0.5),
                              itemCount: 5,
                              itemSize: 24,
                            ),
                          ),
                        ],
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            rating.username,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (rating.comment.isNotEmpty == true)
                  const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      rating.comment,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLeaveReviewButton(BuildContext context, RatingsPageModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: FFButtonWidget(
        key: const Key('leaveReviewButton'),
        onPressed: () => _buildRatingModal(context, model),
        text: 'Rate this venue',
        showLoadingIndicator: false,
        options: FFButtonOptions(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsetsDirectional.all(0),
          color: MobileTheme.successColor,
          splashColor: Theme.of(context).colorScheme.surfaceDim,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<dynamic>? _buildRatingModal(
    BuildContext context,
    RatingsPageModel model,
  ) {
    double rating = 0;

    if (userId == null) {
      Toaster.displayError(
        context,
        'Please log in to rate ${model.venue.name}',
      );
      return null;
    }

    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Material(
              color: Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Center(
                    child: Container(
                      key: const Key('ratingModal'),
                      height: 216,
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 64,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: RatingBar.builder(
                                onRatingUpdate: (newRating) {
                                  setModalState(() {
                                    rating = newRating;
                                  });
                                },
                                itemBuilder: (context, index) => Icon(
                                  key: Key('ratingStar_$index'),
                                  CupertinoIcons.star_fill,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onTertiary,
                                ),
                                unratedColor: const Color(
                                  0xFF57636C,
                                ).withValues(alpha: 0.5),
                                direction: Axis.horizontal,
                                glow: false,
                                ignoreGestures: false,
                                initialRating: rating,
                                itemSize: 32,
                                allowHalfRating: false,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: _buildCommentTextField(context, model),
                          ),
                          const SizedBox(height: 16),
                          _buildButtons(context, model, rating),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtons(
    BuildContext context,
    RatingsPageModel model,
    double rating,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildModalButton('cancelModalButton', 'Cancel', () {
          Navigator.of(context).pop();
        }, Theme.of(context).colorScheme.onPrimary),
        buildModalButton('rateModalButton', 'Rate', () {
          if (rating == 0) {
            Toaster.displayError(
              context,
              'Please select a rating before submitting.',
            );
            return;
          }

          model.rateVenue(
            context,
            userId!,
            rating,
            model.commentTextController.text,
          );
          Navigator.of(context).pop();
        }, MobileTheme.successColor),
      ],
    );
  }

  Widget _buildCommentTextField(BuildContext context, RatingsPageModel model) {
    return TextFormField(
      key: const Key('commentField'),
      controller: model.commentTextController,
      focusNode: model.commentFocusNode,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Leave a review',
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MobileTheme.infoColor, width: .5),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.all(24),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildContainer(BuildContext context, RatingsPageModel model) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          top: 16,
          right: 12,
          bottom: 24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  key: const Key('numberOfRatingsText'),
                  '${model.ratings?.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 14),
                Text(
                  '# of Ratings',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      key: const Key('averageRatingText'),
                      model.venue.rating.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Icon(
                        key: Key('averageRatingIcon'),
                        CupertinoIcons.star_fill,
                        color: MobileTheme.accent1,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('Avg. Rating', style: TextStyle()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
