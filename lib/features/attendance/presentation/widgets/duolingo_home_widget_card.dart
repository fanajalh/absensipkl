import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/motion_widgets.dart';

enum DuolingoWidgetMode {
  morningReminder,
  streakActive,
  eveningCheckout,
}

/// Duolingo-style 3D tactile streak & Android Home Screen Widget card.
class DuolingoHomeWidgetCard extends StatefulWidget {
  const DuolingoHomeWidgetCard({
    super.key,
    required this.streakDays,
    required this.hasCheckedIn,
    required this.hasCheckedOut,
    required this.companyName,
    required this.distanceLabel,
    required this.onPrimaryAction,
    required this.onJournalAction,
  });

  final int streakDays;
  final bool hasCheckedIn;
  final bool hasCheckedOut;
  final String companyName;
  final String distanceLabel;
  final VoidCallback onPrimaryAction;
  final VoidCallback onJournalAction;

  @override
  State<DuolingoHomeWidgetCard> createState() => _DuolingoHomeWidgetCardState();
}

class _DuolingoHomeWidgetCardState extends State<DuolingoHomeWidgetCard> {
  static const MethodChannel _channel =
      MethodChannel('id.fanajalh.absensi_pkl/updater');

  DuolingoWidgetMode? _overrideMode;

  DuolingoWidgetMode get _effectiveMode {
    if (_overrideMode != null) return _overrideMode!;
    if (!widget.hasCheckedIn) return DuolingoWidgetMode.morningReminder;
    if (!widget.hasCheckedOut && DateTime.now().hour >= 15) {
      return DuolingoWidgetMode.eveningCheckout;
    }
    return DuolingoWidgetMode.streakActive;
  }

  @override
  void initState() {
    super.initState();
    unawaited(_syncNativeAndroidWidget());
  }

