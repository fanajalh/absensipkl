import 'package:flutter/foundation.dart';

/// Central registry of [ValueKey] identifiers for widget & integration tests.
abstract final class AppWidgetKeys {
  // Onboarding
  static const Key onboardingSkipButton = ValueKey('onboarding_skip_button');
  static const Key onboardingNextButton = ValueKey('onboarding_next_button');

  // Auth
  static const Key loginNisnField = ValueKey('login_nisn_field');
  static const Key loginPasswordField = ValueKey('login_password_field');
  static const Key loginSubmitButton = ValueKey('login_submit_button');
  static const Key loginDemoFillButton = ValueKey('login_demo_fill_button');
  static const Key logoutButton = ValueKey('logout_button');

  // Navigation Shell Tabs & Center Camera Dock
  static const Key navTabPresensi = ValueKey('nav_tab_presensi');
  static const Key navTabJurnal = ValueKey('nav_tab_jurnal');
  static const Key navCameraCenterButton = ValueKey('nav_camera_center_button');
  static const Key navTabIzin = ValueKey('nav_tab_izin');
  static const Key navTabRiwayat = ValueKey('nav_tab_riwayat');

  // Beranda / Attendance Home
  static const Key profileAvatarButton = ValueKey('profile_avatar_button');
  static const Key announcementsButton = ValueKey('announcements_button');
  static const Key mapShortcutButton = ValueKey('map_shortcut_button');
  static const Key liveClockText = ValueKey('live_clock_text');
  static const Key refreshLocationButton = ValueKey('refresh_location_button');
  static const Key geofenceTestSheetButton =
      ValueKey('geofence_test_sheet_button');
  static const Key checkActionButton = ValueKey('check_action_button');
  static const Key confirmSelfieSubmitButton =
      ValueKey('confirm_selfie_submit_button');
  static const Key geofencePresetInside = ValueKey('geofence_preset_inside');
  static const Key geofencePresetOutside = ValueKey('geofence_preset_outside');
  static const Key geofencePresetMock = ValueKey('geofence_preset_mock');

  // Map & Selfie Screens
  static const Key mapContinueSelfieButton =
      ValueKey('map_continue_selfie_button');
  static const Key selfieCancelButton = ValueKey('selfie_cancel_button');
  static const Key selfieShutterButton = ValueKey('selfie_shutter_button');

  // Journal
  static const Key addJournalButton = ValueKey('add_journal_button');
  static const Key journalTitleField = ValueKey('journal_title_field');
  static const Key journalDescriptionField =
      ValueKey('journal_description_field');
  static const Key journalCameraPhotoButton =
      ValueKey('journal_camera_photo_button');
  static const Key journalGalleryPhotoButton =
      ValueKey('journal_gallery_photo_button');
  static const Key journalSaveButton = ValueKey('journal_save_button');

  // Leave
  static const Key leaveTypeSegment = ValueKey('leave_type_segment');
  static const Key leaveReasonField = ValueKey('leave_reason_field');
  static const Key leaveSubmitButton = ValueKey('leave_submit_button');

  // History
  static const Key historyFilterSegment = ValueKey('history_filter_segment');

  // Profile & Settings
  static const Key settingsButton = ValueKey('settings_button');
  static const Key settingsCheckInReminderSwitch =
      ValueKey('settings_checkin_reminder_switch');
  static const Key settingsJournalReminderSwitch =
      ValueKey('settings_journal_reminder_switch');
  static const Key settingsDarkModeSwitch =
      ValueKey('settings_dark_mode_switch');
  static const Key settingsQaSimulationRow =
      ValueKey('settings_qa_simulation_row');
}
