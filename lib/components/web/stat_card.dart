import 'package:TableReserver/themes/web_theme.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          height: 120,
          constraints: const BoxConstraints(
            maxWidth: 270,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildIcon(),
                _buildStat(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return const Padding(
      padding: EdgeInsets.only(right: 16),
      child: Icon(
        Icons.trending_up_rounded,
        color: WebTheme.accent1,
        size: 36,
      ),
    );
  }

  Widget _buildStat(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                  child: Text(
                    '$value',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 32),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
