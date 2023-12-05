import 'package:gantt_view/gantt_view.dart';
import 'package:gantt_view/src/model/gantt_activity.dart';
import 'package:gantt_view/src/model/grid_row.dart';

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

  GanttData.empty()
      : activities = [],
        startDate = DateTime.now(),
        columnCount = 0,
        rows = [],
        showFullWeeks = false,
        highlightedColumns = [];

  factory GanttData.build(GanttDataInput input) {
    if (input.activities.isEmpty) {
      return GanttData.empty();
    }

    final allTasks = input.activities.expand((a) => a.tasks);
    final firstTaskStartDate = allTasks
        .reduce((value, element) =>
            value.startDate.isBefore(element.startDate) ? value : element)
        .startDate;

    final startDate = DateTime(
      firstTaskStartDate.year,
      firstTaskStartDate.month,
      firstTaskStartDate.day +
          (input.showFullWeeks
              ? DateTime.monday - firstTaskStartDate.weekday
              : 0),
    );

    final lastTaskEndDate = allTasks
        .reduce((value, element) =>
            value.endDate.isAfter(element.endDate) ? value : element)
        .endDate;

    final endDate = DateTime(
      lastTaskEndDate.year,
      lastTaskEndDate.month,
      lastTaskEndDate.day,
    );

    final diff = endDate.difference(startDate).inDays;
    final columns =
        diff + 1 + (input.showFullWeeks ? 7 - lastTaskEndDate.weekday : 0);

    final highlightedColumns = input.highlightedDates
        .map<int>((date) => date.difference(startDate).inDays);

    List<GridRow> rows = [];

    final int activityCount = input.activities.length;
    for (int i = 0; i < activityCount; i++) {
      var activity = input.activities[i];
      if (activity.label != null) {
        rows.add(ActivityGridRow(activity.label));
      }
      int taskCount = activity.tasks.length;
      for (int j = 0; j < taskCount; j++) {
        rows.add(TaskGridRow(activity.tasks[j]));
      }
    }
    return GanttData(
      activities: input.activities,
      startDate: startDate,
      columnCount: columns,
      rows: rows,
      showFullWeeks: input.showFullWeeks,
      highlightedColumns: highlightedColumns,
    );
  }
}
