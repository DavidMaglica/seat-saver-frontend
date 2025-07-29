import 'package:TableReserver/components/mobile/custom_appbar.dart';
import 'package:TableReserver/components/web/images_tab.dart';
import 'package:TableReserver/components/web/modals/edit_venue_modal.dart';
import 'package:TableReserver/components/web/reviews_tab.dart';
import 'package:TableReserver/components/web/venue_details_tab.dart';
import 'package:TableReserver/models/web/venue_page_model.dart';
import 'package:TableReserver/themes/web_theme.dart';
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
      initialIndex: 2,
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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
            width: double.infinity,
            height: 350,
            fit: BoxFit.fitWidth,
          ).animateOnPageLoad(
            _model.animationsMap['imageOnPageLoadAnimation']!,
          ),
          const SizedBox(height: 16),
          Padding(
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
                  showLoadingIndicator: false,
                  options: FFButtonOptions(
                    height: 40,
                    color: WebTheme.infoColor,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFFBF4),
                    ),
                    elevation: 3,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
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
        labelColor: WebTheme.successColor,
        unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
        labelPadding: const EdgeInsets.only(top: 16),
        labelStyle: Theme.of(context).textTheme.titleLarge,
        unselectedLabelStyle: Theme.of(context).textTheme.titleMedium,
        indicatorColor: WebTheme.successColor,
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
