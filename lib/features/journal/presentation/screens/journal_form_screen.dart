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
import '../../../../core/widgets/app_header_buttons.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_validation_status.dart';
import '../notifiers/journal_notifier.dart';

/// Concise create/edit PKL journal form with compressed photo documentation.
class JournalFormScreen extends ConsumerStatefulWidget {
  const JournalFormScreen({
    super.key,
    this.entryId,
  });

  final String? entryId;

  @override
  ConsumerState<JournalFormScreen> createState() => _JournalFormScreenState();
}

class _JournalFormScreenState extends ConsumerState<JournalFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  String? _photoUrl;
  Uint8List? _photoBytes;
  JournalEntry? _editingEntry;
  bool _initialized = false;
  bool _isSaving = false;
  String? _submitError;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _hydrateIfEditing(List<JournalEntry> entries) {
    if (_initialized) return;
    _initialized = true;
    final targetId = widget.entryId;
    if (targetId == null || targetId.isEmpty) return;

    for (final entry in entries) {
      if (entry.id == targetId) {
        _editingEntry = entry;
        _selectedDate = entry.date;
        _titleController.text = entry.title;
        _descriptionController.text = entry.description;
        _startTime = _parseTimeOfDay(entry.startTime) ?? _startTime;
        _endTime = _parseTimeOfDay(entry.endTime) ?? _endTime;
        _photoUrl = entry.photoUrl;
        break;
      }
    }
  }

  TimeOfDay? _parseTimeOfDay(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (!mounted || picked == null) return;
    setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    FocusScope.of(context).unfocus();
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (!mounted || picked == null) return;
    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  Future<void> _pickPhoto({required bool fromGallery}) async {
    FocusScope.of(context).unfocus();
    try {
      final captured = await ref
          .read(cameraDatasourceProvider)
          .captureJournalPhoto(fromGallery: fromGallery);
      if (!mounted || captured == null) return;
      setState(() {
        _photoUrl = captured.fileName;
        _photoBytes = captured.bytes;
        _submitError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitError = AppErrorMapper.fromObject(error).userMessage;
      });
    }
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isSaving = true;
      _submitError = null;
    });

    final entry = JournalEntry(
      id: _editingEntry?.id ?? '',
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _formatTimeOfDay(_startTime),
      endTime: _formatTimeOfDay(_endTime),
      status: _editingEntry?.status ?? JournalValidationStatus.pending,
      photoUrl: _photoUrl,
      mentorNote: _editingEntry?.mentorNote,
    );

    try {
      await ref.read(journalProvider.notifier).saveEntry(entry);
      if (!mounted) return;
      unawaited(HapticFeedback.lightImpact());
      context.pop();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _submitError = AppErrorMapper.fromObject(error).userMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(journalProvider).asData?.value ?? <JournalEntry>[];
    _hydrateIfEditing(entries);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isEditMode = _editingEntry != null;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 108,
        leading: AppHeaderBackButton(
          label: 'Jurnal',
          onPressed: () => context.pop(),
        ),
        title: Text(isEditMode ? 'Edit Jurnal' : 'Tambah Jurnal'),
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
                        _PickerRowButton(
                          label: 'Tanggal',
                          value: _selectedDate.toIndonesianShortDate(),
                          icon: Icons.calendar_today_outlined,
                          onTap: _isSaving ? null : _pickDate,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _PickerRowButton(
                                label: 'Mulai',
                                value: _formatTimeOfDay(_startTime),
                                icon: Icons.schedule_outlined,
                                onTap: _isSaving
                                    ? null
                                    : () => _pickTime(isStart: true),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _PickerRowButton(
                                label: 'Selesai',
                                value: _formatTimeOfDay(_endTime),
                                icon: Icons.schedule_outlined,
                                onTap: _isSaving
                                    ? null
                                    : () => _pickTime(isStart: false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          key: AppWidgetKeys.journalTitleField,
                          controller: _titleController,
                          focusNode: _titleFocus,
                          enabled: !_isSaving,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Judul Kegiatan',
                            hintText: 'Contoh: Slicing UI Presensi',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Judul kegiatan wajib diisi.';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) =>
                              _descriptionFocus.requestFocus(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          key: AppWidgetKeys.journalDescriptionField,
                          controller: _descriptionController,
                          focusNode: _descriptionFocus,
                          enabled: !_isSaving,
                          maxLines: 4,
                          minLines: 3,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            labelText: 'Deskripsi',
                            hintText: 'Ringkasan pekerjaan (min. 15 karakter)',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 15) {
                              return 'Deskripsi minimal 15 karakter.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  if (_photoBytes != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        _photoBytes!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        cacheWidth: 120,
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.photo_camera_outlined,
                                      size: 20,
                                      color: colorScheme.primary,
                                    ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      _photoUrl ?? 'Foto Bukti (Opsional)',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (_photoUrl != null)
                                    IconButton(
                                      tooltip: 'Hapus foto',
                                      constraints: const BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 36,
                                      ),
                                      onPressed: _isSaving
                                          ? null
                                          : () => setState(() {
                                                _photoUrl = null;
                                                _photoBytes = null;
                                              }),
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      key: AppWidgetKeys
                                          .journalCameraPhotoButton,
                                      onPressed: _isSaving
                                          ? null
                                          : () =>
                                              _pickPhoto(fromGallery: false),
                                      icon: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 16,
                                      ),
                                      label: const Text('Kamera'),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      key: AppWidgetKeys
                                          .journalGalleryPhotoButton,
                                      onPressed: _isSaving
                                          ? null
                                          : () =>
                                              _pickPhoto(fromGallery: true),
                                      icon: const Icon(
                                        Icons.photo_library_outlined,
                                        size: 16,
                                      ),
                                      label: const Text('Galeri'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        FilledButton(
                          key: AppWidgetKeys.journalSaveButton,
                          onPressed: _isSaving ? null : _save,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  isEditMode ? 'Simpan' : 'Simpan Jurnal',
                                ),
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

class _PickerRowButton extends StatelessWidget {
  const _PickerRowButton({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
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
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
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
