import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/gantt_activity.dart';

class GanttData {
  final List<GanttActivity> activities;
  final DateTime startDate;
  final int columnCount;
  final List<GridRow> rows;
  final bool showFullWeeks;
  final Iterable<int> highlightedColumns;

  GanttData({
    required this.activities,
    required this.startDate,
    required this.columnCount,
    required this.rows,
    required this.showFullWeeks,
    required this.highlightedColumns,
  });
}
