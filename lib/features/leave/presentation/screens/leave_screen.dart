import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/errors/app_error.dart';
import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/services/camera_datasource.dart';
import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_character.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_media_attachment_field.dart';
import '../../../../core/widgets/character_refresh_indicator.dart';
import '../../../../core/widgets/motion_widgets.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../domain/entities/leave_approval_status.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_type.dart';
import '../notifiers/leave_notifier.dart';
import '../widgets/leave_request_card.dart';

/// Concise Orisale v4 Izin & Sakit view.
class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key});

  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();

  LeaveType _selectedType = LeaveType.sakit;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  CapturedSelfie? _attachment;
  bool _isSubmitting = false;
  String? _feedbackMessage;
  bool _feedbackIsError = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (!mounted || picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
      _feedbackMessage = null;
      _feedbackIsError = false;
    });

    final request = LeaveRequest(
      id: '',
      type: _selectedType,
      startDate: _startDate,
      endDate: _endDate,
      reason: _reasonController.text.trim(),
      attachmentName: _attachment?.storageValue,
      status: LeaveApprovalStatus.submitted,
      submittedAt: DateTime.now(),
    );

    try {
      await ref.read(leaveProvider.notifier).submitRequest(request);
      if (!mounted) return;
      unawaited(HapticFeedback.lightImpact());
      _reasonController.clear();
      setState(() {
        _isSubmitting = false;
        _attachment = null;
        _feedbackIsError = false;
        _feedbackMessage = 'Pengajuan berhasil dikirim ke pembimbing.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _feedbackIsError = true;
        _feedbackMessage = AppErrorMapper.fromObject(error).userMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveAsync = ref.watch(leaveProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bannerBg =
        isDark ? AppColors.darkSurfaceSoft : AppColors.lightSurfaceSoft;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        child: CharacterRefreshIndicator(
          onRefresh: () async => ref.invalidate(leaveProvider),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl + bottomInset,
              ),
              children: <Widget>[
                Text(
                  'Izin & Sakit',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FadeSlideIn(
                  delayMs: 25,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: bannerBg,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pengajuan Izin',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        GentleFloat(
                          amplitude: 3.5,
                          child: SizedBox(
                            width: 68,
                            height: 50,
                            child: SvgPicture.asset(
                              'assets/illustrations/undraw_izin.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CupertinoSlidingSegmentedControl<LeaveType>(
                  key: AppWidgetKeys.leaveTypeSegment,
                  groupValue: _selectedType,
                  backgroundColor: colorScheme.secondaryContainer,
                  thumbColor: colorScheme.surface,
                  children: <LeaveType, Widget>{
                    LeaveType.sakit: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Sakit',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    LeaveType.izin: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Izin Resmi',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  },
                  onValueChanged: (value) {
                    if (value == null || _isSubmitting) return;
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _selectedType = value);
                  },
                ),
                if (_feedbackMessage != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: _feedbackIsError
                          ? (isDark
                              ? AppColors.roseSoftDark
                              : AppColors.roseSoftLight)
                          : (isDark
                              ? AppColors.emeraldSoftDark
                              : AppColors.emeraldSoftLight),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Text(
                      _feedbackMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : (_feedbackIsError
                                ? AppColors.rose
                                : AppColors.emerald),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Form(
                  key: _formKey,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(
                        color: colorScheme.outline,
                        width: AppSpacing.hairlineBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _LeaveDateRow(
                          label: 'Mulai',
                          value: _startDate.toIndonesianShortDate(),
                          onTap: _isSubmitting
                              ? null
                              : () => _pickDate(isStart: true),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: AppSpacing.lg),
                          child: Divider(
                            height: AppSpacing.hairlineBorder,
                            thickness: AppSpacing.hairlineBorder,
                          ),
                        ),
                        _LeaveDateRow(
                          label: 'Selesai',
                          value: _endDate.toIndonesianShortDate(),
                          onTap: _isSubmitting
                              ? null
                              : () => _pickDate(isStart: false),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: AppSpacing.lg),
                          child: Divider(
                            height: AppSpacing.hairlineBorder,
                            thickness: AppSpacing.hairlineBorder,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.md,
                            AppSpacing.lg,
                            AppSpacing.sm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Alasan',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              TextFormField(
                                key: AppWidgetKeys.leaveReasonField,
                                controller: _reasonController,
                                enabled: !_isSubmitting,
                                maxLines: 3,
                                minLines: 2,
                                decoration: const InputDecoration(
                                  hintText: 'Keterangan (min. 10 karakter)',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 10) {
                                    return 'Keterangan minimal 10 karakter.';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppMediaAttachmentField(
                  title: 'Lampiran',
                  attachment: _attachment,
                  enabled: !_isSubmitting,
                  isLeaveDocument: true,
                  onChanged: (next) {
                    setState(() {
                      _attachment = next;
                    });
                  },
                  onError: (msg) {
                    setState(() {
                      _feedbackIsError = true;
                      _feedbackMessage = msg;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  key: AppWidgetKeys.leaveSubmitButton,
                  onPressed: _isSubmitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(_isSubmitting ? 'Mengirim' : 'Kirim'),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Riwayat',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                leaveAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
                  error: (error, _) => AppErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(leaveProvider),
                    onReLogin: () => ref.read(authProvider.notifier).logout(),
                  ),
                  data: (requests) {
                    if (requests.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(
                            color: colorScheme.outline,
                            width: AppSpacing.hairlineBorder,
                          ),
                        ),
                        child: const AppEmptyCharacter(
                          message: 'Belum ada pengajuan.',
                          assetPath: 'assets/illustrations/undraw_izin.svg',
                          imageHeight: 92,
                        ),
                      );
                    }
                    return Column(
                      children: <Widget>[
                        for (var i = 0; i < requests.length; i++) ...<Widget>[
                          FadeSlideIn(
                            delayMs: (i * 45).clamp(0, 220),
                            offsetY: 16,
                            child: LeaveRequestCard(
                              request: requests[i],
                              highlight: i == 0,
                            ),
                          ),
                          if (i < requests.length - 1)
                            const SizedBox(height: AppSpacing.sm),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

class _LeaveDateRow extends StatelessWidget {
  const _LeaveDateRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              constraints: const BoxConstraints(minHeight: 36),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + 2,
              ),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              alignment: Alignment.center,
              child: Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
