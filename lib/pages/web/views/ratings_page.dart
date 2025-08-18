import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/mobile/custom_appbar.dart';
import 'package:table_reserver/models/web/ratings_page_model.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class WebRatingsPage extends StatelessWidget {
  final int ownerId;

  const WebRatingsPage({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WebRatingsPageModel(ownerId: ownerId)..init(),
      child: Consumer<WebRatingsPageModel>(
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppbar(
              title: 'Venue Ratings',
              onBack: () {
                Navigator.of(context).push(
                  FadeInRoute(
                    page: WebHomepage(ownerId: ownerId),
                    routeName: Routes.webHomepage,
                  ),
                );
              },
            ),
            body: SafeArea(
              top: true,
              child: Container(
                width: 1920,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: SingleChildScrollView(
                  child: Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(context, model),
                            const SizedBox(height: 32),
                            _buildMasonryGrid(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context, WebRatingsPageModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Overview', style: Theme.of(context).textTheme.titleLarge),
          FFButtonWidget(
            onPressed: () {
              model.fetchData(ownerId);
            },
            text: 'Refresh data',
            icon: const Icon(CupertinoIcons.refresh, size: 18),
            options: FFButtonOptions(
              height: 40,
              iconColor: Theme.of(context).colorScheme.primary,
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
      ).animateOnPageLoad(model.animationsMap['titleOnPageLoadAnimation']!),
    );
  }

  Widget _buildMasonryGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 96),
      child: MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        crossAxisSpacing: 24,
        mainAxisSpacing: 12,
        itemCount: 50,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Material(
              color: Colors.transparent,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('MMMDA')),
              ),
            ),
          );
        },
      ),
    );
  }
}
