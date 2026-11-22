import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/attendance/presentation/notifiers/live_clock_notifier.dart';
import '../errors/app_error.dart';
import '../extensions/date_time_ext.dart';
import '../services/camera_datasource.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_empty_character.dart';
import 'app_header_buttons.dart';
import 'motion_widgets.dart';

/// Custom-styled standalone camera & file attachment widget for Jurnal & Izin/Sakit
/// with full-screen camera, real image preview, edit, replace, and delete.
class AppMediaAttachmentField extends ConsumerStatefulWidget {
  const AppMediaAttachmentField({
    super.key,
    required this.title,
    this.subtitle = 'Opsional',
    required this.attachment,
    required this.onChanged,
    this.onError,
    this.enabled = true,
    this.isLeaveDocument = false,
    this.cameraButtonKey,
    this.galleryButtonKey,
  });

  final String title;
  final String subtitle;
  final CapturedSelfie? attachment;
  final ValueChanged<CapturedSelfie?> onChanged;
  final ValueChanged<String>? onError;
  final bool enabled;
  final bool isLeaveDocument;
  final Key? cameraButtonKey;
  final Key? galleryButtonKey;

  @override
  ConsumerState<AppMediaAttachmentField> createState() =>
      _AppMediaAttachmentFieldState();
}

