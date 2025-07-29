import 'package:TableReserver/models/web/venue_page_model.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImagesTab extends StatelessWidget {
  final _model = VenuePageModel();

  ImagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Material(
          color: Theme.of(context).colorScheme.onSurface,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildButtons(context),
                  _buildPageView(context),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(48, 16, 48, 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildButton(context, 'Add Venue Images', _model.addVenueImages),
          _buildButton(context, 'Add Menu Images', _model.addMenuImages),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    Function() onPressed,
  ) {
    return FFButtonWidget(
      onPressed: onPressed,
      text: label,
      options: FFButtonOptions(
        width: 198,
        height: 50,
        color: WebTheme.successColor,
        textStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFFFFFBF4),
        ),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Expanded _buildPageView(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            PageView(
              controller: _model.pageViewController,
              scrollDirection: Axis.horizontal,
              children: [
                _buildVenueImages(
                  context,
                  'Venue Images',
                  _model.venueImages,
                ),
                _buildMenuImages(context),
              ],
            ),
            _buildPageIndicator(context),
          ],
        ),
      ),
    );
  }

  Column _buildMenuImages(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildTitle(context, 'Menu Images'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Material(
                color: Colors.transparent,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 300,
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 8)),
                    ),
                  ),
                ),
              ),
            ],
          ).animateOnPageLoad(
              _model.animationsMap['textOnPageLoadAnimation5']!),
        ),
      ],
    );
  }

  Column _buildVenueImages(
    BuildContext context,
    String label,
    List<String> images,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(context, label),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children:
            // images.map((imageUrl) {
            //       return Material(
            //         color: Theme.of(context).colorScheme.onSurface,
            //         elevation: 3,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.all(8),
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(8),
            //             child: Image.network(
            //               'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
            //               width: double.infinity,
            //               height: 200,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //       );
            //     })
            //     .toList(),
            [
              Material(
                color: Theme.of(context).colorScheme.onSurface,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ].divide(const SizedBox(height: 8)),
          ).animateOnPageLoad(
              _model.animationsMap['textOnPageLoadAnimation5']!),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, -1),
      child: SmoothPageIndicator(
        controller: _model.pageViewController,
        count: 2,
        axisDirection: Axis.horizontal,
        onDotClicked: (i) async {
          await _model.pageViewController.animateToPage(
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
}
