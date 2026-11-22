/// Leave categories supported by PKL student administration.
enum LeaveType {
  izin('Izin'),
  sakit('Sakit');

  const LeaveType(this.label);

  final String label;
}
