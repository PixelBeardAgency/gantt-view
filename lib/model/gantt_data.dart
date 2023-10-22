import 'package:gantt_view/model/cell/grid/grid_cell.dart';
import 'package:gantt_view/model/cell/header/header_cell.dart';
import 'package:gantt_view/model/gantt_activity.dart';

class GanttData {
  final List<GanttActivity> activities;
  final Map<int, Map<int, GridCell>> gridCells;
  final List<HeaderCell> headerCells;
  final DateTime startDate;
  final int columns;
  final int rows;
  final bool showFullWeeks;

  GanttData({
    required this.activities,
    required this.gridCells,
    required this.headerCells,
    required this.startDate,
    required this.columns,
    required this.rows,
    required this.showFullWeeks,
  });
}
