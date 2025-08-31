import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/models/mobile/components/location_permission_model.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class LocationPermissionPopUp extends StatelessWidget {
  final int userId;

  const LocationPermissionPopUp({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationPermissionPopUpModel>(
      create: (_) => LocationPermissionPopUpModel(context, userId)..init(),
      builder: (context, _) {
        final model = Provider.of<LocationPermissionPopUpModel>(context);

        return Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(),
                _buildTitle(context),
                _buildSubTitle(context),
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: _buildEnableButton(context, model),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                  child: _buildDenyButton(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubTitle(BuildContext ctx) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 96),
        child: Text(
          'Find your favourite spots! Activate location services to easily locate venues near you!',
          textAlign: TextAlign.center,
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext ctx) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 12),
        child: Text(
          'Our app works best with location enabled',
          textAlign: TextAlign.center,
          style: Theme.of(ctx).textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return const Align(
      alignment: AlignmentDirectional(0, -1),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
        child: Icon(
          CupertinoIcons.location_solid,
          color: MobileTheme.accent1,
          size: 64,
        ),
      ),
    );
  }

  Widget _buildDenyButton(BuildContext ctx) {
    return FFButtonWidget(
      onPressed: () {
        Navigator.of(ctx).push(
          MobileFadeInRoute(page: const Homepage(), routeName: Routes.homepage),
        );
      },
      text: 'No, thanks',
      options: FFButtonOptions(
        width: 270,
        height: 40,
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        color: Theme.of(ctx).colorScheme.onSurface,
        textStyle: TextStyle(
          color: Theme.of(ctx).colorScheme.onPrimary,
          fontSize: 16,
        ),
        elevation: 3,
        borderSide: BorderSide(
          color: Theme.of(ctx).colorScheme.onPrimary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildEnableButton(
    BuildContext ctx,
    LocationPermissionPopUpModel model,
  ) {
    return FFButtonWidget(
      onPressed: () => model.getCurrentPosition(),
      text: 'Enable location',
      options: FFButtonOptions(
        width: 270,
        height: 40,
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        color: Theme.of(ctx).colorScheme.primary,
        textStyle: TextStyle(
          color: Theme.of(ctx).colorScheme.onSurface,
          fontSize: 16,
        ),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
