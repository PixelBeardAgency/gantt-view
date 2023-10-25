import 'package:gantt_view/src/model/cell/grid/grid_cell.dart';
import 'package:gantt_view/src/model/cell/header/header_cell.dart';
import 'package:gantt_view/src/model/gantt_activity.dart';
import 'package:gantt_view/src/model/gantt_data.dart';

abstract class CellBuilder {
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

    final weekendOffset = startDate.weekday - DateTime.monday;
    List<HeaderCell> headers = [];
    List<List<GridCell?>> cells = [];
    int currentRow = 0;

    final int activityCount = data.activities.length;
    for (int i = 0; i < activityCount; i++) {
      var activity = data.activities[i];
      if (activity.label != null) {
        List<GridCell?> row = List.generate(columns, (index) => null);
        headers.add(ActivityHeaderCell(activity.label));
        for (int i = 0; i < columns; i++) {
          final currentOffset = (weekendOffset + i) % 7;
          final isWeekend = currentOffset == 5 || currentOffset == 6;

          final isHighlighted = highlightedColumns.contains(i);

          row[i] = isHighlighted
              ? HolidayGridCell()
              : (isWeekend)
                  ? WeekendGridCell()
                  : ActivityGridCell();
        }
        cells.add(row);
        currentRow++;
      }
      int taskCount = activity.tasks.length;
      for (int j = 0; j < taskCount; j++) {
        List<GridCell?> row = List.generate(columns, (index) => null);
        final task = activity.tasks[j];
        headers.add(TaskHeaderCell(task.label));

        final start = task.startDate;
        final end = task.endDate;

        final int from = start.difference(startDate).inDays;
        final int to = end.difference(startDate).inDays;

        if (start.isAtSameMomentAs(end) && start.isAfter(end)) {
          throw Exception('Start date must be before or same as end date.');
        }

        for (int k = 0; k < columns; k++) {
          final currentOffset = (weekendOffset + k) % 7;
          final isWeekend = currentOffset == 5 || currentOffset == 6;

          final isHighlighted = highlightedColumns.contains(k);

          final isTask = k >= from && k <= to;

          if (isTask) {
            row[k] = TaskGridCell(
              task.tooltip,
              k == from,
              k == to,
              isHighlighted: isHighlighted,
              isWeekend: isWeekend,
            );
          } else if (isHighlighted) {
            row[k] = HolidayGridCell();
          } else if (isWeekend) {
            row[k] = WeekendGridCell();
          }
        }
        cells.add(row);
        currentRow++;
      }
    }
    return GanttData(
      activities: data.activities,
      gridCells: cells,
      headerCells: headers,
      startDate: startDate,
      columns: columns,
      rows: currentRow,
      showFullWeeks: data.showFullWeeks,
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
