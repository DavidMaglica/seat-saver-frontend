import 'package:TableReserver/components/common/full_image_view.dart';
import 'package:TableReserver/components/mobile/custom_appbar.dart';
import 'package:TableReserver/components/web/images_tab.dart';
import 'package:TableReserver/components/web/modals/edit_venue_modal.dart';
import 'package:TableReserver/components/web/reviews_tab.dart';
import 'package:TableReserver/components/web/venue_details_tab.dart';
import 'package:TableReserver/models/web/venue_page_model.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:TableReserver/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class WebVenuePage extends StatefulWidget {
  final int venueId;

  const WebVenuePage({
    super.key,
    required this.venueId,
  });

  @override
  State<WebVenuePage> createState() => _WebVenuePageState();
}

class _WebVenuePageState extends State<WebVenuePage>
    with TickerProviderStateMixin {
  late VenuePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VenuePageModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppbar(
          title: '${widget.venueId}',
          onBack: () {
            Navigator.of(context).pop();
          },
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: 1920,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeader(context),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: Column(
                      children: [
                        _buildTabBar(context),
                        const SizedBox(height: 16),
                        Expanded(
                          child: TabBarView(
                            controller: _model.tabBarController,
                            children: [
                              VenueDetailsTab(),
                              ReviewsTab(),
                              ImagesTab()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    bool hasImage =
        _model.headerImage != null && _model.headerImage!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderImage(hasImage, context),
          const SizedBox(height: 16),
          _buildHeaderRow(context),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(bool hasImage, BuildContext context) {
    return InkWell(
      mouseCursor: hasImage ? MouseCursor.uncontrolled : MouseCursor.defer,
      onTap: () {
        if (!hasImage) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenImageView(
              imageBytes: _model.headerImage!,
              heroTag: 'headerImageTag',
            ),
          ),
        );
      },
      child: hasImage
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: fallbackImageGradient(),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Image.memory(
                _model.headerImage!,
                width: double.infinity,
                height: 320,
                fit: BoxFit.cover,
              ))
          : Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(
                gradient: fallbackImageGradient(),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                _model.loadedVenue.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
            ).animateOnPageLoad(
              _model.animationsMap['imageOnPageLoadAnimation']!,
            ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _model.loadedVenue.name,
            style: Theme.of(context).textTheme.titleLarge,
          ).animateOnPageLoad(
            _model.animationsMap['textOnPageLoadAnimation1']!,
          ),
          FFButtonWidget(
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    backgroundColor: Colors.transparent,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: EditVenueModal(venueId: widget.venueId),
                      ),
                    ),
                  );
                },
              );
            },
            text: 'Edit Venue Details',
            icon: const Icon(
              Icons.edit_outlined,
              size: 24,
            ),
            options: FFButtonOptions(
              height: 40,
              color: WebTheme.infoColor,
              textStyle: const TextStyle(
                fontSize: 16,
                color: WebTheme.offWhite,
              ),
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0),
      child: TabBar(
        labelColor: WebTheme.accent1,
        unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
        labelPadding: const EdgeInsets.only(top: 16),
        labelStyle: Theme.of(context).textTheme.titleLarge,
        unselectedLabelStyle: Theme.of(context).textTheme.titleMedium,
        indicatorColor: WebTheme.accent1,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Tab(text: 'Venue Details'),
          Tab(text: 'Reviews'),
          Tab(text: 'Images'),
        ],
        controller: _model.tabBarController,
        onTap: (i) async {
          [() async {}, () async {}, () async {}][i]();
        },
      ),
    );
  }
}
