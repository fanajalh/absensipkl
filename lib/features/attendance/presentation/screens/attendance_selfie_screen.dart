import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_error.dart';
import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_header_buttons.dart';
import '../../../../core/widgets/motion_widgets.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../notifiers/attendance_notifier.dart';
import '../notifiers/attendance_state.dart';
import '../notifiers/live_clock_notifier.dart';

/// Concise dark Camera Selfie screen with ZERO dashed oval borders.
class AttendanceSelfieScreen extends ConsumerStatefulWidget {
  const AttendanceSelfieScreen({super.key});

  @override
  ConsumerState<AttendanceSelfieScreen> createState() =>
      _AttendanceSelfieScreenState();
}

class _AttendanceSelfieScreenState
    extends ConsumerState<AttendanceSelfieScreen> {
  bool _flashEnabled = false;
  bool _isCapturing = false;
  String? _localError;

  Future<void> _captureAndSubmit() async {
    if (_isCapturing) return;
    setState(() {
      _isCapturing = true;
      _localError = null;
    });

    final notifier = ref.read(attendanceProvider.notifier);
    final prepared = await notifier.prepareAttendanceSelfie();
    if (!mounted) return;

    if (prepared == null) {
      final err = ref.read(attendanceProvider).asData?.value.actionError;
      setState(() {
        _isCapturing = false;
        _localError = err?.userMessage ?? 'Pengambilan foto dibatalkan.';
      });
      return;
    }

    final success = await notifier.submitAttendance(
      selfie: prepared.selfie,
      geofence: prepared.geofence,
    );
    if (!mounted) return;

    if (success) {
      unawaited(HapticFeedback.mediumImpact());
      const PresensiRoute().go(context);
      return;
    }

    final err = ref.read(attendanceProvider).asData?.value.actionError;
    setState(() {
      _isCapturing = false;
      _localError = err?.userMessage ?? 'Gagal menyimpan presensi.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authPlacement = switch (authState) {
      AuthAuthenticated(:final session) => session.student.placement,
      _ => null,
    };

    final dashboard =
        ref.watch(attendanceProvider).asData?.value ??
            const AttendanceDashboardState();
    final placement = dashboard.placement ?? authPlacement;
    final isCheckOut = dashboard.todayRecord?.hasCheckedIn ?? false;
    final geofence = dashboard.geofence;
    final isMocked = geofence?.isMocked ?? false;
    final isValid = geofence?.canSubmitAttendance ?? false;

    final statusPillLabel = isMocked
        ? 'Mock GPS'
        : isValid
            ? 'GPS Asli'
            : 'Di Luar';
    final statusPillColor =
        (isMocked || !isValid) ? AppColors.rose : AppColors.lightPrimary;
    final radiusSummary = geofence != null
        ? '${geofence.distanceMeters.round()} m / ${geofence.allowedRadiusMeters.round()} m'
        : 'Memeriksa lokasi';

    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: AppColors.cameraCanvas,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.lg + bottomInset,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AppHeaderActionButton(
                          key: AppWidgetKeys.selfieCancelButton,
                          label: 'Batal',
                          icon: Icons.close_rounded,
                          onDarkCamera: true,
                          trailingPadding: false,
                          onPressed:
                              _isCapturing ? null : () => context.pop(),
                        ),
                        Expanded(
                          child: Text(
                            isCheckOut ? 'Selfie Pulang' : 'Selfie',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Flash',
                          constraints: const BoxConstraints(
                            minWidth: AppSpacing.minTouchTarget,
                            minHeight: AppSpacing.minTouchTarget,
                          ),
                          onPressed: () {
                            setState(() => _flashEnabled = !_flashEnabled);
                          },
                          icon: Icon(
                            _flashEnabled
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            color: AppColors.cameraYellow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.cameraSurface,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusXl),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFCBD5E1),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: SvgPicture.asset(
                                    'assets/illustrations/avatar_rafi.svg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              left: AppSpacing.md,
                              top: AppSpacing.md,
                              child: _SelfieClockOverlay(),
                            ),
                            Positioned(
                              right: AppSpacing.md,
                              top: AppSpacing.md,
                              child: _CameraOverlayPill(
                                text: statusPillLabel,
                                backgroundColor: statusPillColor,
                                showPulse: isValid && !isMocked,
                              ),
                            ),
                            Positioned(
                              left: AppSpacing.lg,
                              right: AppSpacing.lg,
                              bottom: AppSpacing.md,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md + 2,
                                    vertical: AppSpacing.xs + 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _localError != null
                                        ? AppColors.rose
                                        : Colors.black.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    _localError ?? 'Wajah terlihat jelas',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md + 2,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd + 2),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.lightSurfaceSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.lightPrimary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  placement?.companyName ??
                                      'PT Fanajalh Digital',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.lightTextPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  radiusSummary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: (isMocked || !isValid)
                                        ? AppColors.rose
                                        : AppColors.lightPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const <FontFeature>[
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _isCapturing
                                ? null
                                : () =>
                                    const AttendanceMapRoute().push<void>(context),
                            child: const Text(
                              'Peta',
                              style: TextStyle(
                                color: AppColors.lightTextMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const SizedBox(
                          width: 72,
                          child: Text(
                            'Kamera',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          key: AppWidgetKeys.selfieShutterButton,
                          behavior: HitTestBehavior.opaque,
                          onTap: _isCapturing ? null : _captureAndSubmit,
                          child: Container(
                            width: 72,
                            height: 72,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3.5,
                              ),
                            ),
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                color: AppColors.lightPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: _isCapturing
                                  ? const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          strokeWidth: 2.4,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 72,
                          child: Text(
                            'Depan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraOverlayPill extends StatelessWidget {
  const _CameraOverlayPill({
    required this.text,
    this.backgroundColor,
    this.showPulse = false,
  });

  final String text;
  final Color? backgroundColor;
  final bool showPulse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showPulse) ...<Widget>[
            const LivePulseDot(color: Colors.white, size: 6),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelfieClockOverlay extends ConsumerWidget {
  const _SelfieClockOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(liveClockProvider);
    return _CameraOverlayPill(text: '${now.toTimeHms()} WIB');
  }
}
