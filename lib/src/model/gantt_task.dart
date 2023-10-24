class GanttTask {
  final String label;
  final DateTime startDate;
  final DateTime endDate;
  final String? tooltip;

  GanttTask({
    required this.label,
    required this.startDate,
    required this.endDate,
    this.tooltip,
  });
}
