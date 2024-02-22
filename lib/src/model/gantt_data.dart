import 'package:gantt_view/src/model/grid_row.dart';

class GanttData {
  final DateTime startDate;
  final int columnCount;
  final List<GridRow> rows;
  final bool showFullWeeks;
  final Iterable<int> highlightedColumns;

  GanttData({
    required this.startDate,
    required this.columnCount,
    required this.rows,
    required this.showFullWeeks,
    required this.highlightedColumns,
  });
}
