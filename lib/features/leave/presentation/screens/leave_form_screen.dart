import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_error.dart';
import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/services/camera_datasource.dart';
import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/leave_approval_status.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_type.dart';
import '../notifiers/leave_notifier.dart';

/// Submission screen for PKL Izin / Sakit with date range & reason validation.
class LeaveFormScreen extends ConsumerStatefulWidget {
  const LeaveFormScreen({super.key});

  @override
  ConsumerState<LeaveFormScreen> createState() => _LeaveFormScreenState();
}

class _LeaveFormScreenState extends ConsumerState<LeaveFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();

  LeaveType _selectedType = LeaveType.izin;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String? _attachmentName;
  bool _isSubmitting = false;
  String? _submitError;

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

  Future<void> _attachSupportingPhoto() async {
    FocusScope.of(context).unfocus();
    try {
      final captured = await ref.read(cameraDatasourceProvider).captureSelfie();
      if (!mounted || captured == null) return;
      setState(() {
        _attachmentName = captured.fileName;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitError = AppErrorMapper.fromObject(error).userMessage;
      });
    }
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final request = LeaveRequest(
      id: '',
      type: _selectedType,
      startDate: _startDate,
      endDate: _endDate,
      reason: _reasonController.text.trim(),
      attachmentName: _attachmentName,
      status: LeaveApprovalStatus.submitted,
      submittedAt: DateTime.now(),
    );

    try {
      await ref.read(leaveProvider.notifier).submitRequest(request);
      if (!mounted) return;
      unawaited(HapticFeedback.lightImpact());
      context.pop();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _submitError = AppErrorMapper.fromObject(error).userMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pengajuan Izin / Sakit'),
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (_submitError != null) ...<Widget>[
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.roseSoftDark
                                  : AppColors.roseSoftLight,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusSm),
                              border: Border.all(
                                color: AppColors.rose.withAlpha(90),
                              ),
                            ),
                            child: Text(
                              _submitError!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.rose,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        Text(
                          'Jenis Pengajuan',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SegmentedButton<LeaveType>(
                          segments: const <ButtonSegment<LeaveType>>[
                            ButtonSegment<LeaveType>(
                              value: LeaveType.izin,
                              label: Text('Izin'),
                              icon: Icon(Icons.event_note_outlined, size: 18),
                            ),
                            ButtonSegment<LeaveType>(
                              value: LeaveType.sakit,
                              label: Text('Sakit'),
                              icon:
                                  Icon(Icons.medical_services_outlined, size: 18),
                            ),
                          ],
                          selected: <LeaveType>{_selectedType},
                          onSelectionChanged: _isSubmitting
                              ? null
                              : (selection) {
                                  setState(
                                    () => _selectedType = selection.first,
                                  );
                                },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _DateFieldBox(
                                label: 'Tanggal Mulai',
                                value: _startDate.toIndonesianShortDate(),
                                onTap: _isSubmitting
                                    ? null
                                    : () => _pickDate(isStart: true),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _DateFieldBox(
                                label: 'Tanggal Selesai',
                                value: _endDate.toIndonesianShortDate(),
                                onTap: _isSubmitting
                                    ? null
                                    : () => _pickDate(isStart: false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          key: AppWidgetKeys.leaveReasonField,
                          controller: _reasonController,
                          enabled: !_isSubmitting,
                          maxLines: 4,
                          minLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Keterangan / Alasan',
                            hintText:
                                'Tuliskan alasan izin atau kondisi sakit (minimal 10 karakter).',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 10) {
                              return 'Keterangan minimal 10 karakter.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        OutlinedButton.icon(
                          onPressed:
                              _isSubmitting ? null : _attachSupportingPhoto,
                          icon: const Icon(Icons.camera_alt_outlined, size: 18),
                          label: Text(
                            _attachmentName == null
                                ? 'Lampirkan Foto Surat (Opsional)'
                                : 'Lampiran: $_attachmentName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_attachmentName != null) ...<Widget>[
                          const SizedBox(height: AppSpacing.xs),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () =>
                                      setState(() => _attachmentName = null),
                              child: Text(
                                'Hapus Lampiran',
                                style: TextStyle(color: colorScheme.error),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl),
                        FilledButton(
                          key: AppWidgetKeys.leaveSubmitButton,
                          onPressed: _isSubmitting ? null : _submit,
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Kirim Pengajuan'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DateFieldBox extends StatelessWidget {
  const _DateFieldBox({
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        constraints: const BoxConstraints(minHeight: 54),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: colorScheme.outline,
            width: AppSpacing.hairlineBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