class _AppMediaAttachmentFieldState
    extends ConsumerState<AppMediaAttachmentField> {
  bool _isBusy = false;

  Future<void> _handlePickFromGallery() async {
    if (!widget.enabled || _isBusy) return;
    FocusScope.of(context).unfocus();
    setState(() => _isBusy = true);
    try {
      final captured = await ref
          .read(cameraDatasourceProvider)
          .captureJournalPhoto(fromGallery: true);
      if (!mounted || captured == null) return;
      unawaited(HapticFeedback.lightImpact());
      widget.onChanged(captured);
    } catch (error) {
      if (!mounted) return;
      widget.onError?.call(AppErrorMapper.fromObject(error).userMessage);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _handleOpenCamera() async {
    if (!widget.enabled || _isBusy) return;
    FocusScope.of(context).unfocus();

    // Open full-screen camera identical in layout to AttendanceSelfieScreen
    final result = await Navigator.of(context).push<CapturedSelfie>(
      MaterialPageRoute<CapturedSelfie>(
        fullscreenDialog: true,
        builder: (_) => _FullScreenAttachmentCameraScreen(
          title: widget.title,
        ),
      ),
    );
    if (!mounted || result == null) return;
    unawaited(HapticFeedback.mediumImpact());
    widget.onChanged(result);
  }

  Future<void> _handleOpenReplaceSheet() async {
    if (!widget.enabled || _isBusy) return;
    FocusScope.of(context).unfocus();
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        final theme = Theme.of(sheetCtx);
        final cs = theme.colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Ganti Foto',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _SourceOptionTile(
                        icon: Icons.camera_alt_rounded,
                        label: 'Kamera',
                        isPrimary: true,
                        onTap: () => Navigator.of(sheetCtx).pop('camera'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SourceOptionTile(
                        icon: Icons.photo_library_rounded,
                        label: 'Galeri',
                        isPrimary: false,
                        onTap: () => Navigator.of(sheetCtx).pop('gallery'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || choice == null) return;
    if (choice == 'camera') {
      await _handleOpenCamera();
    } else if (choice == 'gallery') {
      await _handlePickFromGallery();
    }
  }

  Future<void> _handleOpenEditor() async {
    final current = widget.attachment;
    if (current == null || !widget.enabled) return;

    final edited = await showModalBottomSheet<CapturedSelfie>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PhotoAttachmentEditSheet(attachment: current),
    );
    if (!mounted || edited == null) return;
    unawaited(HapticFeedback.lightImpact());
    widget.onChanged(edited);
  }

  void _handlePreview() {
    final current = widget.attachment;
    if (current == null) return;
    showAttachmentPreviewDialog(
      context,
      title: widget.title,
      fileName: current.fileName,
      bytes: current.bytes,
      sourceUrl: current.storageValue,
    );
  }

  void _handleDelete() {
    if (!widget.enabled) return;
    unawaited(HapticFeedback.selectionClick());
    widget.onChanged(null);
  }

  String _formatSize(int? bytesLen) {
    if (bytesLen == null || bytesLen <= 0) return '';
    final kb = bytesLen / 1024;
    if (kb < 1024) return ' • ${kb.toStringAsFixed(0)} KB';
    return ' • ${(kb / 1024).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final current = widget.attachment;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141923) : colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: current != null
              ? colorScheme.primary.withValues(alpha: 0.45)
              : colorScheme.outline,
          width: AppSpacing.hairlineBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                current != null
                    ? Icons.check_circle_rounded
                    : Icons.photo_camera_outlined,
                color: current != null
                    ? AppColors.emerald
                    : colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  current != null
                      ? '${current.fileName}${_formatSize(current.bytes?.length)}'
                      : widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (current == null) ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _SourceOptionTile(
                    key: widget.cameraButtonKey,
                    icon: Icons.camera_alt_outlined,
                    label: 'Kamera',
                    isPrimary: true,
                    onTap: widget.enabled ? _handleOpenCamera : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SourceOptionTile(
                    key: widget.galleryButtonKey,
                    icon: Icons.photo_library_outlined,
                    label: 'Galeri',
                    isPrimary: false,
                    onTap: widget.enabled ? _handlePickFromGallery : null,
                  ),
                ),
              ],
            ),
          ] else ...<Widget>[
            GestureDetector(
              onTap: _handlePreview,
              child: Container(
                height: 164,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0B0F17)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorScheme.outline,
                    width: AppSpacing.hairlineBorder,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _AttachmentImageView(
                  bytes: current.bytes,
                  sourceValue: current.storageValue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: _AttachmentActionButton(
                    icon: Icons.visibility_outlined,
                    label: 'Lihat',
                    onTap: _handlePreview,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _AttachmentActionButton(
                    icon: Icons.tune_rounded,
                    label: 'Edit',
                    onTap: widget.enabled ? _handleOpenEditor : null,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _AttachmentActionButton(
                    icon: Icons.swap_horiz_rounded,
                    label: 'Ganti',
                    onTap: widget.enabled ? _handleOpenReplaceSheet : null,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _AttachmentActionButton(
                    icon: Icons.delete_outline_rounded,
                    label: 'Hapus',
                    isDanger: true,
                    onTap: widget.enabled ? _handleDelete : null,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SourceOptionTile extends StatelessWidget {
  const _SourceOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BouncyTap(
      onTap: onTap,
      scaleDown: 0.96,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isPrimary
              ? colorScheme.primary
              : (isDark ? const Color(0xFF1C2331) : colorScheme.surface),
          borderRadius: BorderRadius.circular(10),
          border: isPrimary
              ? null
              : Border.all(
                  color: colorScheme.outline,
                  width: AppSpacing.hairlineBorder,
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 16,
              color: isPrimary ? Colors.white : colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isPrimary ? Colors.white : colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentActionButton extends StatelessWidget {
  const _AttachmentActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final fg = isDanger
        ? AppColors.rose
        : (isDark ? Colors.white : const Color(0xFF1E293B));
    final bg = isDanger
        ? (isDark ? AppColors.roseSoftDark : AppColors.roseSoftLight)
        : (isDark ? const Color(0xFF1E2636) : Colors.white);

    return Tooltip(
      message: label,
      child: BouncyTap(
        onTap: onTap,
        scaleDown: 0.95,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDanger
                  ? AppColors.rose.withValues(alpha: 0.35)
                  : colorScheme.outline,
              width: AppSpacing.hairlineBorder,
            ),
          ),
          child: Center(
            child: Icon(icon, size: 18, color: fg),
          ),
        ),
      ),
    );
  }
}

/// Renders an attachment image from real [Uint8List] bytes, `data:image/...` URI, or HTTP URL.
class _AttachmentImageView extends StatelessWidget {
  const _AttachmentImageView({
    required this.bytes,
    required this.sourceValue,
    this.fit = BoxFit.cover,
  });

  final Uint8List? bytes;
  final String? sourceValue;
  final BoxFit fit;

  Uint8List? _resolveBytes() {
    if (bytes != null && bytes!.isNotEmpty) return bytes;
    final raw = sourceValue?.trim() ?? '';
    if (raw.startsWith('data:image/')) {
      final commaIdx = raw.indexOf(',');
      if (commaIdx > 0) {
        try {
          return base64Decode(raw.substring(commaIdx + 1));
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final decoded = _resolveBytes();
    if (decoded != null) {
      return Image.memory(
        decoded,
        fit: fit,
        gaplessPlayback: true,
      );
    }

    final raw = sourceValue?.trim() ?? '';
    if (raw.startsWith('http://') ||
        raw.startsWith('https://') ||
        raw.startsWith('/assets/')) {
      return Image.network(
        raw,
        fit: fit,
        errorBuilder: (_, _, _) => _EmptyPhotoPlaceholder(label: raw),
      );
    }

    return _EmptyPhotoPlaceholder(label: raw);
  }
}

class _EmptyPhotoPlaceholder extends StatelessWidget {
  const _EmptyPhotoPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: AppEmptyCharacter(
        message: 'Belum ada foto',
        assetPath: 'assets/illustrations/undraw_jurnal.svg',
        imageHeight: 92,
        onDark: isDark,
      ),
    );
  }
}

/// Full-screen zoomable lightbox preview for an attachment.
Future<void> showAttachmentPreviewDialog(
  BuildContext context, {
  required String title,
  required String fileName,
  Uint8List? bytes,
  String? sourceUrl,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.88),
    builder: (dialogCtx) {
      return Dialog.fullscreen(
        backgroundColor: AppColors.cameraCanvas,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Row(
                  children: <Widget>[
                    AppHeaderActionButton(
                      label: 'Tutup',
                      icon: Icons.close_rounded,
                      onDarkCamera: true,
                      trailingPadding: false,
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: _AttachmentImageView(
                          bytes: bytes,
                          sourceValue: sourceUrl ?? fileName,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Full-Screen Camera identical in layout and aesthetics to [AttendanceSelfieScreen]
/// (`[✕ Batal]   Foto   [⚡ Off/On]`, full-screen viewport, bottom shutter + lens toggle).
class _FullScreenAttachmentCameraScreen extends ConsumerStatefulWidget {
  const _FullScreenAttachmentCameraScreen({
    required this.title,
  });

  final String title;

  @override
  ConsumerState<_FullScreenAttachmentCameraScreen> createState() =>
      _FullScreenAttachmentCameraScreenState();
}

class _FullScreenAttachmentCameraScreenState
    extends ConsumerState<_FullScreenAttachmentCameraScreen> {
  List<CameraDescription> _cameras = const <CameraDescription>[];
  CameraController? _controller;
  bool _cameraInitialized = false;
  bool _useFrontCamera = false;
  bool _flashEnabled = false;
  bool _screenFlashBurst = false;
  bool _isCapturing = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeLiveCamera());
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  Future<void> _initializeLiveCamera() async {
    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }
      if (!mounted || _cameras.isEmpty) return;

      final targetDir = _useFrontCamera
          ? CameraLensDirection.front
          : CameraLensDirection.back;
      final selected = _cameras.firstWhere(
        (c) => c.lensDirection == targetDir,
        orElse: () => _cameras.first,
      );
      _useFrontCamera = selected.lensDirection == CameraLensDirection.front;

      final prev = _controller;
      _controller = null;
      if (mounted) {
        setState(() => _cameraInitialized = false);
      }
      await prev?.dispose();

      final ctrl = CameraController(
        selected,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await ctrl.initialize();
      if (!mounted) {
        await ctrl.dispose();
        return;
      }

      _controller = ctrl;
      await _applyHardwareFlashMode();
      if (mounted) {
        setState(() {
          _cameraInitialized = true;
          _localError = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _cameraInitialized = false);
      }
    }
  }

  Future<void> _applyHardwareFlashMode() async {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized || kIsWeb) return;
    try {
      if (!_useFrontCamera) {
        await ctrl.setFlashMode(
          _flashEnabled ? FlashMode.torch : FlashMode.off,
        );
      } else {
        await ctrl.setFlashMode(FlashMode.off);
      }
    } catch (_) {}
  }

  Future<void> _toggleFlash() async {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _flashEnabled = !_flashEnabled);
    await _applyHardwareFlashMode();
  }

  Future<void> _switchCameraLens() async {
    if (_isCapturing) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _useFrontCamera = !_useFrontCamera);
    await _initializeLiveCamera();
  }

  Future<void> _pickFileFallback() async {
    if (_isCapturing) return;
    setState(() {
      _isCapturing = true;
      _localError = null;
    });
    try {
      final picked = await ref
          .read(cameraDatasourceProvider)
          .captureJournalPhoto(fromGallery: true);
      if (!mounted) return;
      if (picked != null) {
        Navigator.of(context).pop(picked);
        return;
      }
      setState(() => _isCapturing = false);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isCapturing = false;
        _localError = AppErrorMapper.fromObject(error).userMessage;
      });
    }
  }

  Future<void> _capturePhoto() async {
    if (_isCapturing) return;
    setState(() {
      _isCapturing = true;
      _localError = null;
    });
    unawaited(HapticFeedback.mediumImpact());

    final ctrl = _controller;
    if (_cameraInitialized && ctrl != null && ctrl.value.isInitialized) {
      try {
        if (_flashEnabled && _useFrontCamera) {
          setState(() => _screenFlashBurst = true);
          await Future<void>.delayed(const Duration(milliseconds: 140));
        }

        final xfile = await ctrl.takePicture();
        final bytes = await xfile.readAsBytes();

        if (mounted && _screenFlashBurst) {
          setState(() => _screenFlashBurst = false);
        }

        if (_flashEnabled && !_useFrontCamera) {
          try {
            await ctrl.setFlashMode(FlashMode.off);
          } catch (_) {}
        }

        if (!mounted) return;
        final now = DateTime.now();
        Navigator.of(context).pop(
          CapturedSelfie(
            bytes: bytes,
            fileName: xfile.name.trim().isNotEmpty
                ? xfile.name.trim()
                : 'foto_${now.millisecondsSinceEpoch}.jpg',
            mimeType: 'image/jpeg',
            capturedAt: now,
          ),
        );
        return;
      } catch (_) {
        if (mounted) {
          setState(() => _screenFlashBurst = false);
        }
      }
    }

    // Fallback to CameraDatasource (native camera or file picker)
    try {
      final captured = await ref
          .read(cameraDatasourceProvider)
          .captureJournalPhoto(fromGallery: false);
      if (!mounted) return;
      if (captured != null) {
        Navigator.of(context).pop(captured);
        return;
      }
      setState(() => _isCapturing = false);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isCapturing = false;
        _localError = AppErrorMapper.fromObject(error).userMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final ctrl = _controller;
    final showFrontFillLight = _flashEnabled && _useFrontCamera;
    final now = ref.watch(liveClockProvider);

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: showFrontFillLight
            ? const Color(0xFFF8FAFC)
            : AppColors.cameraCanvas,
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
                        // Top Navigation Row: [✕ Batal]   Foto   [⚡ Off/On]
                        Row(
                          children: <Widget>[
                            AppHeaderActionButton(
                              label: 'Batal',
                              icon: Icons.close_rounded,
                              onDarkCamera: !showFrontFillLight,
                              trailingPadding: false,
                              onPressed: _isCapturing
                                  ? null
                                  : () => Navigator.of(context).pop(),
                            ),
                            Expanded(
                              child: Text(
                                'Foto',
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
                        // Full-screen Camera Viewport identical to AttendanceSelfieScreen
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: EdgeInsets.all(showFrontFillLight ? 10 : 0),
                            decoration: BoxDecoration(
                              color: showFrontFillLight
                                  ? Colors.white
                                  : AppColors.cameraSurface,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusXl,
                              ),
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
                                  if (_cameraInitialized &&
                                      ctrl != null &&
                                      ctrl.value.isInitialized)
                                    FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width:
                                            ctrl.value.previewSize?.height ??
                                                480,
                                        height:
                                            ctrl.value.previewSize?.width ??
                                                640,
                                        child: CameraPreview(ctrl),
                                      ),
                                    )
                                  else
                                    ColoredBox(
                                      color: AppColors.cameraSurface,
                                      child: Center(
                                        child: AppEmptyCharacter(
                                          message: widget.title,
                                          assetPath:
                                              'assets/illustrations/undraw_checkin.svg',
                                          imageHeight: 112,
                                          onDark: true,
                                        ),
                                      ),
                                    ),
                                  // Top-left live clock
                                  Positioned(
                                    left: AppSpacing.md,
                                    top: AppSpacing.md,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.xs + 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.65,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${now.toTimeHms()} WIB',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Top-right camera lens badge
                                  Positioned(
                                    right: AppSpacing.md,
                                    top: AppSpacing.md,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.xs + 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightPrimary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        _useFrontCamera ? 'Depan' : 'Belakang',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_localError != null)
                                    Positioned(
                                      left: AppSpacing.lg,
                                      right: AppSpacing.lg,
                                      bottom: AppSpacing.md,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.md,
                                            vertical: AppSpacing.xs + 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.rose,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            _localError!,
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
                        const SizedBox(height: AppSpacing.lg),
                        // Bottom Controls Row: [Galeri]   ( Shutter )   [Depan/Blkng]
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            BouncyTap(
                              onTap: _pickFileFallback,
                              child: Container(
                                width: 82,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
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
                                      Icons.photo_library_outlined,
                                      size: 14,
                                      color: showFrontFillLight
                                          ? AppColors.lightCharcoal
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Galeri',
                                      style: TextStyle(
                                        color: showFrontFillLight
                                            ? AppColors.lightCharcoal
                                            : Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _isCapturing ? null : _capturePhoto,
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
                                  vertical: 8,
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

/// In-app Photo Editor Sheet: Rotate, Flip Horizontal, Filter Preset, and File Name.
class _PhotoAttachmentEditSheet extends StatefulWidget {
  const _PhotoAttachmentEditSheet({required this.attachment});

  final CapturedSelfie attachment;

  @override
  State<_PhotoAttachmentEditSheet> createState() =>
      _PhotoAttachmentEditSheetState();
}

class _PhotoAttachmentEditSheetState extends State<_PhotoAttachmentEditSheet> {
  late final TextEditingController _nameController;
  int _quarterTurns = 0;
  bool _flipHorizontal = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.attachment.fileName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _applyAndSave() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final sourceBytes = widget.attachment.bytes;
      Uint8List? outputBytes = sourceBytes;

      if (sourceBytes != null &&
          sourceBytes.isNotEmpty &&
          (_quarterTurns != 0 || _flipHorizontal)) {
        outputBytes = await _bakeImageTransforms(
          sourceBytes: sourceBytes,
          quarterTurns: _quarterTurns,
          flipHorizontal: _flipHorizontal,
        );
      }

      final cleanName = _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : widget.attachment.fileName;

      if (!mounted) return;
      Navigator.of(context).pop(
        widget.attachment.copyWith(
          bytes: outputBytes,
          fileName: cleanName,
          mimeType: 'image/png',
          capturedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop(
        widget.attachment.copyWith(
          fileName: _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : widget.attachment.fileName,
        ),
      );
    }
  }

  Future<Uint8List> _bakeImageTransforms({
    required Uint8List sourceBytes,
    required int quarterTurns,
    required bool flipHorizontal,
  }) async {
    final codec = await ui.instantiateImageCodec(sourceBytes);
    final frame = await codec.getNextFrame();
    final srcImg = frame.image;

    final isRotatedOdd = quarterTurns % 2 == 1;
    final outW = (isRotatedOdd ? srcImg.height : srcImg.width).toDouble();
    final outH = (isRotatedOdd ? srcImg.width : srcImg.height).toDouble();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, outW, outH));

    canvas.translate(outW / 2, outH / 2);
    canvas.rotate(quarterTurns * (math.pi / 2));
    if (flipHorizontal) {
      canvas.scale(-1.0, 1.0);
    }

    final paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImage(
      srcImg,
      Offset(-srcImg.width / 2, -srcImg.height / 2),
      paint,
    );

    final picture = recorder.endRecording();
    final rendered = await picture.toImage(outW.toInt(), outH.toInt());
    final byteData = await rendered.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget previewChild = _AttachmentImageView(
      bytes: widget.attachment.bytes,
      sourceValue: widget.attachment.fileName,
      fit: BoxFit.contain,
    );

    if (_flipHorizontal) {
      previewChild = Transform.flip(
        flipX: true,
        child: previewChild,
      );
    }
    previewChild = RotatedBox(
      quarterTurns: _quarterTurns,
      child: previewChild,
    );

    return Container(
      margin: const EdgeInsets.all(12),
      padding: EdgeInsets.fromLTRB(
        18,
        14,
        18,
        18 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Edit Foto',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Center(child: previewChild),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: Tooltip(
                    message: 'Putar Kiri',
                    child: OutlinedButton(
                      onPressed: () => setState(
                        () => _quarterTurns = (_quarterTurns - 1) & 3,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Icon(Icons.rotate_left_rounded, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Tooltip(
                    message: 'Putar Kanan',
                    child: OutlinedButton(
                      onPressed: () => setState(
                        () => _quarterTurns = (_quarterTurns + 1) & 3,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Icon(Icons.rotate_right_rounded, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Tooltip(
                    message: 'Mirror',
                    child: OutlinedButton(
                      onPressed: () => setState(
                        () => _flipHorizontal = !_flipHorizontal,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Icon(Icons.flip_rounded, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama File',
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _saving ? null : _applyAndSave,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_rounded, size: 18),
              label: Text(_saving ? 'Menyimpan' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
