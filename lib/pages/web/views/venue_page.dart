import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/common/full_image_view.dart';
import 'package:table_reserver/components/mobile/custom_appbar.dart';
import 'package:table_reserver/components/web/images_tab.dart';
import 'package:table_reserver/components/web/modals/edit_venue_modal.dart';
import 'package:table_reserver/components/web/reviews_tab.dart';
import 'package:table_reserver/components/web/venue_details_tab.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/models/web/views/venue_page_model.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/utils.dart';

class WebVenuePage extends StatefulWidget {
  final int venueId;
  final bool shouldReturnToHomepage;
  final bool shouldOpenReviewsTab;
  final bool shouldOpenImagesTab;

  const WebVenuePage({
    super.key,
    required this.venueId,
    required this.shouldReturnToHomepage,
    this.shouldOpenReviewsTab = false,
    this.shouldOpenImagesTab = false,
  });

  @override
  State<WebVenuePage> createState() => _WebVenuePageState();
}

class _WebVenuePageState extends State<WebVenuePage>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  final int ownerId = prefsWithCache.getInt('ownerId')!;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VenuePageModel(
        venueId: widget.venueId,
        shouldOpenReviewsTab: widget.shouldOpenReviewsTab,
        shouldOpenImagesTab: widget.shouldOpenImagesTab,
      )..init(context, this),
      child: Consumer<VenuePageModel>(
        builder: (context, model, _) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: CustomAppbar(
                title: model.loadedVenue.name,
                onBack: () {
                  widget.shouldReturnToHomepage
                      ? Navigator.of(context).push(
                          FadeInRoute(
                            page: WebHomepage(ownerId: ownerId),
                            routeName: Routes.webHomepage,
                          ),
                        )
                      : Navigator.of(context).pop();
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
                      _buildHeader(context, model),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height,
                          child: Column(
                            children: [
                              _buildTabBar(context, model),
                              const SizedBox(height: 16),
                              Expanded(
                                child: TabBarView(
                                  controller: model.tabBarController,
                                  children: [
                                    VenueDetailsTab(model: model),
                                    ReviewsTab(model: model),
                                    ImagesTab(model: model),
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
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, VenuePageModel model) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderImage(
            context,
            model,
          ).animateOnPageLoad(model.animationsMap['headerImageOnLoad']!),
          const SizedBox(height: 16),
          _buildHeaderRow(
            context,
            model,
          ).animateOnPageLoad(model.animationsMap['fadeInOnLoad']!),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context, VenuePageModel model) {
    return InkWell(
      onTap: () {
        if (model.headerImage == null) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenImageView(
              imageBytes: model.headerImage!,
              heroTag: 'headerImageTag',
            ),
          ),
        );
      },
      child: model.headerImage != null
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: fallbackImageGradient(),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Image.memory(
                model.headerImage!,
                width: double.infinity,
                height: 320,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(
                gradient: fallbackImageGradient(),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                model.loadedVenue.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: WebTheme.offWhite),
              ),
            ),
    );
  }

  Widget _buildHeaderRow(BuildContext context, VenuePageModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            model.loadedVenue.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          FFButtonWidget(
            onPressed: () async {
              bool? shouldRefresh = await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
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
              if (shouldRefresh == true) {
                if (!context.mounted) return;
                model.fetchVenue(context);
              }
            },
            text: 'Edit Venue Details',
            icon: const Icon(Icons.edit_outlined, size: 24),
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

  Widget _buildTabBar(BuildContext context, VenuePageModel model) {
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
        controller: model.tabBarController,
        onTap: (i) async {
          [() async {}, () async {}, () async {}][i]();
        },
      ),
    );
  }
}
