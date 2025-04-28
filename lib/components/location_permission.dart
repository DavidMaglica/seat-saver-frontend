import 'package:TableReserver/models/location_permission_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';

import '../themes/theme.dart';
import '../utils/constants.dart';

class LocationPermissionPopUp extends StatelessWidget {
  final String userEmail;

  const LocationPermissionPopUp({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationPermissionPopUpModel>(
      create: (_) => LocationPermissionPopUpModel(userEmail, context)..init(),
      builder: (context, _) {
        final model = Provider.of<LocationPermissionPopUpModel>(context);

        return Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                  alignment: AlignmentDirectional(0, -1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                    child: Icon(CupertinoIcons.location_solid,
                        color: AppThemes.accent1, size: 64),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 12),
                    child: Text(
                      'Our app works best with location enabled',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 96),
                    child: Text(
                        'Find your favourite spots! Activate location services to easily locate venues near you!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: FFButtonWidget(
                      onPressed: () => model.getCurrentPosition(),
                      text: 'Enable location',
                      options: FFButtonOptions(
                        width: 270,
                        height: 40,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Theme.of(context).colorScheme.primary,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 16,
                        ),
                        elevation: 3,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed(
                        Routes.HOMEPAGE,
                        arguments: {
                          'userEmail': userEmail,
                          'userLocation': null
                        },
                      );
                    },
                    text: 'No, thanks',
                    options: FFButtonOptions(
                      width: 270,
                      height: 40,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: Theme.of(context).colorScheme.background,
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
