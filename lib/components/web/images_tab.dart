import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seat_saver/components/common/full_image_view.dart';
import 'package:seat_saver/models/web/views/venue_page_model.dart';
import 'package:seat_saver/themes/web_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImagesTab extends StatelessWidget {
  final VenuePageModel model;

  const ImagesTab({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Material(
        color: Theme.of(context).colorScheme.onSurface,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildButtons(context),
                _buildPageView(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildButton(
            context,
            const Key('addVenueImagesButton'),
            'Add Venue Images',
            () => model.addVenueImage(context),
          ),
          _buildButton(
            context,
            const Key('addMenuImagesButton'),
            'Add Menu Images',
            () => model.addMenuImages(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(BuildContext context, VenuePageModel model) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            PageView(
              key: const Key('pageView'),
              controller: model.pageViewController,
              scrollDirection: Axis.horizontal,
              children: [
                _buildImages(
                  context,
                  'Venue Images',
                  model.venueImages,
                  model.isVenueImagesLoading,
                ),
                _buildImages(
                  context,
                  'Menu Images',
                  model.menuImages,
                  model.isMenuImagesLoading,
                ),
              ],
            ),
            _buildPageIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImages(
    BuildContext context,
    String label,
    List<Uint8List> images,
    bool isLoading,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(context, label),
        Expanded(
          child: images.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: images.map((imageBytes) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageView(
                                imageBytes: imageBytes,
                                heroTag:
                                    'imageTag_${images.indexOf(imageBytes)}',
                              ),
                            ),
                          );
                        },
                        child: Material(
                          color: Theme.of(context).colorScheme.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                imageBytes,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ).animateOnPageLoad(model.animationsMap['fadeInOnLoad']!),
                )
              : isLoading
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64),
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: WebTheme.accent1,
                      size: 75,
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(
                      'No images uploaded yet.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(label, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, -1),
      child: SmoothPageIndicator(
        key: const Key('pageIndicator'),
        controller: model.pageViewController,
        count: 2,
        axisDirection: Axis.horizontal,
        onDotClicked: (i) async {
          await model.pageViewController.animateToPage(
            i,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        effect: SlideEffect(
          spacing: 8,
          radius: 8,
          dotWidth: 64,
          dotHeight: 8,
          dotColor: Theme.of(context).colorScheme.onPrimary,
          activeDotColor: WebTheme.accent1,
          paintStyle: PaintingStyle.stroke,
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    Key key,
    String label,
    Function() onPressed,
  ) {
    return FFButtonWidget(
      key: key,
      onPressed: onPressed,
      text: label,
      options: FFButtonOptions(
        width: 198,
        height: 50,
        color: WebTheme.successColor,
        textStyle: const TextStyle(fontSize: 16, color: WebTheme.offWhite),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
      ),
      showLoadingIndicator: false,
    );
  }
}
