import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/web/side_nav.dart';
import 'package:table_reserver/components/web/venue_card.dart';
import 'package:table_reserver/models/web/venues_model.dart';
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
                    _buildPaginatedVenues(context, model),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Expanded _buildPaginatedVenues(BuildContext context, VenuesModel model) {
    if (model.paginatedVenues.isEmpty) {
      return const Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No venues available'),
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
            return const Center(
              child: CircularProgressIndicator(color: WebTheme.successColor),
            );
          }

          final venue = model.paginatedVenues[index];
          return WebVenueCard(venue: venue);
        },
      ).animateOnPageLoad(model.animationsMap['gridViewOnPageLoadAnimation']!),
    );
  }
}