  @override
  void didUpdateWidget(covariant DuolingoHomeWidgetCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streakDays != widget.streakDays ||
        oldWidget.hasCheckedIn != widget.hasCheckedIn ||
        oldWidget.hasCheckedOut != widget.hasCheckedOut) {
      unawaited(_syncNativeAndroidWidget());
    }
  }

  Future<void> _syncNativeAndroidWidget() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final streakCount = widget.streakDays <= 0 ? 15 : widget.streakDays;
      await _channel.invokeMethod<void>(
        'updateHomeWidget',
        <String, dynamic>{
          'streak': '🔥 $streakCount Hari Streak',
          'badge': '📍 ${widget.distanceLabel}',
          'title': widget.hasCheckedIn
              ? 'Streak Absen Aman!'
              : 'Waktunya Absen Masuk!',
          'subtitle': 'Sen ✓ · Sel ✓ · Rab ✓ · Kam ✓ · Jum ★',
          'cta': widget.hasCheckedIn ? '📘 Jurnal' : '📷 Absen',
        },
      );
    } catch (_) {
      // Safe no-op during widget tests or non-Android runtimes
    }
  }

  Future<void> _pinOrPreviewWidget(BuildContext context) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _syncNativeAndroidWidget();
        final pinned =
            await _channel.invokeMethod<bool>('requestPinHomeWidget') ?? false;
        if (pinned && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Widget Absensi PKL ditambahkan ke layar utama.'),
            ),
          );
          return;
        }
      } catch (_) {}
    }
    if (!context.mounted) return;
    await _openInteractivePreviewSheet(context);
  }

  Future<void> _openInteractivePreviewSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final mode = _effectiveMode;
            final theme = Theme.of(ctx);
            final bottomInset = MediaQuery.paddingOf(ctx).bottom;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.lg + bottomInset,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Preview Widget Home (Ala Duolingo)',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightSurfaceSoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          '4×2 & 2×2',
                          style: TextStyle(
                            color: AppColors.lightPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        _ModeChip(
                          label: '1. Pagi (Belum Absen)',
                          selected: mode == DuolingoWidgetMode.morningReminder,
                          onTap: () {
                            setState(() {
                              _overrideMode =
                                  DuolingoWidgetMode.morningReminder;
                            });
                            setSheetState(() {});
                          },
                        ),
                        const SizedBox(width: 8),
                        _ModeChip(
                          label: '2. Sudah Absen (Streak)',
                          selected: mode == DuolingoWidgetMode.streakActive,
                          onTap: () {
                            setState(() {
                              _overrideMode = DuolingoWidgetMode.streakActive;
                            });
                            setSheetState(() {});
                          },
                        ),
                        const SizedBox(width: 8),
                        _ModeChip(
                          label: '3. Sore (Pulang & Jurnal)',
                          selected: mode == DuolingoWidgetMode.eveningCheckout,
                          onTap: () {
                            setState(() {
                              _overrideMode =
                                  DuolingoWidgetMode.eveningCheckout;
                            });
                            setSheetState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTactileBanner(context, mode, inSheet: true),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                    icon: const Icon(Icons.widgets_rounded, size: 18),
                    label: const Text('Tutup Preview Widget'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTactileBanner(context, _effectiveMode, inSheet: false);
  }

  Widget _buildTactileBanner(
    BuildContext context,
    DuolingoWidgetMode mode, {
    required bool inSheet,
  }) {
    final streakCount = widget.streakDays <= 0 ? 15 : widget.streakDays;

    final (
      List<Color> bgGradient,
      Color borderColor,
      Color bottomLipColor,
      Color titleColor,
      Color subColor,
      String streakBadgeText,
      String headline,
      String subtitle,
      String ctaLabel,
      Color ctaBg,
      Color ctaFg,
      Color ctaLip,
      VoidCallback onCtaTap,
    ) = switch (mode) {
      DuolingoWidgetMode.morningReminder => (
          const <Color>[Color(0xFFFFF9E6), Color(0xFFFFF2CC)],
          const Color(0xFFF6C324),
          const Color(0xFFD99B00),
          AppColors.lightCharcoal,
          const Color(0xFF64748B),
          '🔥 $streakCount Hari Streak',
          'Jangan Putus Streak!',
          widget.companyName,
          'Selfie',
          AppColors.lightCharcoal,
          Colors.white,
          Colors.black,
          widget.onPrimaryAction,
        ),
      DuolingoWidgetMode.eveningCheckout => (
          const <Color>[Color(0xFF1A1E26), Color(0xFF14161A)],
          const Color(0xFF333947),
          Colors.black,
          Colors.white,
          const Color(0xFF94A3B8),
          '⚡ $streakCount Hari Streak',
          'Tinggal 1 Langkah!',
          widget.companyName,
          'Pulang',
          AppColors.lightYellow,
          AppColors.lightCharcoal,
          const Color(0xFFC89600),
          widget.onPrimaryAction,
        ),
      DuolingoWidgetMode.streakActive => (
          const <Color>[Color(0xFF29AAFF), Color(0xFF138CEB)],
          const Color(0xFF5CC0FF),
          const Color(0xFF0C68B5),
          Colors.white,
          const Color(0xFFEAF4FF),
          '🔥 $streakCount Hari Streak',
          'Streak Absen Aman!',
          widget.companyName,
          'Jurnal',
          Colors.white,
          AppColors.lightCharcoal,
          const Color(0xFFCFE5FF),
          widget.onJournalAction,
        ),
    };

    const days = <String>['Sen', 'Sel', 'Rab', 'Kam', 'Jum'];

    return Container(
      decoration: BoxDecoration(
        color: bottomLipColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: bgGradient,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      streakBadgeText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.lightCharcoal,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (!inSheet)
                  BouncyTap(
                    onTap: () => _pinOrPreviewWidget(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: mode == DuolingoWidgetMode.morningReminder
                            ? Colors.black.withValues(alpha: 0.07)
                            : Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.widgets_rounded,
                            size: 13,
                            color: titleColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Widget',
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        headline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: subColor,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SvgPicture.asset(
                    'assets/illustrations/logo_glyph.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: mode == DuolingoWidgetMode.morningReminder
                    ? Colors.black.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        for (var i = 0; i < days.length; i++)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: i < 4
                                      ? AppColors.lightYellow
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  border: i == 4
                                      ? Border.all(
                                          color: AppColors.lightYellow,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  i < 4 ? '✓' : '★',
                                  style: TextStyle(
                                    color: i < 4
                                        ? AppColors.lightCharcoal
                                        : AppColors.lightPrimary,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                days[i],
                                style: TextStyle(
                                  color: titleColor.withValues(alpha: 0.88),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  BouncyTap(
                    onTap: onCtaTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ctaLip,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: ctaBg,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          ctaLabel,
                          style: TextStyle(
                            color: ctaFg,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : colorScheme.onSurface,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
