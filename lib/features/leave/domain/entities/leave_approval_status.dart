/// Approval lifecycle status for student leave requests.
enum LeaveApprovalStatus {
  submitted('Diajukan'),
  approved('Disetujui'),
  rejected('Ditolak');

  const LeaveApprovalStatus(this.label);

  final String label;
}
