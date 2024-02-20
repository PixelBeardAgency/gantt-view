import 'package:gantt_view/gantt_view.dart';

abstract class GridRow {
  String label;

  GridRow(this.label);
}

class ActivityGridRow extends GridRow {
  ActivityGridRow(super.label);
}

class TaskGridRow extends GridRow {
  final GanttTask task;

  TaskGridRow(this.task) : super(task.label);
}
