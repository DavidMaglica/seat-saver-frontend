import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/web/side_nav.dart';
import 'package:table_reserver/components/web/venue_card.dart';
import 'package:table_reserver/models/web/views/venues_model.dart';
import 'package:table_reserver/themes/web_theme.dart';

class WebVenuesPage extends StatefulWidget {
  const WebVenuesPage({super.key});

  @override
  State<WebVenuesPage> createState() => _WebVenuesPageState();
}

class _WebVenuesPageState extends State<WebVenuesPage>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VenuesModel()..loadData(),
      child: Consumer<VenuesModel>(
        builder: (context, model, _) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: SafeArea(
                top: true,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SideNav(),
                    _buildPaginatedVenues(
                      context,
                      model,
                    ).animateOnPageLoad(model.animationsMap['gridOnLoad']!),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaginatedVenues(BuildContext context, VenuesModel model) {
    if (model.paginatedVenues.isEmpty) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No venues available',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        controller: model.scrollController,
        padding: const EdgeInsets.all(32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: model.paginatedVenues.length + (model.hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == model.paginatedVenues.length && model.hasMorePages) {
            return Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: WebTheme.accent1,
                size: 75,
              ),
            );
          }

          final venue = model.paginatedVenues[index];
          return WebVenueCard(venue: venue);
        },
      ),
    );
  }
}
