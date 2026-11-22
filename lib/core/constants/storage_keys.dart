/// Keys for secure and local persistence layers. Never inline raw key strings.
abstract final class StorageKeys {
  static const String authSession = 'absensi_pkl_auth_session_v1';
  static const String appSettings = 'absensi_pkl_app_settings_v1';
  static const String attendanceRecords = 'absensi_pkl_attendance_records_v1';
  static const String journalEntries = 'absensi_pkl_journal_entries_v1';
  static const String leaveRequests = 'absensi_pkl_leave_requests_v1';
}
