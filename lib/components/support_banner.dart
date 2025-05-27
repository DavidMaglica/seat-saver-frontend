import 'package:flutter/material.dart';

import '../themes/theme.dart';

class SupportBanner extends StatelessWidget {
  final BuildContext context;
  final String title;
  final IconData icon;

  const SupportBanner({
    super.key,
    required this.context,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: Container(
            width: 120,
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimary,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: AppThemes.accent1,
                    size: 36,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
}
