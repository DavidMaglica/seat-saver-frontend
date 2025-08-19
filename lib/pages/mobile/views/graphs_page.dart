import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/mobile/custom_appbar.dart';
import 'package:table_reserver/models/web/views/graphs_page_model.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/logger.dart';
import 'package:table_reserver/utils/routes.dart';

class GraphsPage extends StatelessWidget {
  final int ownerId;

  const GraphsPage({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GraphsPageModel(),
      child: Consumer<GraphsPageModel>(
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppbar(
              title: 'Graphs',
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
                            _buildHeaderRow(context, model),
                            const SizedBox(height: 16),
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

  Widget _buildHeaderRow(BuildContext context, GraphsPageModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildToggleContainer(context, model),
          const SizedBox(width: 24),
          FFButtonWidget(
            onPressed: () {
              logger.i('Refreshing data...');
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

  Material _buildToggleContainer(BuildContext context, GraphsPageModel model) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption(
              context,
              model,
              label: "Daily",
              icon: Icons.calendar_today,
              selected: !model.isMonthly,
              onTap: () {
                model.toggleGraphType(false);
              },
            ),
            _buildOption(
              context,
              model,
              label: "Monthly",
              icon: Icons.calendar_month,
              selected: model.isMonthly,
              onTap: () {
                model.toggleGraphType(true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    GraphsPageModel model, {
    required String label,
    required IconData icon,
    required bool selected,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: AnimatedContainer(
        height: 40,
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? WebTheme.accent1
              : Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? WebTheme.offWhite
                  : Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: selected
                    ? WebTheme.offWhite
                    : Theme.of(context).colorScheme.onPrimary,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
