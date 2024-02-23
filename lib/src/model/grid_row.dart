abstract class GridRow {
  GridRow();
}

class ActivityGridRow extends GridRow {
  final String? label;

  ActivityGridRow(this.label);
}

class TaskGridRow<T> extends GridRow {
  final DateTime startDate;
  final DateTime endDate;
  final T data;
  final String? tooltip;

  TaskGridRow({
    required this.startDate,
    required this.endDate,
    required this.data,
    this.tooltip,
  });
}
