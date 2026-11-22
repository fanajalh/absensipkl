/// Filter chips for the monthly attendance history screen.
enum HistoryFilter {
  all('Semua'),
  present('Hadir'),
  late('Terlambat'),
  leave('Izin/Sakit'),
  absent('Alpha');

  const HistoryFilter(this.label);

  final String label;
}
