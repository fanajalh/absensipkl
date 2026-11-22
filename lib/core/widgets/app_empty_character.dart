import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_spacing.dart';
import 'motion_widgets.dart';

/// Clean character illustration placeholder whenever a list, preview, or section is empty.
class AppEmptyCharacter extends StatelessWidget {
  const AppEmptyCharacter({
    super.key,
    required this.message,
    this.assetPath = 'assets/illustrations/undraw_onboarding.svg',
    this.imageHeight = 96,
    this.onDark = false,
  });

  final String message;
  final String assetPath;
  final double imageHeight;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GentleFloat(
            amplitude: 3.0,
            child: SizedBox(
              height: imageHeight,
              child: SvgPicture.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: onDark ? Colors.white70 : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
