import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/leave_approval_status.dart';

/// Polished semantic pill with micro status icon for leave approval state.
class LeaveStatusPill extends StatelessWidget {
  const LeaveStatusPill({
    super.key,
    required this.status,
  });

  final LeaveApprovalStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final (IconData icon, Color accent, Color bg) = switch (status) {
      LeaveApprovalStatus.approved => (
          Icons.check_circle_rounded,
          isDark ? const Color(0xFF34D399) : AppColors.emerald,
          isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoftLight,
        ),
      LeaveApprovalStatus.submitted => (
          Icons.schedule_rounded,
          isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
          isDark ? AppColors.amberSoftDark : AppColors.amberSoftLight,
        ),
      LeaveApprovalStatus.rejected => (
          Icons.cancel_rounded,
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
            status.label,
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
