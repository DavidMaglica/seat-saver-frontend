import 'package:flutter/material.dart';
import 'package:table_reserver/themes/web_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          height: 96,
          constraints: const BoxConstraints(maxWidth: 316),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [_buildIcon(), _buildStat(context)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return const Padding(
      padding: EdgeInsets.only(right: 16),
      child: Icon(Icons.trending_up_rounded, color: WebTheme.accent1, size: 36),
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 14),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 4),
              Text(
                '$value',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
