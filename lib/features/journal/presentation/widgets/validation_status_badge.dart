import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/journal_validation_status.dart';

/// Polished Orisale v4 semantic status pill with crisp micro icon.
class ValidationStatusBadge extends StatelessWidget {
  const ValidationStatusBadge({
    super.key,
    required this.status,
  });

  final JournalValidationStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final (String label, IconData icon, Color accent, Color bg) =
        switch (status) {
      JournalValidationStatus.pending => (
          'Menunggu',
          Icons.schedule_rounded,
          isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
          isDark ? AppColors.amberSoftDark : AppColors.amberSoftLight,
        ),
      JournalValidationStatus.approved => (
          'Disetujui',
          Icons.check_circle_rounded,
          isDark ? const Color(0xFF34D399) : AppColors.emerald,
          isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoftLight,
        ),
      JournalValidationStatus.revision => (
          'Revisi',
          Icons.edit_rounded,
          isDark ? const Color(0xFFF87171) : AppColors.rose,
          isDark ? AppColors.roseSoftDark : AppColors.roseSoftLight,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
