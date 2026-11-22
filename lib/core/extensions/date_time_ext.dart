import 'package:intl/intl.dart';

/// Pure Dart date/time formatting helpers tailored for Indonesian operational UI.
extension DateTimeFormattingExt on DateTime {
  static const List<String> _weekdays = <String>[
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _monthsFull = <String>[
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> _monthsShort = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  String toTimeHms() => DateFormat('HH:mm:ss').format(this);

  String toTimeHm() => DateFormat('HH:mm').format(this);

  String toIndonesianFullDate() {
    final dayName = _weekdays[weekday - 1];
    final monthName = _monthsFull[month - 1];
    return '$dayName, $day $monthName $year';
  }

  String toIndonesianShortDate() {
    final monthName = _monthsShort[month - 1];
    return '$day $monthName $year';
  }

  String toIndonesianMonthYear() {
    final monthName = _monthsFull[month - 1];
    return '$monthName $year';
  }

  bool isSameCalendarDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
