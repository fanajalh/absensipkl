import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// Pure UI subtle footer note indicating automatic Device ID binding.
class DemoCredentialCard extends StatelessWidget {
  const DemoCredentialCard({
    super.key,
    required this.caption,
  });

  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Text(
        caption,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
