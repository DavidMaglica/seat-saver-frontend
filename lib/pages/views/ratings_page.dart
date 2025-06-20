import 'package:TableReserver/components/custom_appbar.dart';
import 'package:TableReserver/components/modal_widgets.dart';
import 'package:TableReserver/components/toaster.dart';
import 'package:TableReserver/models/ratings_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rating_summary/rating_summary.dart';

class RatingsPage extends StatelessWidget {
  final int venueId;
  final int? userId;
  final Position? userLocation;

  const RatingsPage({
    Key? key,
    required this.venueId,
    this.userId,
    this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RatingsPageModel(ctx: context, venueId: venueId)..init(),
      child: Consumer<RatingsPageModel>(
        builder: (context, model, _) {
          bool isAtBottom = false;

          while (model.ratings == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: model.scaffoldKey,
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: CustomAppbar(
                title: model.venue.name,
                onBack: () => Navigator.of(context).pop({
                  'userId': userId,
                  'userLocation': userLocation,
                }),
              ),
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildContainer(context, model),
                    Expanded(
                      child: Stack(
                        alignment: const AlignmentDirectional(-1,-1),
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

  Widget _buildRatingSummary(BuildContext ctx, RatingsPageModel model) {
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
        color: Theme.of(ctx).colorScheme.background,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Theme.of(ctx).colorScheme.outline,
            offset: const Offset(0, 5),
          )
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: RatingSummary(
          counter: model.ratings?.length ?? 0,
          showAverage: false,
          counterFiveStars: fiveStars,
          counterFourStars: fourStars,
          counterThreeStars: threeStars,
          counterTwoStars: twoStars,
          counterOneStars: oneStar,
          color: AppThemes.accent1,
          labelCounterOneStars:
              Text('1', style: Theme.of(ctx).textTheme.bodyMedium),
          labelCounterTwoStars:
              Text('2', style: Theme.of(ctx).textTheme.bodyMedium),
          labelCounterThreeStars:
              Text('3', style: Theme.of(ctx).textTheme.bodyMedium),
          labelCounterFourStars:
              Text('4', style: Theme.of(ctx).textTheme.bodyMedium),
          labelCounterFiveStars:
              Text('5', style: Theme.of(ctx).textTheme.bodyMedium),
        ),
      ),
    );
  }

  List<Widget> _buildRatings(BuildContext ctx, RatingsPageModel model) {
    return model.ratings!.map((rating) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.background,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Theme.of(ctx).colorScheme.outline,
                offset: const Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.venue.name,
                            style: Theme.of(ctx).textTheme.titleMedium,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: RatingBarIndicator(
                              itemBuilder: (context, index) => const Icon(
                                Icons.star_rounded,
                                color: AppThemes.accent1,
                              ),
                              direction: Axis.horizontal,
                              rating: rating.rating.roundToDouble(),
                              unratedColor:
                                  const Color(0xFF57636C).withOpacity(0.5),
                              itemCount: 5,
                              itemSize: 24,
                            ),
                          ),
                        ],
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Theme.of(ctx).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            rating.username,
                            style: Theme.of(ctx).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (rating.comment.isNotEmpty == true)
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        rating.comment,
                        style: Theme.of(ctx).textTheme.bodyMedium,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLeaveReviewButton(BuildContext ctx, RatingsPageModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 0),
      child: FFButtonWidget(
        onPressed: () => _buildRatingModal(ctx, model),
        text: 'Rate this venue',
        showLoadingIndicator: false,
        options: FFButtonOptions(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsetsDirectional.all(0),
          color: AppThemes.infoColor,
          splashColor: Theme.of(ctx).colorScheme.surfaceVariant,
          textStyle: TextStyle(
            color: Theme.of(ctx).colorScheme.background,
            fontSize: 16,
          ),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<dynamic>? _buildRatingModal(BuildContext ctx, RatingsPageModel model) {
    double rating = 0;

    if (userId == null) {
      Toaster.displayError(ctx, 'Please log in to rate ${model.venue.name}');
      return null;
    }

    return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Material(
              color: Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  ),
                  child: Center(
                    child: Container(
                      height: 216,
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
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
                                  CupertinoIcons.star_fill,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                ),
                                unratedColor:
                                    const Color(0xFF57636C).withOpacity(0.5),
                                direction: Axis.horizontal,
                                glow: false,
                                ignoreGestures: false,
                                initialRating: rating,
                                itemSize: 32,
                                allowHalfRating: false,
                              ),
                            ),
                          ),
                          // _buildAnimatedText(context, rating),
                          // rating != 0
                          //     ? const SizedBox(height: 29)
                          //     : const SizedBox(height: 48),
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
        buildModalButton(
          'Cancel',
          () {
            Navigator.of(context).pop();
          },
          Theme.of(context).colorScheme.onPrimary,
        ),
        buildModalButton(
          'Rate',
          () {
            if (rating == 0) {
              Toaster.displayError(
                context,
                'Please select a rating before submitting.',
              );
              return;
            }

            model.rateVenue(
              userId!,
              rating,
              model.commentTextController.text,
            );
            Navigator.of(context).pop();
          },
          AppThemes.successColor,
        ),
      ],
    );
  }

  Widget _buildCommentTextField(BuildContext context, RatingsPageModel model) {
    return TextFormField(
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
          borderSide: const BorderSide(
            color: AppThemes.infoColor,
            width: .5,
          ),
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
        contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 24),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildContainer(BuildContext ctx, RatingsPageModel model) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(ctx).colorScheme.background,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 12, top: 16, right: 12, bottom: 24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${model.ratings?.length}',
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                const SizedBox(height: 14),
                Text(
                  '# of Ratings',
                  style: Theme.of(ctx).textTheme.bodyMedium,
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
                      model.venue.rating.toStringAsFixed(2),
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Icon(
                        CupertinoIcons.star_fill,
                        color: AppThemes.accent1,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Avg. Rating',
                  style: TextStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
