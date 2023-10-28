import 'package:gantt_view/src/model/grid_row.dart';
import 'package:gantt_view/src/model/gantt_activity.dart';
import 'package:gantt_view/src/model/gantt_data.dart';

abstract class DataBuilder {
  static GanttData buildGridCells(BuildCellsData data) {
    final allTasks = data.activities.expand((a) => a.tasks);
    final firstTaskStartDate = allTasks
        .reduce((value, element) =>
            value.startDate.isBefore(element.startDate) ? value : element)
        .startDate;

    final startDate = DateTime(
      firstTaskStartDate.year,
      firstTaskStartDate.month,
      firstTaskStartDate.day +
          (data.showFullWeeks
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
        diff + 1 + (data.showFullWeeks ? 7 - lastTaskEndDate.weekday : 0);

    final highlightedColumns = data.highlightedDates
        .map<int>((date) => date.difference(startDate).inDays);

    List<GridRow> rows = [];

    final int activityCount = data.activities.length;
    for (int i = 0; i < activityCount; i++) {
      var activity = data.activities[i];
      if (activity.label != null) {
        rows.add(ActivityGridRow(activity.label));
      }
      int taskCount = activity.tasks.length;
      for (int j = 0; j < taskCount; j++) {
        rows.add(TaskGridRow(activity.tasks[j]));
      }
    }
    return GanttData(
      activities: data.activities,
      startDate: startDate,
      columnCount: columns,
      rows: rows,
      showFullWeeks: data.showFullWeeks,
      highlightedColumns: highlightedColumns,
    );
  }
}

class BuildCellsData {
  final List<GanttActivity> activities;
  List<DateTime> highlightedDates;
  bool showFullWeeks;

  BuildCellsData({
    required this.activities,
    this.highlightedDates = const [],
    this.showFullWeeks = false,
  });
}
