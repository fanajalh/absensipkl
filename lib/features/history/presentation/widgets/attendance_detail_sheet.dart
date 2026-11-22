import 'package:flutter/material.dart';

import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../attendance/domain/entities/attendance_record.dart';

/// Pure UI bottom sheet displaying detailed telemetry for an attendance record.
class AttendanceDetailSheet extends StatelessWidget {
  const AttendanceDetailSheet({
    super.key,
    required this.record,
  });

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg + bottomInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Detail Presensi',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              record.date.toIndonesianFullDate(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _DetailFieldRow(label: 'Status', value: record.status.label),
            _DetailFieldRow(
              label: 'Check-In',
              value: record.checkInTime != null
                  ? '${record.checkInTime!.toTimeHms()} WIB'
                  : '-',
            ),
            _DetailFieldRow(
              label: 'Check-Out',
              value: record.checkOutTime != null
                  ? '${record.checkOutTime!.toTimeHms()} WIB'
                  : '-',
            ),
            _DetailFieldRow(
              label: 'Jarak Check-In',
              value: record.checkInDistanceMeters != null
                  ? '${record.checkInDistanceMeters!.round()} m'
                  : '-',
            ),
            _DetailFieldRow(
              label: 'Jarak Check-Out',
              value: record.checkOutDistanceMeters != null
                  ? '${record.checkOutDistanceMeters!.round()} m'
                  : '-',
            ),
            _DetailFieldRow(
              label: 'Integritas GPS',
              value: record.isMockLocationFlagged
                  ? 'Terindikasi Mock GPS'
                  : 'Terverifikasi Asli',
              valueColor: record.isMockLocationFlagged
                  ? AppColors.rose
                  : AppColors.emerald,
            ),
            if (record.selfieLabel != null)
              _DetailFieldRow(label: 'Bukti Selfie', value: record.selfieLabel!),
            if (record.notes != null && record.notes!.trim().isNotEmpty)
              _DetailFieldRow(label: 'Catatan', value: record.notes!),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailFieldRow extends StatelessWidget {
  const _DetailFieldRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 124,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
