import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_error.dart';
import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/camera_datasource.dart';
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

bool get _isWidgetTestBinding =>
    WidgetsBinding.instance.runtimeType.toString().contains('Test');

/// Real live Camera Selfie screen with Front/Rear switch, LED Torch +
/// Front Selfie Screen Fill-Flash, and ZERO dashed oval borders.
class AttendanceSelfieScreen extends ConsumerStatefulWidget {
  const AttendanceSelfieScreen({super.key});

  @override
  ConsumerState<AttendanceSelfieScreen> createState() =>
      _AttendanceSelfieScreenState();
}

class _AttendanceSelfieScreenState
    extends ConsumerState<AttendanceSelfieScreen> {
  bool _flashEnabled = false;
  bool _screenFlashBurst = false;
  bool _isCapturing = false;
  bool _useFrontCamera = true;
  String? _localError;

  List<CameraDescription> _cameras = const <CameraDescription>[];
  CameraController? _cameraController;
  bool _cameraInitialized = false;
  Uint8List? _capturedBytes;

  @override
  void initState() {
    super.initState();
    if (!_isWidgetTestBinding) {
      unawaited(_initializeLiveCamera());
    }
  }

  @override
  void dispose() {
    unawaited(_cameraController?.dispose());
    super.dispose();
  }

  Future<void> _initializeLiveCamera() async {
    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }
      if (!mounted || _cameras.isEmpty) return;

      final targetDirection = _useFrontCamera
          ? CameraLensDirection.front
          : CameraLensDirection.back;
      final selected = _cameras.firstWhere(
        (c) => c.lensDirection == targetDirection,
        orElse: () => _cameras.first,
      );

      final prev = _cameraController;
      _cameraController = null;
      if (mounted) {
        setState(() => _cameraInitialized = false);
      }
      await prev?.dispose();

      final controller = CameraController(
        selected,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      _cameraController = controller;
      await _applyHardwareFlashMode();
      if (mounted) {
        setState(() {
          _cameraInitialized = true;
          _localError = null;
        });
      }
    } catch (_) {
      // Fallback gracefully if webcam/camera is not attached or permission denied
      if (mounted) {
        setState(() => _cameraInitialized = false);
      }
    }
  }

  Future<void> _applyHardwareFlashMode() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;
    if (kIsWeb) return;
    try {
      final lens = controller.description.lensDirection;
      if (lens == CameraLensDirection.back) {
        await controller.setFlashMode(
          _flashEnabled ? FlashMode.torch : FlashMode.off,
        );
      } else {
        await controller.setFlashMode(FlashMode.off);
      }
    } catch (_) {
      // Front cameras or devices without LED torch use Screen Fill-Flash instead
    }
  }

  Future<void> _toggleFlash() async {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _flashEnabled = !_flashEnabled);
    await _applyHardwareFlashMode();
  }

  Future<void> _switchCameraLens() async {
    if (_isCapturing) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _useFrontCamera = !_useFrontCamera;
      _capturedBytes = null;
    });
    if (!_isWidgetTestBinding) {
      await _initializeLiveCamera();
    }
  }

  Future<void> _captureAndSubmit() async {
    if (_isCapturing) return;
    setState(() {
      _isCapturing = true;
      _localError = null;
    });

    final notifier = ref.read(attendanceProvider.notifier);

    // 1. Validate geofence first
    final evaluation = await notifier.validateGeofenceForSelfie();
    if (!mounted) return;
    if (evaluation == null) {
      final err = ref.read(attendanceProvider).asData?.value.actionError;
      setState(() {
        _isCapturing = false;
        _localError = err?.userMessage ?? 'Lokasi berada di luar radius DUDI.';
      });
      return;
    }

    // 2. If live CameraController is active, capture directly with Screen/LED Flash!
    final controller = _cameraController;
    if (!_isWidgetTestBinding &&
        controller != null &&
        controller.value.isInitialized) {
      try {
        if (_flashEnabled && _useFrontCamera) {
          setState(() => _screenFlashBurst = true);
          await Future<void>.delayed(const Duration(milliseconds: 140));
        }

        final xfile = await controller.takePicture();
        final bytes = await xfile.readAsBytes();

        if (mounted && _screenFlashBurst) {
          setState(() => _screenFlashBurst = false);
        }

        if (!mounted) return;
        setState(() => _capturedBytes = bytes);

        final now = DateTime.now();
        final selfie = CapturedSelfie(
          bytes: bytes,
          fileName: 'selfie_${now.millisecondsSinceEpoch}.jpg',
          mimeType: 'image/jpeg',
          capturedAt: now,
        );

        final success = await notifier.submitAttendance(
          selfie: selfie,
          geofence: evaluation,
        );
        if (!mounted) return;
        if (success) {
          if (_flashEnabled && !_useFrontCamera) {
            try {
              await controller.setFlashMode(FlashMode.off);
            } catch (_) {}
          }
          unawaited(HapticFeedback.mediumImpact());
          const PresensiRoute().go(context);
          return;
        }

        final err = ref.read(attendanceProvider).asData?.value.actionError;
        setState(() {
          _isCapturing = false;
          _localError = err?.userMessage ?? 'Gagal menyimpan presensi.';
        });
        return;
      } catch (_) {
        if (mounted) {
          setState(() => _screenFlashBurst = false);
        }
        // Fallback to CameraDatasource below if direct capture fails
      }
    }

    // 3. Fallback / Widget-test deterministic capture via CameraDatasource
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
    final controller = _cameraController;
    final showFrontFillLight = _flashEnabled && _useFrontCamera;

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor:
            showFrontFillLight ? const Color(0xFFF8FAFC) : AppColors.cameraCanvas,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SafeArea(
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
                              onDarkCamera: !showFrontFillLight,
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
                                style: TextStyle(
                                  color: showFrontFillLight
                                      ? AppColors.lightCharcoal
                                      : Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            BouncyTap(
                              onTap: _toggleFlash,
                              child: Container(
                                height: 36,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _flashEnabled
                                      ? AppColors.cameraYellow
                                      : Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _flashEnabled
                                        ? AppColors.cameraYellow
                                        : Colors.white.withValues(alpha: 0.18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      _flashEnabled
                                          ? Icons.flash_on_rounded
                                          : Icons.flash_off_rounded,
                                      size: 16,
                                      color: _flashEnabled
                                          ? AppColors.lightCharcoal
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _flashEnabled ? 'On' : 'Off',
                                      style: TextStyle(
                                        color: _flashEnabled
                                            ? AppColors.lightCharcoal
                                            : Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: EdgeInsets.all(showFrontFillLight ? 10 : 0),
                            decoration: BoxDecoration(
                              color: showFrontFillLight
                                  ? Colors.white
                                  : AppColors.cameraSurface,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusXl),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                showFrontFillLight
                                    ? AppSpacing.radiusLg
                                    : AppSpacing.radiusXl,
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  if (_capturedBytes != null)
                                    Image.memory(
                                      _capturedBytes!,
                                      fit: BoxFit.cover,
                                    )
                                  else if (_cameraInitialized &&
                                      controller != null &&
                                      controller.value.isInitialized)
                                    FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width: controller.value.previewSize
                                                ?.height ??
                                            480,
                                        height: controller.value.previewSize
                                                ?.width ??
                                            640,
                                        child: CameraPreview(controller),
                                      ),
                                    )
                                  else
                                    ColoredBox(
                                      color: AppColors.cameraSurface,
                                      child: Center(
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
                                              : Colors.black
                                                  .withValues(alpha: 0.65),
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          _localError ??
                                              (_flashEnabled
                                                  ? (_useFrontCamera
                                                      ? 'Flash Layar Aktif · Wajah jelas'
                                                      : 'Flash LED Aktif · Wajah jelas')
                                                  : 'Wajah terlihat jelas'),
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
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md + 2,
                            vertical: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd + 2,
                            ),
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
                                    : () => const AttendanceMapRoute()
                                        .push<void>(context),
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
                            BouncyTap(
                              onTap: _toggleFlash,
                              child: SizedBox(
                                width: 82,
                                child: Text(
                                  _flashEnabled ? 'Flash On' : 'Kamera',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: showFrontFillLight
                                        ? AppColors.lightCharcoal
                                        : (_flashEnabled
                                            ? AppColors.cameraYellow
                                            : Colors.white60),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
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
                                    color: showFrontFillLight
                                        ? AppColors.lightCharcoal
                                        : Colors.white,
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
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.expand(),
                                ),
                              ),
                            ),
                            BouncyTap(
                              onTap: _switchCameraLens,
                              child: Container(
                                width: 82,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: showFrontFillLight
                                      ? Colors.black.withValues(alpha: 0.08)
                                      : Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.cameraswitch_rounded,
                                      size: 14,
                                      color: showFrontFillLight
                                          ? AppColors.lightCharcoal
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        _useFrontCamera ? 'Depan' : 'Blkng',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: showFrontFillLight
                                              ? AppColors.lightCharcoal
                                              : Colors.white,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
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
            if (_screenFlashBurst)
              const Positioned.fill(
                child: IgnorePointer(
                  child: ColoredBox(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelfieClockOverlay extends ConsumerWidget {
  const _SelfieClockOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(liveClockProvider);
    return _CameraOverlayPill(
      text: '${now.toTimeHms()} WIB',
      backgroundColor: Colors.black.withValues(alpha: 0.65),
    );
  }
}

class _CameraOverlayPill extends StatelessWidget {
  const _CameraOverlayPill({
    required this.text,
    required this.backgroundColor,
    this.showPulse = false,
  });

  final String text;
  final Color backgroundColor;
  final bool showPulse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showPulse) ...<Widget>[
            const LivePulseDot(color: Colors.white, size: 6),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
