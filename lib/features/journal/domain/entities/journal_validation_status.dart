/// Mentor validation state for a daily PKL journal entry.
enum JournalValidationStatus {
  pending('Menunggu'),
  approved('Disetujui'),
  revision('Perlu Revisi');

  const JournalValidationStatus(this.label);

  final String label;
}
