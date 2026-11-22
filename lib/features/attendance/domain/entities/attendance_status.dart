/// Attendance status categories for daily records and monthly recaps.
enum AttendanceStatus {
  present('Hadir'),
  late('Terlambat'),
  leave('Izin/Sakit'),
  absent('Alpha');

  const AttendanceStatus(this.label);

  final String label;
}
